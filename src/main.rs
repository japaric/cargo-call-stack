#![deny(warnings)]

use core::{
    cmp,
    fmt::{self, Write as _},
    ops, str,
};
use std::{
    borrow::Cow,
    collections::{BTreeMap, HashMap, HashSet},
    env,
    fs::{self, File},
    io::{self, BufRead, BufReader, Read, Write},
    path::PathBuf,
    process::{self, Command, Stdio},
    time::SystemTime,
};

use anyhow::{anyhow, bail};
use ar::Archive;
use cargo_project::{Artifact, Profile, Project};
use clap::Parser;
use env_logger::{Builder, Env};
use filetime::FileTime;
use log::{error, warn};
use petgraph::{
    algo,
    graph::{DiGraph, NodeIndex},
    visit::{Dfs, Reversed, Topo},
    Direction, Graph,
};
use walkdir::WalkDir;
use xmas_elf::{sections::SectionData, symbol_table::Entry, ElfFile};

use crate::{
    ir::{FnSig, Item, Stmt, Type},
    thumb::Tag,
};

mod ir;
mod thumb;
mod wrapper;

/// Generate a call graph and perform whole program stack usage analysis
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Target triple for which the code is compiled
    #[arg(long, value_name = "TRIPLE")]
    target: Option<String>,

    /// Build only the specified binary
    #[arg(long, value_name = "BIN")]
    bin: Option<String>,

    /// Build only the specified example
    #[arg(long, value_name = "NAME")]
    example: Option<String>,

    /// Space-separated list of features to activate
    #[arg(long, value_name = "FEATURES")]
    features: Option<String>,

    /// Activate all available features
    #[arg(long)]
    all_features: bool,

    /// Use verbose output
    #[arg(short, long)]
    verbose: bool,

    /// consider only the call graph that starts from this node
    start: Option<String>,
}

fn main() -> anyhow::Result<()> {
    match run() {
        Ok(ec) => process::exit(ec),
        Err(e) => {
            eprintln!("error: {}", e);
            process::exit(1)
        }
    }
}

// Font used in the dot graphs
const FONT: &str = "monospace";

#[allow(deprecated)]
fn run() -> anyhow::Result<i32> {
    if env::var_os("CARGO_CALL_STACK_RUSTC_WRAPPER").is_some() {
        return wrapper::wrapper();
    }

    Builder::from_env(Env::default().default_filter_or("warn")).init();

    let args = Args::parse();
    let profile = Profile::Release;

    let file = match (&args.example, &args.bin) {
        (Some(f), None) => f,
        (None, Some(f)) => f,
        _ => bail!("Please specify either --example <NAME> or --bin <NAME>."),
    };

    let meta = rustc_version::version_meta()?;
    let host = meta.host;
    let cwd = env::current_dir()?;
    let project = Project::query(cwd)?;
    let target_flag = args.target.as_deref();
    let target = project.target().or(target_flag).unwrap_or(&host);

    let mut is_no_std = false;
    {
        let output = Command::new("rustc")
            .args(&["--print=cfg", "--target", target])
            .output()?;
        for line in str::from_utf8(&output.stdout)?.lines() {
            if let Some(value) = line.strip_prefix("target_os=") {
                if value == "\"none\"" {
                    is_no_std = true;
                }
            }
        }
    };

    let mut cargo = Command::new("cargo");
    cargo.arg("rustc");

    // NOTE we do *not* use `project.target()` here because Cargo will figure things out on
    // its own (i.e. it will search and parse .cargo/config, etc.)
    if let Some(target) = target_flag {
        cargo.args(&["--target", target]);
    }

    if args.all_features {
        cargo.arg("--all-features");
    } else if let Some(features) = &args.features {
        cargo.args(&["--features", features]);
    }

    if args.example.is_some() {
        cargo.args(&["--example", file]);
    }

    if args.bin.is_some() {
        cargo.args(&["--bin", file]);
    }

    if profile.is_release() {
        cargo.arg("--release");
    }

    let build_std = if is_no_std {
        "-Zbuild-std=core,alloc,compiler_builtins"
    } else {
        "-Zbuild-std"
    };

    cargo.args(&[
        build_std,
        "--color=always",
        "--",
        // .ll file
        "--emit=llvm-ir,obj",
        // needed to produce a single .ll file
        "-C",
        "embed-bitcode=yes",
        "-C",
        "lto=fat",
    ]);

    cargo.env("CARGO_CALL_STACK_RUSTC_WRAPPER", "1");
    cargo.env("RUSTC_WRAPPER", env::current_exe()?);
    cargo.stderr(Stdio::piped());

    // "touch" some source file to trigger a rebuild
    let root = project.toml().parent().expect("UNREACHABLE");
    let now = FileTime::from_system_time(SystemTime::now());
    if !filetime::set_file_times(root.join("src/main.rs"), now, now).is_ok() {
        if !filetime::set_file_times(root.join("src/lib.rs"), now, now).is_ok() {
            // look for some rust source file and "touch" it
            let src = root.join("src");
            let haystack = if src.exists() { &src } else { root };

            for entry in WalkDir::new(haystack) {
                let entry = entry?;
                let path = entry.path();

                if path.extension().map(|ext| ext == "rs").unwrap_or(false) {
                    filetime::set_file_times(path, now, now)?;
                    break;
                }
            }
        }
    }

    if args.verbose {
        eprintln!("{:?}", cargo);
    }

    let mut child = cargo.spawn()?;
    let stderr = BufReader::new(child.stderr.take().unwrap());
    let mut compiler_builtins_rlib_path = None;
    let mut compiler_builtins_ll_path = None;
    for line in stderr.lines() {
        let line = line?;
        if line.starts_with(wrapper::COMPILER_BUILTINS_RLIB_PATH_MARKER) {
            let path = &line[wrapper::COMPILER_BUILTINS_RLIB_PATH_MARKER.len()..];
            compiler_builtins_rlib_path = Some(path.to_string());
        } else if line.starts_with(wrapper::COMPILER_BUILTINS_LL_PATH_MARKER) {
            let path = &line[wrapper::COMPILER_BUILTINS_LL_PATH_MARKER.len()..];
            compiler_builtins_ll_path = Some(path.to_string());
        } else {
            eprintln!("{}", line);
        }
    }

    let status = child.wait()?;

    if !status.success() {
        return Ok(status.code().unwrap_or(1));
    }

    let compiler_builtins_rlib_path =
        compiler_builtins_rlib_path.expect("`compiler_builtins` was not linked");
    let compiler_builtins_ll_path =
        compiler_builtins_ll_path.expect("`compiler_builtins` LLVM IR unavailable");

    let mut path: PathBuf = if args.example.is_some() {
        project.path(Artifact::Example(file), profile, target_flag, &host)?
    } else {
        project.path(Artifact::Bin(file), profile, target_flag, &host)?
    };

    let elf = fs::read(&path)
        .map_err(|e| anyhow!("couldn't open ELF file `{}`: {}", path.display(), e))?;

    // load llvm-ir file
    let mut ll = None;
    // most recently modified
    let mut mrm = SystemTime::UNIX_EPOCH;
    let prefix = format!("{}-", file.replace('-', "_"));

    path = path.parent().expect("unreachable").to_path_buf();

    if args.bin.is_some() {
        path = path.join("deps"); // the .ll file is placed in ../deps
    }

    for e in fs::read_dir(path)? {
        let e = e?;
        let p = e.path();

        if p.extension().map(|e| e == "ll").unwrap_or(false) {
            if p.file_stem()
                .expect("unreachable")
                .to_str()
                .expect("unreachable")
                .starts_with(&prefix)
            {
                let modified = e.metadata()?.modified()?;
                if ll.is_none() {
                    ll = Some(p);
                    mrm = modified;
                } else {
                    if modified > mrm {
                        ll = Some(p);
                        mrm = modified;
                    }
                }
            }
        }
    }

    let ll_path = ll.expect("unreachable");
    let obj = ll_path.with_extension("o");
    let ll = fs::read_to_string(&ll_path)
        .map_err(|e| anyhow!("couldn't read LLVM IR from `{}`: {}", ll_path.display(), e))?;
    let obj = fs::read(&obj)
        .map_err(|e| anyhow!("couldn't read object file `{}`: {}", obj.display(), e))?;

    let compiler_builtins_ll = fs::read_to_string(&compiler_builtins_ll_path).map_err(|e| {
        anyhow!(
            "couldn't read `compiler_builtins` LLVM IR from `{}`: {}",
            compiler_builtins_ll_path,
            e
        )
    })?;

    let items = crate::ir::parse(&ll).map_err(|e| {
        anyhow!(
            "failed to parse application's LLVM IR from `{}`: {}",
            ll_path.display(),
            e
        )
    })?;
    let compiler_builtins_items = crate::ir::parse(&compiler_builtins_ll).map_err(|e| {
        anyhow!(
            "failed to parse `compiler_builtins` LLVM IR from `{}`: {}",
            compiler_builtins_ll_path,
            e
        )
    })?;
    let mut defines = HashMap::new();
    let mut declares = HashMap::new();
    for item in items.into_iter().chain(compiler_builtins_items) {
        match item {
            Item::Define(def) => {
                defines.insert(def.name, def);
            }

            Item::Declare(decl) => {
                declares.insert(decl.name, decl);
            }

            _ => {}
        }
    }

    let target = project.target().or(target_flag).unwrap_or(&host);

    // we know how to analyze the machine code in the ELF file for these targets thus we have more
    // information and need less LLVM-IR hacks
    let target_ = match target {
        "thumbv6m-none-eabi" => Target::Thumbv6m,
        "thumbv7m-none-eabi" | "thumbv7em-none-eabi" | "thumbv7em-none-eabihf" => Target::Thumbv7m,
        _ => Target::Other,
    };

    // extract stack size information
    // the `.o` file doesn't have address information so we just keep the stack usage information
    let mut stack_sizes: HashMap<_, _> = stack_sizes::analyze_object(&obj)?
        .into_iter()
        .map(|(name, stack)| (name.to_owned(), stack))
        .collect();

    let mut ar = Archive::new(
        File::open(&compiler_builtins_rlib_path)
            .map_err(|e| anyhow!("couldn't open `{}`: {}", compiler_builtins_rlib_path, e))?,
    );

    let mut buf = vec![];
    while let Some(entry) = ar.next_entry() {
        let mut entry = entry?;
        let header = entry.header();

        if str::from_utf8(header.identifier())
            .map(|id| id.contains("compiler_builtins") && id.ends_with(".o"))
            .unwrap_or(false)
        {
            buf.clear();
            entry.read_to_end(&mut buf)?;
            stack_sizes.extend(
                stack_sizes::analyze_object(&buf)?
                    .into_iter()
                    .map(|(name, stack)| (name.to_owned(), stack)),
            );
        }
    }

    // extract list of "live" symbols (symbols that have not been GC-ed by the linker)
    // this time we use the ELF and not the object file
    let mut symbols = stack_sizes::analyze_executable(&elf)?;

    // clear the thumb bit
    if target_.is_thumb() {
        symbols.defined = symbols
            .defined
            .into_iter()
            .map(|(k, v)| (k & !1, v))
            .collect();
    }

    // remove version strings from undefined symbols
    symbols.undefined = symbols
        .undefined
        .into_iter()
        .map(|sym| {
            if let Some(name) = sym.rsplit("@@").nth(1) {
                name
            } else {
                sym
            }
        })
        .collect();

    let mut g = DiGraph::<Node, ()>::new();
    let mut indices = BTreeMap::<Cow<str>, _>::new();

    let mut indirects: HashMap<FnSig, Indirect> = HashMap::new();
    // functions that could be called by `ArgumentV1.formatter`
    let mut fmts = HashSet::new();

    // Some functions may be aliased; we map aliases to a single name. For example, if `foo`,
    // `bar` and `baz` all have the same address then this maps contains: `foo -> foo`, `bar -> foo`
    // and `baz -> foo`.
    let mut aliases = HashMap::new();
    // whether a symbol name is ambiguous after removing the hash
    let mut ambiguous = HashMap::<String, u32>::new();

    // we do a first pass over all the definitions to collect methods in `impl Trait for Type`
    let mut default_methods = HashSet::new();
    for name in defines.keys() {
        let demangled = rustc_demangle::demangle(name).to_string();

        // `<crate::module::Type as crate::module::Trait>::method::hdeadbeef`
        if demangled.starts_with("<") {
            if let Some(rhs) = demangled.splitn(2, " as ").nth(1) {
                // rhs = `crate::module::Trait>::method::hdeadbeef`
                let mut parts = rhs.splitn(2, ">::");

                if let (Some(trait_), Some(rhs)) = (parts.next(), parts.next()) {
                    // trait_ = `crate::module::Trait`, rhs = `method::hdeadbeef`

                    if let Some(method) = dehash(rhs) {
                        default_methods.insert(format!("{}::{}", trait_, method));
                    }
                }
            }
        }
    }

    // add all real nodes
    let mut has_stack_usage_info = false;
    let mut has_untyped_symbols = false;
    let mut addr2name = BTreeMap::new();
    for (address, sym) in &symbols.defined {
        let names = sym.names();
        // filter out tags
        let names = names
            .iter()
            .filter_map(|&name| {
                if name == "$a"
                    || name.starts_with("$a.")
                    || name == "$x"
                    || name.starts_with("$x.")
                {
                    None
                } else {
                    Some(name)
                }
            })
            .collect::<Vec<_>>();

        let canonical_name = if names.len() > 1 {
            // if one of the aliases appears in the `stack_sizes` dictionary, use that
            if let Some(needle) = names.iter().find(|name| stack_sizes.contains_key(&***name)) {
                needle
            } else {
                // otherwise, pick the first name that's not a tag
                names[0]
            }
        } else {
            names[0]
        };

        for name in names.iter().copied() {
            aliases.insert(name, canonical_name);
        }

        let _out = addr2name.insert(address, canonical_name);
        debug_assert!(_out.is_none());

        let stack = stack_sizes.get(canonical_name).cloned();
        if stack.is_none() {
            if !target_.is_thumb() {
                warn!("no stack usage information for `{}`", canonical_name);
            }
        } else {
            has_stack_usage_info = true;
        }

        let demangled = rustc_demangle::demangle(canonical_name).to_string();
        if let Some(dehashed) = dehash(&demangled) {
            *ambiguous.entry(dehashed.to_string()).or_insert(0) += 1;
        }

        let idx = g.add_node(Node(canonical_name, stack, false));
        indices.insert(canonical_name.into(), idx);

        if let Some(def) = names.iter().filter_map(|name| defines.get(name)).next() {
            // if the signature is `fn(&_, &mut fmt::Formatter) -> fmt::Result`
            match (&def.sig.inputs[..], def.sig.output.as_ref()) {
                ([Type::Pointer(..), Type::Pointer(fmt)], Some(output))
                    if **fmt == Type::Alias("core::fmt::Formatter")
                        && **output == Type::Integer(1) =>
                {
                    fmts.insert(idx);
                }

                _ => {}
            }

            indirects
                .entry(def.sig.clone())
                .or_default()
                .callees
                .insert(idx);
        } else if let Some(sig) = names
            .iter()
            .filter_map(|name| declares.get(name).and_then(|decl| decl.sig.clone()))
            .next()
        {
            indirects.entry(sig).or_default().callees.insert(idx);
        } else if !is_outlined_function(canonical_name) {
            // ^ functions produced by LLVM's function outliner are never called through function
            // pointers (as of LLVM 14.0.6)
            has_untyped_symbols = true;
            warn!("no type information for `{}`", canonical_name);
        }
    }

    // to avoid printing several warnings about the same thing
    let mut fns_containing_asm = HashSet::new();
    let mut llvm_seen = HashSet::new();
    // add edges
    let mut edges: HashMap<_, HashSet<_>> = HashMap::new(); // NodeIdx -> [NodeIdx]
    let mut defined = HashSet::new(); // functions that are `define`-d in the LLVM-IR
    for define in defines.values() {
        let canonical_name = match aliases.get(&define.name) {
            Some(canonical_name) => canonical_name,
            None => {
                // this symbol was GC-ed by the linker, skip
                continue;
            }
        };
        defined.insert(*canonical_name);
        let caller = indices[*canonical_name];
        let callees_seen = edges.entry(caller).or_default();

        for stmt in &define.stmts {
            match stmt {
                Stmt::Asm(expr) => {
                    if fns_containing_asm.insert(*canonical_name) {
                        // NB: we only print the first inline asm statement in a function
                        warn!(
                            "assuming that asm!(\"{}\") does *not* use the stack in `{}`",
                            expr, canonical_name
                        );
                    }
                }

                // this is basically `(mem::transmute<*const u8, fn()>(&__some_symbol))()`
                Stmt::BitcastCall(sym) => {
                    // XXX we have some type information for this call but it's unclear if we should
                    // try harder -- does this ever occur in pure Rust programs?

                    let sym = sym.expect("BUG? unnamed symbol is being invoked");
                    let callee = if let Some(idx) = indices.get(sym) {
                        *idx
                    } else {
                        warn!("no stack information for `{}`", sym);

                        let idx = g.add_node(Node(sym, None, false));
                        indices.insert(Cow::Borrowed(sym), idx);
                        idx
                    };

                    g.add_edge(caller, callee, ());
                }

                Stmt::DirectCall(func) => {
                    match *func {
                        // no-op / debug-info
                        "llvm.dbg.value" => continue,
                        "llvm.dbg.declare" => continue,

                        // no-op / compiler-hint
                        "llvm.assume" => continue,

                        // lowers to a single instruction
                        "llvm.trap" => continue,

                        _ => {}
                    }

                    // no-op / compiler-hint
                    if func.starts_with("llvm.lifetime.start")
                        || func.starts_with("llvm.lifetime.end")
                    {
                        continue;
                    }

                    let mut call = |callee| {
                        if !callees_seen.contains(&callee) {
                            g.add_edge(caller, callee, ());
                            callees_seen.insert(callee);
                        }
                    };

                    if target_.is_thumb() && func.starts_with("llvm.") {
                        // we'll analyze the machine code in the ELF file to figure out what these
                        // lower to
                        continue;
                    }

                    // TODO? consider alignment and `value` argument to only include one edge
                    // TODO? consider the `len` argument to elide the call to `*mem*`
                    if func.starts_with("llvm.memcpy.") {
                        if let Some(callee) = indices.get("memcpy") {
                            call(*callee);
                        }

                        // ARMv7-R and the like use these
                        if let Some(callee) = indices.get("__aeabi_memcpy") {
                            call(*callee);
                        }

                        if let Some(callee) = indices.get("__aeabi_memcpy4") {
                            call(*callee);
                        }

                        continue;
                    }

                    // TODO? consider alignment and `value` argument to only include one edge
                    // TODO? consider the `len` argument to elide the call to `*mem*`
                    if func.starts_with("llvm.memset.") || func.starts_with("llvm.memmove.") {
                        if let Some(callee) = indices.get("memset") {
                            call(*callee);
                        }

                        // ARMv7-R and the like use these
                        if let Some(callee) = indices.get("__aeabi_memset") {
                            call(*callee);
                        }

                        if let Some(callee) = indices.get("__aeabi_memset4") {
                            call(*callee);
                        }

                        if let Some(callee) = indices.get("memclr") {
                            call(*callee);
                        }

                        if let Some(callee) = indices.get("__aeabi_memclr") {
                            call(*callee);
                        }

                        if let Some(callee) = indices.get("__aeabi_memclr4") {
                            call(*callee);
                        }

                        continue;
                    }

                    // XXX unclear whether these produce library calls on some platforms or not
                    if func.starts_with("llvm.abs.")
                        || func.starts_with("llvm.bswap.")
                        || func.starts_with("llvm.ctlz.")
                        || func.starts_with("llvm.cttz.")
                        || func.starts_with("llvm.sadd.with.overflow.")
                        || func.starts_with("llvm.smul.with.overflow.")
                        || func.starts_with("llvm.ssub.with.overflow.")
                        || func.starts_with("llvm.uadd.sat.")
                        || func.starts_with("llvm.uadd.with.overflow.")
                        || func.starts_with("llvm.umax.")
                        || func.starts_with("llvm.umin.")
                        || func.starts_with("llvm.umul.with.overflow.")
                        || func.starts_with("llvm.usub.sat.")
                        || func.starts_with("llvm.usub.with.overflow.")
                        || func.starts_with("llvm.vector.reduce.")
                        || func.starts_with("llvm.x86.sse2.pmovmskb.")
                        || *func == "llvm.x86.sse2.pause"
                    {
                        if !llvm_seen.contains(func) {
                            llvm_seen.insert(func);
                            warn!("assuming that `{}` directly lowers to machine code", func);
                        }

                        continue;
                    }

                    // noalias metadata does not lower to machine code
                    if *func == "llvm.experimental.noalias.scope.decl" {
                        continue;
                    }

                    assert!(
                        !func.starts_with("llvm."),
                        "BUG: unhandled llvm intrinsic: {}",
                        func
                    );

                    // some intrinsics can be directly lowered to machine code
                    // if the intrinsic has no corresponding node (symbol in the output ELF) assume
                    // that it has been lowered to machine code
                    const SYMBOLLESS_INTRINSICS: &[&str] = &["memcmp"];
                    if SYMBOLLESS_INTRINSICS.contains(func) && !indices.contains_key(*func) {
                        continue;
                    }

                    // use canonical name
                    let callee = if let Some(canon) = aliases.get(func) {
                        indices[*canon]
                    } else {
                        assert!(
                            symbols.undefined.contains(func),
                            "BUG: callee `{}` is unknown",
                            func
                        );

                        if let Some(idx) = indices.get(*func) {
                            *idx
                        } else {
                            let idx = g.add_node(Node(*func, None, false));
                            indices.insert((*func).into(), idx);

                            idx
                        }
                    };

                    if !callees_seen.contains(&callee) {
                        callees_seen.insert(callee);
                        g.add_edge(caller, callee, ());
                    }
                }

                Stmt::IndirectCall(sig) => {
                    for (key_sig, indirect) in &mut indirects {
                        if key_sig.loosely_equal(sig) {
                            indirect.called = true;
                            indirect.callers.insert(caller);
                        }
                    }
                }

                Stmt::Label | Stmt::Comment | Stmt::Other => {}
            }
        }
    }

    // here we parse the machine code in the ELF file to find out edges that don't appear in the
    // LLVM-IR (e.g. `fadd` operation, `call llvm.umul.with.overflow`, etc.) or are difficult to
    // disambiguate from the LLVM-IR (e.g. does this `llvm.memcpy` lower to a call to
    // `__aebi_memcpy`, a call to `__aebi_memcpy4` or machine instructions?)
    if target_.is_thumb() {
        let elf = ElfFile::new(&elf).map_err(anyhow::Error::msg)?;
        let sect = elf.find_section_by_name(".symtab").expect("UNREACHABLE");
        let mut tags: Vec<_> = match sect.get_data(&elf).unwrap() {
            SectionData::SymbolTable32(entries) => entries
                .iter()
                .filter_map(|entry| {
                    let addr = entry.value() as u32;
                    entry.get_name(&elf).ok().and_then(|name| {
                        if name.starts_with("$d") {
                            Some((addr, Tag::Data))
                        } else if name.starts_with("$t") {
                            Some((addr, Tag::Thumb))
                        } else {
                            None
                        }
                    })
                })
                .collect(),
            _ => unreachable!(),
        };

        tags.sort_by(|a, b| a.0.cmp(&b.0));

        if let Some(sect) = elf.find_section_by_name(".text") {
            let stext = sect.address() as u32;
            let text = sect.raw_data(&elf);

            for (address, sym) in &symbols.defined {
                let address = *address as u32;
                let canonical_name = aliases[&sym.names()[0]];
                let mut size = sym.size() as u32;

                if size == 0 {
                    // try harder at finding out the size of this symbol
                    if let Ok(needle) = tags.binary_search_by(|tag| tag.0.cmp(&address)) {
                        let start = tags[needle];
                        if start.1 == Tag::Thumb {
                            if let Some(end) = tags.get(needle + 1) {
                                if end.1 == Tag::Thumb {
                                    size = end.0 - start.0;
                                }
                            }
                        }
                    }
                }

                let start = (address - stext) as usize;
                let end = start + size as usize;
                let (bls, bs, indirect, modifies_sp, our_stack) = thumb::analyze(
                    &text[start..end],
                    address,
                    target_ == Target::Thumbv7m,
                    &tags,
                );
                let caller = indices[canonical_name];

                // sanity check
                if let Some(stack) = our_stack {
                    assert_eq!(
                        stack != 0,
                        modifies_sp,
                        "BUG: our analysis reported that `{}` both uses {} bytes of stack and \
                         it does{} modify SP",
                        canonical_name,
                        stack,
                        if !modifies_sp { " not" } else { "" }
                    );
                }

                // check the correctness of `modifies_sp` and `our_stack`
                // also override LLVM's results when they appear to be wrong
                if let Local::Exact(ref mut llvm_stack) = g[caller].local {
                    if let Some(stack) = our_stack {
                        if *llvm_stack != stack && fns_containing_asm.contains(&canonical_name) {
                            // LLVM's stack usage analysis ignores inline asm, so its results can
                            // be wrong here

                            warn!(
                                "LLVM reported that `{}` uses {} bytes of stack but \
                                 our analysis reported {} bytes; overriding LLVM's result (function \
                                 uses inline assembly)",
                                canonical_name, llvm_stack, stack
                            );

                            *llvm_stack = stack;
                        } else if is_outlined_function(canonical_name) {
                            // ^ functions produced by LLVM's function outliner are not properly
                            // analyzed by LLVM's emit-stack-sizes pass and are all assigned a stack
                            // usage of 0 bytes, which is sometimes wrong
                            if *llvm_stack == 0 && stack != *llvm_stack {
                                warn!(
                                    "LLVM reported that `{}` uses {} bytes of stack but \
                                     our analysis reported {} bytes; overriding LLVM's result \
                                     (function was produced by LLVM's function outlining pass)",
                                    canonical_name, llvm_stack, stack
                                );

                                *llvm_stack = stack;
                            }
                        } else {
                            // in all other cases our results should match

                            assert_eq!(
                                *llvm_stack, stack,
                                "BUG: LLVM reported that `{}` uses {} bytes of stack but \
                                 this doesn't match our analysis",
                                canonical_name, llvm_stack
                            );
                        }
                    }

                    assert_eq!(
                        *llvm_stack != 0,
                        modifies_sp,
                        "BUG: LLVM reported that `{}` uses {} bytes of stack but this doesn't \
                         match our analysis",
                        canonical_name,
                        *llvm_stack
                    );
                } else if let Some(stack) = our_stack {
                    g[caller].local = Local::Exact(stack);
                } else if !modifies_sp {
                    // this happens when the function contains intra-branches and our analysis gives
                    // up (`our_stack == None`)
                    g[caller].local = Local::Exact(0);
                }

                if g[caller].local == Local::Unknown {
                    warn!("no stack usage information for `{}`", canonical_name);
                }

                if !defined.contains(canonical_name) && indirect {
                    // this function performs an indirect function call and we have no type
                    // information to narrow down the list of callees so inject the uncertainty
                    // in the form of a call to an unknown function with unknown stack usage

                    warn!(
                        "`{}` performs an indirect function call and there's \
                         no type information about the operation",
                        canonical_name,
                    );
                    let callee = g.add_node(Node("?", None, false));
                    g.add_edge(caller, callee, ());
                }

                let callees_seen = edges.entry(caller).or_default();
                for offset in bls {
                    let addr = (address as i64 + i64::from(offset)) as u64;
                    // address may be off by one due to the thumb bit being set
                    let name = addr2name
                        .get(&addr)
                        .unwrap_or_else(|| panic!("BUG? no symbol at address {}", addr));

                    let callee = indices[*name];
                    if !callees_seen.contains(&callee) {
                        g.add_edge(caller, callee, ());
                        callees_seen.insert(callee);
                    }
                }

                for offset in bs {
                    let addr = (address as i32 + offset) as u32;

                    if addr >= address && addr < (address + size) {
                        // intra-function B branches are not function calls
                    } else {
                        // address may be off by one due to the thumb bit being set
                        let name = addr2name
                            .get(&(addr as u64))
                            .unwrap_or_else(|| panic!("BUG? no symbol at address {}", addr));

                        let callee = indices[*name];
                        if !callees_seen.contains(&callee) {
                            g.add_edge(caller, callee, ());
                            callees_seen.insert(callee);
                        }
                    }
                }
            }
        } else {
            error!(".text section not found")
        }
    }

    // add fictitious nodes for indirect function calls
    if has_untyped_symbols {
        warn!(
            "the program contains untyped, external symbols (e.g. linked in from binary blobs); \
             indirect function calls can not be bounded"
        );
    }

    // this is a bit weird but for some reason `ArgumentV1.formatter` sometimes lowers to different
    // LLVM types. In theory it should always be: `i1 (*%fmt::Void, *&core::fmt::Formatter)*` but
    // sometimes the type of the first argument is `%fmt::Void`, sometimes it's `%core::fmt::Void`,
    // sometimes is `%core::fmt::Void.12` and on occasion it's even `%SomeRandomType`
    //
    // To cope with this weird fact the following piece of code will try to find the right LLVM
    // type.
    let all_maybe_void = indirects
        .keys()
        .filter_map(|sig| match (&sig.inputs[..], sig.output.as_ref()) {
            ([Type::Pointer(receiver), Type::Pointer(formatter)], Some(output))
                if **formatter == Type::Alias("core::fmt::Formatter")
                    && **output == Type::Integer(1) =>
            {
                if let Type::Alias(receiver) = **receiver {
                    Some(receiver)
                } else {
                    None
                }
            }
            _ => None,
        })
        .collect::<Vec<_>>();

    let one_true_void = if all_maybe_void.contains(&"fmt::Void") {
        Some("fmt::Void")
    } else {
        all_maybe_void
            .iter()
            .filter_map(|maybe_void| {
                // this could be `core::fmt::Void` or `core::fmt::Void.12`
                if maybe_void.starts_with("core::fmt::Void") {
                    Some(*maybe_void)
                } else {
                    None
                }
            })
            .next()
            .or_else(|| {
                if all_maybe_void.len() == 1 {
                    // we got a random type!
                    Some(all_maybe_void[0])
                } else {
                    None
                }
            })
    };

    for (mut sig, indirect) in indirects {
        if !indirect.called {
            continue;
        }

        let callees = if let Some(one_true_void) = one_true_void {
            match (&sig.inputs[..], sig.output.as_ref()) {
                // special case: this is `ArgumentV1.formatter` a pseudo trait object
                ([Type::Pointer(void), Type::Pointer(fmt)], Some(output))
                    if **void == Type::Alias(one_true_void)
                        && **fmt == Type::Alias("core::fmt::Formatter")
                        && **output == Type::Integer(1) =>
                {
                    if fmts.is_empty() {
                        error!("BUG? no callees for `{}`", sig.to_string());
                    }

                    // canonicalize the signature
                    if one_true_void != "fmt::Void" {
                        sig.inputs[0] = Type::Alias("fmt::Void");
                    }

                    &fmts
                }

                _ => &indirect.callees,
            }
        } else {
            &indirect.callees
        };

        let mut name = sig.to_string();
        // append '*' to denote that this is a function pointer
        name.push('*');

        let call = g.add_node(Node(name.clone(), Some(0), true));

        for caller in &indirect.callers {
            g.add_edge(*caller, call, ());
        }

        if has_untyped_symbols {
            // add an edge between this and a potential extern / untyped symbol
            let extern_sym = g.add_node(Node("?", None, false));
            g.add_edge(call, extern_sym, ());
        } else {
            if callees.is_empty() {
                error!("BUG? no callees for `{}`", name);
            }
        }

        for callee in callees {
            g.add_edge(call, *callee, ());
        }
    }

    // filter the call graph
    if let Some(start) = &args.start {
        let start: &str = start;
        let start = indices.get(start).cloned().or_else(|| {
            let start_ = start.to_owned() + "::h";
            let hits = indices
                .keys()
                .filter_map(|key| {
                    if rustc_demangle::demangle(key)
                        .to_string()
                        .starts_with(&start_)
                    {
                        Some(key)
                    } else {
                        None
                    }
                })
                .collect::<Vec<_>>();

            if hits.len() > 1 {
                error!("multiple matches for `{}`: {:?}", start, hits);
                None
            } else {
                hits.first().map(|key| indices[*key])
            }
        });

        if let Some(start) = start {
            // create a new graph that only contains nodes reachable from `start`
            let mut g2 = DiGraph::<Node, ()>::new();

            // maps `g`'s `NodeIndex`-es to `g2`'s `NodeIndex`-es
            let mut one2two = BTreeMap::new();

            let mut dfs = Dfs::new(&g, start);
            while let Some(caller1) = dfs.next(&g) {
                let caller2 = if let Some(i2) = one2two.get(&caller1) {
                    *i2
                } else {
                    let i2 = g2.add_node(g[caller1].clone());
                    one2two.insert(caller1, i2);
                    i2
                };

                let mut callees = g.neighbors(caller1).detach();
                while let Some((_, callee1)) = callees.next(&g) {
                    let callee2 = if let Some(i2) = one2two.get(&callee1) {
                        *i2
                    } else {
                        let i2 = g2.add_node(g[callee1].clone());
                        one2two.insert(callee1, i2);
                        i2
                    };

                    g2.add_edge(caller2, callee2, ());
                }
            }

            // replace the old graph
            g = g2;

            // invalidate `indices` to prevent misuse
            indices.clear();
        } else {
            error!("start point not found; the graph will not be filtered")
        }
    }

    let mut cycles = vec![];
    if !has_stack_usage_info {
        error!("The graph has zero stack usage information; skipping max stack usage analysis");
    } else if algo::is_cyclic_directed(&g) {
        let sccs = algo::kosaraju_scc(&g);

        // iterate over SCCs (Strongly Connected Components) in reverse topological order
        for scc in &sccs {
            let first = scc[0];

            let is_a_cycle = scc.len() > 1
                || g.neighbors_directed(first, Direction::Outgoing)
                    .any(|n| n == first);

            if is_a_cycle {
                cycles.push(scc.clone());

                let mut scc_local =
                    max_of(scc.iter().map(|node| g[*node].local.into())).expect("UNREACHABLE");

                // the cumulative stack usage is only exact when all nodes do *not* use the stack
                if let Max::Exact(n) = scc_local {
                    if n != 0 {
                        scc_local = Max::LowerBound(n)
                    }
                }

                let neighbors_max = max_of(scc.iter().flat_map(|inode| {
                    g.neighbors_directed(*inode, Direction::Outgoing)
                        .filter_map(|neighbor| {
                            if scc.contains(&neighbor) {
                                // we only care about the neighbors of the SCC
                                None
                            } else {
                                Some(g[neighbor].max.expect("UNREACHABLE"))
                            }
                        })
                }));

                for inode in scc {
                    let node = &mut g[*inode];
                    if let Some(max) = neighbors_max {
                        node.max = Some(max + scc_local);
                    } else {
                        node.max = Some(scc_local);
                    }
                }
            } else {
                let inode = first;

                let neighbors_max = max_of(
                    g.neighbors_directed(inode, Direction::Outgoing)
                        .map(|neighbor| g[neighbor].max.expect("UNREACHABLE")),
                );

                let node = &mut g[inode];
                if let Some(max) = neighbors_max {
                    node.max = Some(max + node.local);
                } else {
                    node.max = Some(node.local.into());
                }
            }
        }
    } else {
        // compute max stack usage
        let mut topo = Topo::new(Reversed(&g));
        while let Some(node) = topo.next(Reversed(&g)) {
            debug_assert!(g[node].max.is_none());

            let neighbors_max = max_of(
                g.neighbors_directed(node, Direction::Outgoing)
                    .map(|neighbor| g[neighbor].max.expect("UNREACHABLE")),
            );

            if let Some(max) = neighbors_max {
                g[node].max = Some(max + g[node].local);
            } else {
                g[node].max = Some(g[node].local.into());
            }
        }
    }

    // here we try to shorten the name of the symbol if it doesn't result in ambiguity
    for node in g.node_weights_mut() {
        let demangled = rustc_demangle::demangle(&node.name).to_string();

        if let Some(dehashed) = dehash(&demangled) {
            if ambiguous[dehashed] == 1 {
                node.name = Cow::Owned(dehashed.to_owned());
            }
        }
    }

    dot(g, &cycles)?;

    Ok(0)
}

fn dot(g: Graph<Node, ()>, cycles: &[Vec<NodeIndex>]) -> io::Result<()> {
    let stdout = io::stdout();
    let mut stdout = stdout.lock();

    writeln!(stdout, "digraph {{")?;
    writeln!(stdout, "    node [fontname={} shape=box]", FONT)?;

    for (i, node) in g.raw_nodes().iter().enumerate() {
        let node = &node.weight;

        write!(stdout, "    {} [label=\"", i,)?;

        let mut escaper = Escaper::new(&mut stdout);
        write!(escaper, "{}", rustc_demangle::demangle(&node.name)).ok();
        escaper.error?;

        if let Some(max) = node.max {
            write!(stdout, "\\nmax {}", max)?;
        }

        write!(stdout, "\\nlocal = {}\"", node.local,)?;

        if node.dashed {
            write!(stdout, " style=dashed")?;
        }

        writeln!(stdout, "]")?;
    }

    for edge in g.raw_edges() {
        writeln!(
            stdout,
            "    {} -> {}",
            edge.source().index(),
            edge.target().index()
        )?;
    }

    for (i, cycle) in cycles.iter().enumerate() {
        writeln!(stdout, "\n    subgraph cluster_{} {{", i)?;
        writeln!(stdout, "        style=dashed")?;
        writeln!(stdout, "        fontname={}", FONT)?;
        writeln!(stdout, "        label=\"SCC{}\"", i)?;

        for node in cycle {
            writeln!(stdout, "        {}", node.index())?;
        }

        writeln!(stdout, "    }}")?;
    }

    writeln!(stdout, "}}")
}

struct Escaper<W>
where
    W: io::Write,
{
    writer: W,
    error: io::Result<()>,
}

impl<W> Escaper<W>
where
    W: io::Write,
{
    fn new(writer: W) -> Self {
        Escaper {
            writer,
            error: Ok(()),
        }
    }
}

impl<W> fmt::Write for Escaper<W>
where
    W: io::Write,
{
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for c in s.chars() {
            self.write_char(c)?;
        }

        Ok(())
    }

    fn write_char(&mut self, c: char) -> fmt::Result {
        match (|| -> io::Result<()> {
            match c {
                '"' => write!(self.writer, "\\")?,
                _ => {}
            }

            write!(self.writer, "{}", c)
        })() {
            Err(e) => {
                self.error = Err(e);

                Err(fmt::Error)
            }
            Ok(()) => Ok(()),
        }
    }
}

#[derive(Clone)]
struct Node<'a> {
    name: Cow<'a, str>,
    local: Local,
    max: Option<Max>,
    dashed: bool,
}

#[allow(non_snake_case)]
fn Node<'a, S>(name: S, stack: Option<u64>, dashed: bool) -> Node<'a>
where
    S: Into<Cow<'a, str>>,
{
    Node {
        name: name.into(),
        local: stack.map(Local::Exact).unwrap_or(Local::Unknown),
        max: None,
        dashed,
    }
}

/// Local stack usage
#[derive(Clone, Copy, PartialEq)]
enum Local {
    Exact(u64),
    Unknown,
}

impl fmt::Display for Local {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            Local::Exact(n) => write!(f, "{}", n),
            Local::Unknown => f.write_str("?"),
        }
    }
}

impl Into<Max> for Local {
    fn into(self) -> Max {
        match self {
            Local::Exact(n) => Max::Exact(n),
            Local::Unknown => Max::LowerBound(0),
        }
    }
}

#[derive(Clone, Copy, Eq, PartialEq)]
enum Max {
    Exact(u64),
    LowerBound(u64),
}

impl ops::Add<Local> for Max {
    type Output = Max;

    fn add(self, rhs: Local) -> Max {
        match (self, rhs) {
            (Max::Exact(lhs), Local::Exact(rhs)) => Max::Exact(lhs + rhs),
            (Max::Exact(lhs), Local::Unknown) => Max::LowerBound(lhs),
            (Max::LowerBound(lhs), Local::Exact(rhs)) => Max::LowerBound(lhs + rhs),
            (Max::LowerBound(lhs), Local::Unknown) => Max::LowerBound(lhs),
        }
    }
}

impl ops::Add<Max> for Max {
    type Output = Max;

    fn add(self, rhs: Max) -> Max {
        match (self, rhs) {
            (Max::Exact(lhs), Max::Exact(rhs)) => Max::Exact(lhs + rhs),
            (Max::Exact(lhs), Max::LowerBound(rhs)) => Max::LowerBound(lhs + rhs),
            (Max::LowerBound(lhs), Max::Exact(rhs)) => Max::LowerBound(lhs + rhs),
            (Max::LowerBound(lhs), Max::LowerBound(rhs)) => Max::LowerBound(lhs + rhs),
        }
    }
}

fn max_of(mut iter: impl Iterator<Item = Max>) -> Option<Max> {
    iter.next().map(|first| iter.fold(first, max))
}

fn max(lhs: Max, rhs: Max) -> Max {
    match (lhs, rhs) {
        (Max::Exact(lhs), Max::Exact(rhs)) => Max::Exact(cmp::max(lhs, rhs)),
        (Max::Exact(lhs), Max::LowerBound(rhs)) => Max::LowerBound(cmp::max(lhs, rhs)),
        (Max::LowerBound(lhs), Max::Exact(rhs)) => Max::LowerBound(cmp::max(lhs, rhs)),
        (Max::LowerBound(lhs), Max::LowerBound(rhs)) => Max::LowerBound(cmp::max(lhs, rhs)),
    }
}

impl fmt::Display for Max {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            Max::Exact(n) => write!(f, "= {}", n),
            Max::LowerBound(n) => write!(f, ">= {}", n),
        }
    }
}

// used to track indirect function calls (`fn` pointers)
#[derive(Default, Debug)]
struct Indirect {
    called: bool,
    callers: HashSet<NodeIndex>,
    callees: HashSet<NodeIndex>,
}

// removes hashes like `::hfc5adc5d79855638`, if present
fn dehash(demangled: &str) -> Option<&str> {
    const HASH_LENGTH: usize = 19;

    let len = demangled.as_bytes().len();
    if len > HASH_LENGTH {
        if demangled
            .get(len - HASH_LENGTH..)
            .map(|hash| hash.starts_with("::h"))
            .unwrap_or(false)
        {
            Some(&demangled[..len - HASH_LENGTH])
        } else {
            None
        }
    } else {
        None
    }
}

#[derive(Clone, Copy, Debug, Eq, PartialEq)]
enum Target {
    Other,
    Thumbv6m,
    Thumbv7m,
}

impl Target {
    fn is_thumb(&self) -> bool {
        match *self {
            Target::Thumbv6m | Target::Thumbv7m => true,
            Target::Other => false,
        }
    }
}

// LLVM's function outliner pass produces symbols of the form `OUTLINED_FUNCTION_NNN` where `NNN` is
// a monotonically increasing number
fn is_outlined_function(name: &str) -> bool {
    if let Some(number) = name.strip_prefix("OUTLINED_FUNCTION_") {
        u64::from_str_radix(number, 10).is_ok()
    } else {
        false
    }
}

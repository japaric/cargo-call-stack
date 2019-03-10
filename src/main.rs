// #![deny(warnings)]

use core::{cmp, fmt, iter, ops};
use std::{
    borrow::Cow,
    collections::{BTreeMap, HashMap, HashSet},
    env, fs,
    path::PathBuf,
    process::{self, Command},
    time::SystemTime,
};

use cargo_project::{Artifact, Profile, Project};
use clap::{crate_authors, crate_version, App, Arg};
use either::Either;
use env_logger::{Builder, Env};
use log::{error, warn};
use petgraph::{
    algo,
    dot::{Config, Dot},
    graph::{DiGraph, NodeIndex},
    visit::{Dfs, Reversed, Topo},
    Direction,
};
use xmas_elf::{sections::SectionData, symbol_table::Entry, ElfFile};

use crate::{
    ir::{FnSig, Item, Stmt, Type},
    thumb::Tag,
};

mod ir;
mod thumb;

fn main() -> Result<(), failure::Error> {
    match run() {
        Ok(ec) => process::exit(ec),
        Err(e) => {
            eprintln!("error: {}", e);
            process::exit(1)
        }
    }
}

// Version we analyzed to extract some ad-hoc information
const VERS: &str = "1.33.0"; // compiler-builtins = "0.1.4"

fn run() -> Result<i32, failure::Error> {
    Builder::from_env(Env::default().default_filter_or("warn")).init();

    let matches = App::new("cargo-call-stack")
        .version(crate_version!())
        .author(crate_authors!(", "))
        .about("Generate a call graph and perform whole program stack usage analysis")
        // as this is used as a Cargo subcommand the first argument will be the name of the binary
        // we ignore this argument
        .arg(Arg::with_name("binary-name").hidden(true))
        .arg(
            Arg::with_name("target")
                .long("target")
                .takes_value(true)
                .value_name("TRIPLE")
                .help("Target triple for which the code is compiled"),
        )
        .arg(
            Arg::with_name("verbose")
                .long("verbose")
                .short("v")
                .help("Use verbose output"),
        )
        .arg(
            Arg::with_name("example")
                .long("example")
                .takes_value(true)
                .value_name("NAME")
                .help("Build only the specified example"),
        )
        .arg(
            Arg::with_name("bin")
                .long("bin")
                .takes_value(true)
                .value_name("BIN")
                .help("Build only the specified binary"),
        )
        .arg(
            Arg::with_name("features")
                .long("features")
                .takes_value(true)
                .value_name("FEATURES")
                .help("Space-separated list of features to activate"),
        )
        .arg(
            Arg::with_name("all-features")
                .long("all-features")
                .takes_value(false)
                .help("Activate all available features"),
        )
        .arg(
            Arg::with_name("START").help("consider only the call graph that starts from this node"),
        )
        .get_matches();
    let is_example = matches.is_present("example");
    let is_binary = matches.is_present("bin");
    let verbose = matches.is_present("verbose");
    let target_flag = matches.value_of("target");
    let profile = Profile::Release;

    let file;
    match (is_example, is_binary) {
        (true, false) => file = matches.value_of("example").unwrap(),
        (false, true) => file = matches.value_of("bin").unwrap(),
        _ => {
            return Err(failure::err_msg(
                "Please specify either --example <NAME> or --bin <NAME>.",
            ));
        }
    }

    let mut cargo = Command::new("cargo");
    cargo.arg("rustc");

    // NOTE we do *not* use `project.target()` here because Cargo will figure things out on
    // its own (i.e. it will search and parse .cargo/config, etc.)
    if let Some(target) = target_flag {
        cargo.args(&["--target", target]);
    }

    if matches.is_present("all-features") {
        cargo.arg("--all-features");
    } else if let Some(features) = matches.value_of("features") {
        cargo.args(&["--features", features]);
    }

    if is_example {
        cargo.args(&["--example", file]);
    }

    if is_binary {
        cargo.args(&["--bin", file]);
    }

    if profile.is_release() {
        cargo.arg("--release");
    }

    cargo.args(&[
        "--",
        // .ll file
        "--emit=llvm-ir",
        // needed to produce a single .ll file
        "-C",
        "lto",
        // stack size information
        "-Z",
        "emit-stack-sizes",
    ]);

    if verbose {
        eprintln!("{:?}", cargo);
    }

    let status = cargo.status()?;

    if !status.success() {
        return Ok(status.code().unwrap_or(1));
    }

    let cwd = env::current_dir()?;

    let meta = rustc_version::version_meta()?;
    let host = meta.host;

    let project = Project::query(cwd)?;
    let mut path: PathBuf = if is_example {
        project.path(Artifact::Example(file), profile, target_flag, &host)?
    } else {
        project.path(Artifact::Bin(file), profile, target_flag, &host)?
    };

    let elf = fs::read(&path)?;

    // load llvm-ir file
    let mut ll = None;
    // most recently modified
    let mut mrm = SystemTime::UNIX_EPOCH;
    let prefix = format!("{}-", file.replace('-', "_"));

    path = path.parent().expect("unreachable").to_path_buf();

    if is_binary {
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

    let ll = fs::read_to_string(ll.expect("unreachable"))?;
    let items = crate::ir::parse(&ll)?;
    let mut defines = HashMap::new();
    let mut declares = HashMap::new();
    for item in items {
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

    // extract stack size information
    let stack_sizes: Vec<_> = match stack_sizes::analyze(&elf)? {
        Either::Left(fs) => fs
            .iter()
            .flat_map(|f| {
                let address = f.address().map(u64::from);
                if address.is_none() {
                    // undefined / external symbols; these are *not* aliased

                    let stack = f.stack();
                    let size = f.size();
                    Either::Left(f.names().iter().map(move |name| {
                        // these symbols may contain a version string (e.g. `@@GLIBC_2.2.5`) that must
                        // be removed
                        if let Some(name) = name.rsplit("@@").nth(1) {
                            (vec![name], (address, size, stack))
                        } else {
                            (vec![*name], (address, size, stack))
                        }
                    }))
                } else {
                    Either::Right(iter::once((
                        f.names().to_owned(),
                        (address, f.size(), f.stack()),
                    )))
                }
            })
            .collect(),

        // same as above (because reasons)
        Either::Right(fs) => fs
            .iter()
            .flat_map(|f| {
                let address = f.address();
                if address.is_none() {
                    let stack = f.stack();
                    let size = f.size();
                    Either::Left(f.names().iter().map(move |name| {
                        if let Some(name) = name.rsplit("@@").nth(1) {
                            (vec![name], (address, size, stack))
                        } else {
                            (vec![*name], (address, size, stack))
                        }
                    }))
                } else {
                    Either::Right(iter::once((
                        f.names().to_owned(),
                        (address, f.size(), f.stack()),
                    )))
                }
            })
            .collect(),
    };

    let mut g = DiGraph::<Node, ()>::new();
    let mut indices = BTreeMap::<Cow<str>, _>::new();

    let mut indirects: HashMap<FnSig, Indirect> = HashMap::new();
    let mut dynamics: HashMap<FnSig, Dynamic> = HashMap::new();

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

    // TODO add `unwrap_or(host)` where `host` comes from `rustc_version`
    let target = project.target().or(target_flag);

    // we know how to analyze the machine code in the ELF file for these targets thus we have more
    // information and need less LLVM-IR hacks
    let target_ = match target.unwrap_or("") {
        "thumbv6m-none-eabi" => Target::Thumbv6m,
        "thumbv7m-none-eabi" | "thumbv7em-none-eabi" | "thumbv7em-none-eabihf" => Target::Thumbv7m,
        _ => Target::Other,
    };

    // add all real nodes
    let mut has_stack_usage_info = false;
    let mut has_untyped_symbols = false;
    let mut addr2name = BTreeMap::new();
    for (names, (address, _, mut stack)) in &stack_sizes {
        let canonical_name = names[0];
        for name in names {
            aliases.insert(name, canonical_name);
        }

        if let Some(addr) = address {
            let _out = addr2name.insert(addr, canonical_name);
            debug_assert!(_out.is_none());
        }

        if stack.is_none() {
            // here we inject some target specific information we get from analyzing
            // `libcompiler_builtins.rlib`

            let ad_hoc = match target.unwrap_or("") {
                "thumbv6m-none-eabi" => match canonical_name {
                    "__aeabi_memcpy" | "__aeabi_memset" | "__aeabi_memclr" | "__aeabi_memclr4" => {
                        stack = Some(0);
                        true
                    }

                    "__aeabi_memcpy4" | "__aeabi_memset4" => {
                        stack = Some(8);
                        true
                    }

                    "memcmp" => {
                        stack = Some(16);
                        true
                    }

                    _ => false,
                },

                "thumbv7m-none-eabi" | "thumbv7em-none-eabi" | "thumbv7em-none-eabihf" => {
                    match canonical_name {
                        "__aeabi_memclr" | "__aeabi_memclr4" => {
                            stack = Some(0);
                            true
                        }

                        "__aeabi_memcpy" | "__aeabi_memcpy4" | "memcmp" => {
                            stack = Some(16);
                            true
                        }

                        "__aeabi_memset" | "__aeabi_memset4" => {
                            stack = Some(8);
                            true
                        }

                        _ => false,
                    }
                }

                _ => false,
            };

            if ad_hoc {
                warn!(
                    "ad-hoc: injecting stack usage information for `{}` (last checked: Rust {})",
                    canonical_name, VERS
                );
            } else {
                warn!("no stack usage information for `{}`", canonical_name);
            }
        } else {
            has_stack_usage_info = true;
        }

        let demangled = rustc_demangle::demangle(canonical_name).to_string();
        if let Some(dehashed) = dehash(&demangled) {
            *ambiguous.entry(dehashed.to_string()).or_insert(0) += 1;
        }

        let idx = g.add_node(Node(canonical_name, stack));
        indices.insert(canonical_name.into(), idx);

        // trait methods look like `<crate::module::Type as crate::module::Trait>::method::h$hash`
        // default trait methods look like `crate::module::Trait::method::h$hash`
        let is_trait_method = demangled.starts_with("<") && demangled.contains(" as ") || {
            dehash(&demangled)
                .map(|path| default_methods.contains(path))
                .unwrap_or(false)
        };

        if let Some(def) = defines.get(canonical_name) {
            let is_object_safe = is_trait_method && {
                match def.sig.inputs.first().as_ref() {
                    Some(Type::Pointer(ty)) => match **ty {
                        // XXX can the receiver be a *specific* function? (e.g. `fn() {foo}`)
                        Type::Fn(_) => false,

                        _ => true,
                    },
                    _ => false,
                }
            };

            if is_object_safe {
                let mut sig = def.sig.clone();

                // erase the type of the reciver
                sig.inputs[0] = Type::erased();

                dynamics.entry(sig).or_default().callees.insert(idx);
            } else {
                indirects
                    .entry(def.sig.clone())
                    .or_default()
                    .callees
                    .insert(idx);
            }
        } else if let Some(sig) = declares
            .get(canonical_name)
            .and_then(|decl| decl.sig.clone())
        {
            // sanity check (?)
            assert!(!is_trait_method, "BUG: undefined trait method");

            indirects.entry(sig).or_default().callees.insert(idx);
        } else {
            // from `compiler-builtins`
            match canonical_name {
                "__aeabi_memcpy" | "__aeabi_memcpy4" | "__aeabi_memcpy8" => {
                    // `fn(*mut u8, *const u8, usize)`
                    let sig = FnSig {
                        inputs: vec![
                            Type::Pointer(Box::new(Type::Integer(8))),
                            Type::Pointer(Box::new(Type::Integer(8))),
                            Type::Integer(32), // ARM has 32-bit pointers
                        ],
                        output: None,
                    };
                    indirects.entry(sig).or_default().callees.insert(idx);
                }

                "__aeabi_memclr" | "__aeabi_memclr4" | "__aeabi_memclr8" => {
                    // `fn(*mut u8, usize)`
                    let sig = FnSig {
                        inputs: vec![
                            Type::Pointer(Box::new(Type::Integer(8))),
                            Type::Integer(32), // ARM has 32-bit pointers
                        ],
                        output: None,
                    };
                    indirects.entry(sig).or_default().callees.insert(idx);
                }

                "__aeabi_memset" | "__aeabi_memset4" | "__aeabi_memset8" => {
                    // `fn(*mut u8, usize, i32)`
                    let sig = FnSig {
                        inputs: vec![
                            Type::Pointer(Box::new(Type::Integer(8))),
                            Type::Integer(32), // ARM has 32-bit pointers
                            Type::Integer(32),
                        ],
                        output: None,
                    };
                    indirects.entry(sig).or_default().callees.insert(idx);
                }

                _ => {
                    has_untyped_symbols = true;
                    warn!("no type information for `{}`", canonical_name);
                }
            }
        }
    }

    // to avoid printing several warnings about the same thing
    let mut asm_seen = HashSet::new();
    let mut llvm_seen = HashSet::new();
    // add edges
    let mut edges: HashMap<_, HashSet<_>> = HashMap::new(); // name -> [name]
    for define in defines.values() {
        let (caller, callees_seen) = if let Some(canonical_name) = aliases.get(&define.name) {
            (
                indices[*canonical_name],
                edges.entry(*canonical_name).or_default(),
            )
        } else {
            // this symbol was GC-ed by the linker, skip
            continue;
        };

        for stmt in &define.stmts {
            match stmt {
                Stmt::Asm(expr) => {
                    if !asm_seen.contains(expr) {
                        asm_seen.insert(expr);
                        warn!("assuming that asm!(\"{}\") does *not* use the stack", expr);
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

                        let idx = g.add_node(Node(sym, None));
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

                    let mut call = |callee, name| {
                        if !callees_seen.contains(name) {
                            g.add_edge(caller, callee, ());
                            callees_seen.insert(name);
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
                            call(*callee, "memcpy");
                        }

                        // ARMv7-R and the like use these
                        if let Some(callee) = indices.get("__aeabi_memcpy") {
                            call(*callee, "__aeabi_memcpy");
                        }

                        if let Some(callee) = indices.get("__aeabi_memcpy4") {
                            call(*callee, "__aeabi_memcpy4");
                        }

                        continue;
                    }

                    // TODO? consider alignment and `value` argument to only include one edge
                    // TODO? consider the `len` argument to elide the call to `*mem*`
                    if func.starts_with("llvm.memset.") || func.starts_with("llvm.memmove.") {
                        if let Some(callee) = indices.get("memset") {
                            call(*callee, "memset");
                        }

                        // ARMv7-R and the like use these
                        if let Some(callee) = indices.get("__aeabi_memset") {
                            call(*callee, "__aeabi_memset");
                        }

                        if let Some(callee) = indices.get("__aeabi_memset4") {
                            call(*callee, "__aeabi_memset4");
                        }

                        if let Some(callee) = indices.get("memclr") {
                            call(*callee, "memclr");
                        }

                        if let Some(callee) = indices.get("__aeabi_memclr") {
                            call(*callee, "__aeabi_memclr");
                        }

                        if let Some(callee) = indices.get("__aeabi_memclr4") {
                            call(*callee, "__aeabi_memclr4");
                        }

                        continue;
                    }

                    // XXX unclear whether these produce library calls on some platforms or not
                    if func.starts_with("llvm.bswap.")
                        | func.starts_with("llvm.ctlz.")
                        | func.starts_with("llvm.uadd.with.overflow.")
                        | func.starts_with("llvm.umul.with.overflow.")
                    {
                        if !llvm_seen.contains(func) {
                            llvm_seen.insert(func);
                            warn!("assuming that `{}` directly lowers to machine code", func);
                        }

                        continue;
                    }

                    assert!(
                        !func.starts_with("llvm."),
                        "BUG: unhandled llvm intrinsic: {}",
                        func
                    );

                    // use canonical name
                    let func = aliases
                        .get(func)
                        .unwrap_or_else(|| panic!("BUG: callee `{}` is unknown", func));

                    let callee = indices[*func];

                    if !callees_seen.contains(func) {
                        callees_seen.insert(func);
                        g.add_edge(caller, callee, ());
                    }
                }

                Stmt::IndirectCall(sig) => {
                    if sig
                        .inputs
                        .first()
                        .map(|ty| ty.has_been_erased())
                        .unwrap_or(false)
                    {
                        // dynamic dispatch
                        let dynamic = dynamics.entry(sig.clone()).or_default();

                        dynamic.called = true;
                        dynamic.callers.insert(caller);
                    } else {
                        let indirect = indirects.entry(sig.clone()).or_default();

                        indirect.called = true;
                        indirect.callers.insert(caller);
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
        let ef = ElfFile::new(&elf).map_err(failure::err_msg)?;

        let sect = ef.find_section_by_name(".symtab").expect("UNREACHABLE");
        let mut tags: Vec<_> = match sect.get_data(&ef).unwrap() {
            SectionData::SymbolTable32(entries) => entries
                .iter()
                .filter_map(|entry| {
                    let addr = entry.value() as u32;
                    entry.get_name(&ef).ok().and_then(|name| {
                        if name.starts_with("$d.") {
                            Some((addr, Tag::Data))
                        } else if name.starts_with("$t.") {
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

        if let Some(sect) = ef.find_section_by_name(".text") {
            let stext = sect.address();
            let text = sect.raw_data(&ef);

            for (names, (address, size, _)) in &stack_sizes {
                if let Some(address) = address {
                    // clear the thumb bit
                    let address = *address & !1;
                    let canonical_name = names[0];

                    let start = (address - stext) as usize;
                    let end = start + *size as usize;
                    let (bls, bs) = thumb::analyze(
                        &text[start..end],
                        address as u32,
                        target_ == Target::Thumbv7m,
                        &tags,
                    );
                    let caller = indices[canonical_name];
                    let callees_seen = edges.entry(canonical_name).or_default();
                    for offset in bls {
                        let addr = (address as i64 + i64::from(offset)) as u64;
                        // address may be off by one due to the thumb bit being set
                        let name = addr2name
                            .get(&addr)
                            .or_else(|| addr2name.get(&(addr + 1)))
                            .unwrap_or_else(|| panic!("BUG? no symbol at address {}", addr));

                        if !callees_seen.contains(name) {
                            g.add_edge(caller, indices[*name], ());
                            callees_seen.insert(name);
                        }
                    }

                    for offset in bs {
                        let addr = (address as i64 + i64::from(offset)) as u64;

                        if addr >= address && addr < (address + *size as u64) {
                            // intra-function B branches are not function calls
                        } else {
                            // address may be off by one due to the thumb bit being set
                            let name = addr2name
                                .get(&addr)
                                .or_else(|| addr2name.get(&(addr + 1)))
                                .unwrap_or_else(|| panic!("BUG? no symbol at address {}", addr));

                            if !callees_seen.contains(name) {
                                g.add_edge(caller, indices[*name], ());
                                callees_seen.insert(name);
                            }
                        }
                    }
                } else {
                    // ignore external symbols
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

    for (sig, indirect) in indirects {
        if !indirect.called {
            continue;
        }

        let mut name = sig.to_string();
        // append '*' to denote that this is a function pointer
        name.push('*');

        let call = g.add_node(Node(name.clone(), Some(0)));

        for caller in &indirect.callers {
            g.add_edge(*caller, call, ());
        }

        if has_untyped_symbols {
            // add an edge between this and a potential extern / untyped symbol
            let extern_sym = g.add_node(Node("?", None));
            g.add_edge(call, extern_sym, ());
        } else {
            if indirect.callees.is_empty() {
                error!("BUG? no callees for `{}`", name);
            }
        }

        for callee in &indirect.callees {
            g.add_edge(call, *callee, ());
        }
    }

    // add fictitious nodes for dynamic dispatch
    for (sig, dynamic) in dynamics {
        if !dynamic.called {
            continue;
        }

        let name = sig.to_string();

        if dynamic.callees.is_empty() {
            error!("BUG? no callees for `{}`", name);
        }

        let call = g.add_node(Node(name, Some(0)));
        for caller in &dynamic.callers {
            g.add_edge(*caller, call, ());
        }

        for callee in &dynamic.callees {
            g.add_edge(call, *callee, ());
        }
    }

    // filter the call graph
    if let Some(start) = matches.value_of("START") {
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

        // TODO do partial match / ignore trailing hash
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

    println!("{:?}", Dot::with_config(&g, &[Config::EdgeNoLabel]));

    Ok(0)
}

#[derive(Clone)]
struct Node<'a> {
    name: Cow<'a, str>,
    local: Local,
    max: Option<Max>,
}

impl fmt::Debug for Node<'_> {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        if let Some(max) = self.max {
            write!(
                f,
                "{}\\nmax {}\\nlocal = {}",
                rustc_demangle::demangle(&*self.name),
                max,
                self.local
            )
        } else {
            write!(
                f,
                "{}\\nlocal = {}",
                rustc_demangle::demangle(&*self.name),
                self.local
            )
        }
    }
}

#[allow(non_snake_case)]
fn Node<'a, S>(name: S, stack: Option<u64>) -> Node<'a>
where
    S: Into<Cow<'a, str>>,
{
    Node {
        name: name.into(),
        local: stack.map(Local::Exact).unwrap_or(Local::Unknown),
        max: None,
    }
}

/// Local stack usage
#[derive(Clone, Copy)]
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
#[derive(Default)]
struct Indirect {
    called: bool,
    callers: HashSet<NodeIndex>,
    callees: HashSet<NodeIndex>,
}

// used to track dynamic dispatch (trait objects)
#[derive(Debug, Default)]
struct Dynamic {
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

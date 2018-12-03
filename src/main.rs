use std::{
    borrow::Cow,
    cmp::Ordering,
    collections::{BTreeMap, HashMap},
    env, fmt, fs, ops,
    process::{self, Command},
    time::SystemTime,
};

use cargo_project::{Artifact, Profile, Project};
use clap::{App, Arg};
use either::Either;
use petgraph::{
    algo,
    dot::{Config, Dot},
    graph::DiGraph,
    visit::{Reversed, Topo},
    Direction,
};
use std::path::PathBuf;

use crate::ir::Call;

mod ir;

fn main() -> Result<(), failure::Error> {
    match run() {
        Ok(ec) => process::exit(ec),
        Err(e) => {
            eprintln!("error: {}", e);
            process::exit(1)
        }
    }
}

fn run() -> Result<i32, failure::Error> {
    let matches = App::new("cargo-call-stack")
        .version("1.0")
        .author("Jorge Aparicio <jorge@japaric.io>, Per Lindgren <per.lindgren@ltu.se>")
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
            ))
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

    // extract stack size information
    let elf = fs::read(&path)?;
    let stack_sizes: Vec<_> = match stack_sizes::analyze(&elf)? {
        Either::Left(fs) => fs
            .into_iter()
            .map(|f| (f.names().to_owned(), f.stack()))
            .collect(),
        Either::Right(fs) => fs
            .into_iter()
            .map(|f| (f.names().to_owned(), f.stack()))
            .collect(),
    };

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

    let defines = crate::ir::parse(&fs::read_to_string(ll.expect("unreachable"))?)?;

    let mut g = DiGraph::<Node, ()>::new();
    let mut indices = BTreeMap::<Cow<str>, _>::new();

    // Some functions may be aliased; we map aliases to a single name. For example, if `foo`,
    // `bar` and `baz` all have the same address then this maps contains: `foo -> foo`, `bar -> foo`
    // and `baz -> foo`.
    let mut aliases = HashMap::new();

    // add all real nodes
    for (names, stack) in stack_sizes {
        debug_assert!(!names.is_empty());

        let canonical_name = names[0];
        for name in names {
            aliases.insert(name, canonical_name);
        }

        let idx = g.add_node(Node(canonical_name, stack));
        indices.insert(canonical_name.into(), idx);

        let demangled = rustc_demangle::demangle(canonical_name).to_string();

        if demangled.starts_with('<') {
            // this is a trait method implementation
            // the syntax is `<$type as $crate::$trait>::$method::$hash`
            let mut parts = demangled[1..].rsplitn(2, ">::");
            let method_hash = parts.next().expect("unreachable");
            let type_as_trait = parts.next().expect("unreachable");

            let mut parts = type_as_trait.split(" as ");
            let path = parts.nth(1).expect(method_hash);

            // we remove the preceding $crate because our call-site metadata doesn't include it
            let mut parts = path.splitn(2, "::");
            let trait_name = parts.nth(1).expect("unreachable");

            let mut parts = method_hash.split("::");
            let method = parts.nth(0).expect("unreachable");

            let to = format!("dyn {}::{}", trait_name, method);

            let to = if let Some(to) = indices.get(&*to) {
                *to
            } else {
                let idx = g.add_node(Node(to.clone(), Some(0)));
                indices.insert(to.into(), idx);
                idx
            };

            g.add_edge(to, idx, ());
        }
    }

    // add edges
    for define in &defines {
        let caller = if let Some(canonical_name) = aliases.get(&define.name()) {
            indices[*canonical_name]
        } else {
            // this symbol was GC-ed by the linker, skip
            continue;
        };

        for call in define.calls() {
            match call {
                Call::Asm { expr } => {
                    eprintln!(
                        "warning: assuming that asm!(\"{}\") does *not* use the stack",
                        expr
                    );
                }
                Call::Direct { callee } => {
                    let callee = if callee.starts_with("llvm.memcpy") {
                        // XXX we should also consider `aeabi_memcpy{,4,8}` here
                        if aliases.contains_key("memcpy") {
                            "memcpy"
                        } else {
                            // inlined `memcpy`
                            continue;
                        }
                    } else {
                        callee
                    };

                    let callee = indices[*aliases.get(callee).unwrap_or_else(|| {
                        panic!("bug? {} does not appear to be a valid symbol", callee);
                    })];

                    g.add_edge(caller, callee, ());
                }
                Call::Fn => {
                    // create a fictitious node for each indirect call
                    let external = g.add_node(Node("_: fn(..) -> _", None));

                    g.add_edge(caller, external, ());
                }
                Call::Trait { name, method } => {
                    // create a fictitious node for each trait object dispatch
                    let to = format!("dyn {}::{}", name, method);

                    let callee = indices[&*to];
                    g.add_edge(caller, callee, ());
                }
            }
        }
    }

    // TODO handle this case instead of panicking
    assert!(
        !algo::is_cyclic_directed(&g),
        "call graphs that contain cycles are currently not supported"
    );

    // compute max stack usage
    let mut topo = Topo::new(Reversed(&g));
    while let Some(node) = topo.next(Reversed(&g)) {
        debug_assert!(g[node].max.is_none());

        let neighbors_max = g
            .neighbors_directed(node, Direction::Outgoing)
            .map(|neighbor| g[neighbor].max.expect("unreachable"))
            .max();

        if let Some(max) = neighbors_max {
            g[node].max = Some(max + g[node].local);
        } else {
            g[node].max = Some(g[node].local.into());
        }
    }

    println!("{:?}", Dot::with_config(&g, &[Config::EdgeNoLabel]));

    Ok(0)
}

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

impl PartialOrd for Max {
    fn partial_cmp(&self, other: &Max) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Max {
    fn cmp(&self, rhs: &Max) -> Ordering {
        match (self, rhs) {
            (Max::Exact(lhs), Max::Exact(rhs)) => lhs.cmp(rhs),
            (Max::Exact(_), Max::LowerBound(_)) => Ordering::Less,
            (Max::LowerBound(_), Max::Exact(_)) => Ordering::Greater,
            (Max::LowerBound(lhs), Max::LowerBound(rhs)) => lhs.cmp(rhs),
        }
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

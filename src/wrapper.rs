//! Implements a `rustc` wrapper that is used to inject additional arguments and extract sysroot
//! information.
//!
//! This currently serves a few purposes:
//! - Inject `-Zemit-stack-sizes` into *all* rustc invocations, even those for building the sysroot
//!   (RUSTFLAGS does not affect those).
//!   This is needed because we need stack usage information of functions in the `compiler_builtins`
//!   library.
//! - Extract the `compiler_builtins` rlib path from the rustc arguments passed by Cargo.
//!   We need to know this path to extract the `.stack_sizes` section produced in the previous step.
//! - Inject `--emit=llvm-ir` when compiling `compiler_builtins`, and reporting back the path to the
//!   created `.ll` file.
//!   This is needed because the `compiler_builtins` LLVM IR is not included in the final program,
//!   even with `-C lto=fat` and `--emit=llvm-ir`.

use std::{env, process::Command};

use anyhow::anyhow;

pub(crate) const COMPILER_BUILTINS_RLIB_PATH_MARKER: &str =
    "@CARGO_CALL_STACK:compiler_builtins_rlib_path@";
pub(crate) const COMPILER_BUILTINS_LL_PATH_MARKER: &str =
    "@CARGO_CALL_STACK:compiler_builtins_ll_path@";

pub(crate) fn wrapper() -> anyhow::Result<i32> {
    let mut args = env::args().skip(1);
    let rustc_path = args.next().unwrap();
    let mut rustc = Command::new(&rustc_path);

    let rustc_args = args.collect::<Vec<_>>();
    let args = RustcArgs::parse(&mut rustc_args.iter().map(|s| &**s))?;

    for ext in &args.extern_crates {
        match (&*ext.crate_name, &ext.path) {
            ("compiler_builtins", Some(path)) => {
                eprintln!("{}{}", COMPILER_BUILTINS_RLIB_PATH_MARKER, path);
            }
            _ => {}
        }
    }

    if args.crate_name == "compiler_builtins" {
        rustc.arg("--emit=llvm-ir");

        let out_dir = args
            .out_dir
            .ok_or_else(|| anyhow!("missing `--out-dir` argument"))?;
        let ll_path = format!("{}/{}{}.ll", out_dir, args.crate_name, args.extra_filename);
        eprintln!("{}{}", COMPILER_BUILTINS_LL_PATH_MARKER, ll_path);
    }

    rustc.arg("-Zemit-stack-sizes").args(&rustc_args);

    let status = rustc
        .status()
        .map_err(|e| anyhow!("failed to spawn `{}`: {}", rustc_path, e))?;
    Ok(status.code().unwrap_or(-1))
}

struct RustcArgs {
    extra_filename: String,
    crate_name: String,
    out_dir: Option<String>,
    extern_crates: Vec<Extern>,
}

struct Extern {
    crate_name: String,
    path: Option<String>,
}

impl RustcArgs {
    fn parse(args: &mut dyn Iterator<Item = &str>) -> anyhow::Result<Self> {
        const NOPRELUDE: &str = "noprelude:";
        const DASH_C: &str = "-C";

        let mut extra_filename = None;
        let mut crate_name = None;
        let mut out_dir = None;
        let mut extern_crates = Vec::new();

        while let Some(arg) = args.next() {
            match &*arg {
                "--extern" => {
                    let arg = args
                        .next()
                        .ok_or_else(|| anyhow!("missing argument for `--extern`"))?;
                    let mut arg = &*arg;
                    if arg.starts_with(NOPRELUDE) {
                        arg = &arg[NOPRELUDE.len()..];
                    }

                    let mut split = arg.splitn(2, '=');
                    let name = split.next().unwrap(); // cannot fail
                    let path = split.next();

                    extern_crates.push(Extern {
                        crate_name: name.to_string(),
                        path: path.map(ToString::to_string),
                    });
                }
                "--crate-name" => {
                    crate_name = Some(
                        args.next()
                            .ok_or_else(|| anyhow!("missing argument for `--crate-name`"))?
                            .to_string(),
                    );
                }
                "--out-dir" => {
                    out_dir = Some(
                        args.next()
                            .ok_or_else(|| anyhow!("missing argument for `--out-dir`"))?
                            .to_string(),
                    );
                }
                _ if arg.starts_with(DASH_C) => {
                    let next;
                    let mut arg = &arg[DASH_C.len()..];

                    if arg.is_empty() {
                        next = args
                            .next()
                            .ok_or_else(|| anyhow!("missing argument for `-C`"))?;
                        arg = &next;
                    }

                    let mut split = arg.splitn(2, '=');
                    let name = split.next().unwrap(); // cannot fail

                    match name {
                        "extra-filename" => {
                            extra_filename = Some(
                                split
                                    .next()
                                    .ok_or_else(|| anyhow!("missing value for `-Cextra-filename`"))?
                                    .to_string(),
                            );
                        }
                        _ => {}
                    }
                }
                _ => {}
            }
        }

        Ok(Self {
            extra_filename: extra_filename.unwrap_or_default(),
            crate_name: crate_name.ok_or_else(|| anyhow!("missing `--crate-name` argument"))?,
            out_dir,
            extern_crates,
        })
    }
}

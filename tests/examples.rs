use std::{env, process::Command};

use rustc_version::Channel;

fn for_each_target(mut f: impl FnMut(&str)) {
    for target in ["thumbv6m-none-eabi", "thumbv7m-none-eabi"] {
        f(target)
    }
}

#[test]
fn cycle() {
    if channel_is_nightly() {
        // function calls on ARMv6-M use the stack
        let dot = call_stack("cycle", "thumbv7m-none-eabi");

        let mut found = false;
        for line in dot.lines() {
            if line.contains("label=\"main\\n") {
                found = true;
                // worst-case stack usage must be exact
                assert!(line.contains("max = "));
            }
        }

        assert!(found);
    }
}

#[test]
fn fmul() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let dot = call_stack("fmul", target);

            let mut main = None;
            let mut fmul = None;

            for line in dot.lines() {
                if line.contains("label=\"main\\n") {
                    main = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                } else if line.contains("label=\"__aeabi_fmul\\n") {
                    fmul = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                }
            }

            let main = main.unwrap();
            let fmul = fmul.unwrap();

            // there must be an edge between `main` and `__aeabi_fmul`
            assert!(dot.contains(&format!("{} -> {}", main, fmul)));
        })
    }
}

#[test]
fn fun() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let dot = call_stack("fn", target);

            let mut foo = None;
            let mut bar = None;
            let mut fun = None;

            for line in dot.lines() {
                if line.contains("label=\"fn::foo\\n") {
                    foo = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                } else if line.contains("label=\"fn::bar\\n") {
                    bar = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                } else if line.contains("label=\"i1 ()*\\n") {
                    fun = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                }
            }

            let fun = fun.unwrap();
            let foo = foo.unwrap();
            let bar = bar.unwrap();

            // there must be an edge from the fictitious node to both `foo` and `bar`
            assert!(dot.contains(&format!("{} -> {}", fun, foo)));
            assert!(dot.contains(&format!("{} -> {}", fun, bar)));
        })
    }
}

#[test]
fn to() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let dot = call_stack("to", target);

            let mut bar = None;
            let mut baz = None;
            let mut quux = None;
            let mut to = None;

            for line in dot.lines() {
                if line.contains("label=\"to::Foo::foo\\n") {
                    bar = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                } else if line.contains("label=\"<to::Baz as to::Foo>::foo\\n") {
                    baz = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                } else if line.contains("label=\"to::Quux::foo\\n") {
                    quux = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                } else if line.contains("label=\"i1 ({}*)\\n") {
                    to = Some(
                        line.split_whitespace()
                            .next()
                            .unwrap()
                            .parse::<u32>()
                            .unwrap(),
                    );
                }
            }

            let bar = bar.unwrap();
            let baz = baz.unwrap();
            let quux = quux.unwrap();
            let to = to.unwrap();

            // there must be an edge from the fictitious node to both `Bar` and `Baz`
            assert!(dot.contains(&format!("{} -> {}", to, bar)));
            assert!(dot.contains(&format!("{} -> {}", to, baz)));

            // but there must not be an edge from the fictitious node and `Quux`
            assert!(!dot.contains(&format!("{} -> {}", to, quux)));
        })
    }
}

#[test]
fn defmt() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let dot = call_stack("defmt", target);
            assert!(
                dot.contains(&"label=\"main\\nmax = "),
                "could not compute an upper for `main`"
            );
        })
    }
}

#[test]
fn fmt() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let _should_not_error = call_stack("fmt", target);
        })
    }
}

#[test]
fn panic_fmt() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let _should_not_error = call_stack("panic-fmt", target);
        })
    }
}

#[test]
fn div64() {
    if channel_is_nightly() {
        for_each_target(|target| {
            let _should_not_error = call_stack("div64", target);
        })
    }
}

fn channel_is_nightly() -> bool {
    rustc_version::version_meta().map(|m| m.channel).ok() == Some(Channel::Nightly)
}

fn call_stack(ex: &str, target: &str) -> String {
    let output = Command::new("cargo")
        .args(&["call-stack", "--example", ex, "--target", target])
        .current_dir(env::current_dir().unwrap().join("cortex-m-examples"))
        .output()
        .unwrap();
    if !output.status.success() {
        panic!("{}", String::from_utf8(output.stderr).unwrap());
    }
    String::from_utf8(output.stdout).unwrap()
}

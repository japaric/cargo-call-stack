use std::{env, process::Command};

use rustc_version::Channel;

#[test]
fn cycle() {
    if channel_is_nightly() {
        let dot = call_stack("cycle");

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
        let dot = call_stack("fmul");

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
    }
}

#[test]
fn fun() {
    if channel_is_nightly() {
        let dot = call_stack("fn");

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
    }
}

#[test]
fn to() {
    if channel_is_nightly() {
        let dot = call_stack("to");

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
    }
}

#[test]
fn defmt() {
    if channel_is_nightly() {
        let dot = call_stack("defmt");
        assert!(
            dot.contains(&"label=\"Reset\\nmax = "),
            "could not compute an upper for entry point"
        );
    }
}

fn channel_is_nightly() -> bool {
    rustc_version::version_meta().map(|m| m.channel).ok() == Some(Channel::Nightly)
}

fn call_stack(ex: &str) -> String {
    let output = Command::new("cargo")
        .args(&[
            "call-stack",
            "--target",
            "thumbv7m-none-eabi",
            "--example",
            ex,
        ])
        .current_dir(env::current_dir().unwrap().join("cortex-m-examples"))
        .output()
        .unwrap();
    if !output.status.success() {
        panic!("{}", String::from_utf8(output.stderr).unwrap());
    }
    String::from_utf8(output.stdout).unwrap()
}

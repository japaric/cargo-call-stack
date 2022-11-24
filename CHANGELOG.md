# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [v0.1.14] - 2022-11-24

### Fixed

- llvm-ir parser: accept undef argument in call statements
- llvm-ir parser: accept negative integers in call statements

## [v0.1.13] - 2022-11-16

### Fixed

- fixed analysis of ARMv6-M machine code (UDF instruction)
- handle `llvm.abs.*` instrinsics instead of panicking

## [v0.1.12] - 2022-10-17

### Fixed

- adapted parser and analysis pass to work with new-ish `ptr` type in llvm-ir

## [v0.1.11] - 2022-07-07

### Added

- include Cargo.lock file in crates.io upload

### Fixed

- work around LLVM bug around outlined functions where the stack usage reported by LLVM is wrong. fix only applies to ARM Cortex-M targets

## [v0.1.10] - 2022-06-28

### Fixed

- support for `no_std` targets that lack CAS operations, like `thumbv6m-none-eabi`
- work around rust-lang/rust#98378 for `no_std` targets (affects ~nightly-2022-06-22)

## [v0.1.9] - 2022-06-22

### Fixed

- handle enough llvm intrinsics to be able to produce a call graph for a statically linked "hello,
  world" binary (Linux MUSL target).

## [v0.1.8] - 2022-06-22

### Fixed

- updated LLVM IR parser to handle newer libstd's IR (~nightly-2022-06-22)

## [v0.1.7] - 2022-06-15

### Fixed

- updated LLVM IR parser to recognize the output of newer toolchains (~nightly-2022-06-15)

## [v0.1.6] - 2021-09-23

### Fixed

- updated LLVM IR parser to recognize the output of newer toolchains

### Changed

- bumped `cargo-project` dependency to support Cargo configuration files with the `.toml` file extension
- the type information of functions defined in compiler-builtins is now extracted from LLVM IR (previously it was hardcoded)
- the stack usage of functions defined in compiler-builtins now comes from LLVM (previously it was hardcoded)

## [v0.1.5] - 2020-07-07

### Fixed

- Support changes in LLVM IR after the latest LLVM update (9 -> 10)

## [v0.1.4] - 2019-11-19

### Fixed

- Extended parser to support the new LLVM-IR identifier formats of labels and
  values that rustc emits.

## [v0.1.3] - 2019-03-24

### Changed

- Linker script magic is no longer required. All call graphs produced by
  `cargo-call-stack` will include stack usage information.

- `cargo-call-stack` now always forces a rebuild -- the Cargo caching behavior
  makes it hard to locate the object file that contains the stack usage
  information.

- `cargo-call-stack` will now load the `compiler-builtins` rlib and extract
  stack usage information from it, if it contains any.

- Nodes that form a cycle are now grouped in a cluster to make them easier to
  spot.

- `cargo-call-stack` now computes the stack usage of Thumb functions that don't
  contain branches. This is useful for getting stack information on `#[naked]`
  functions that use `asm!` and `global_asm!`-defined symbols.

### Fixed

- Some cases where the call graph included duplicated edges (i.e. more than one
  edge from A to B).

## [v0.1.2] - 2019-03-12

### Added

- More type information about compiler builtins has been added.

- More stack usage information about compiler builtins cross compiled to
  ARMv{6,7}-M has been added.

- The tool can now reason about the `core::fmt` API, which does some clever
  tricks with function pointers (type erasure). This has been special cased
  because the pattern can't be analyzed by just looking at types and function
  signatures.

### Changed

- For ARMv{6,7}-M programs the tool will also inspect the machine code in the
  output binary (ELF file) to get even more information about the call graph.
  This helps with LLVM intrinsics (where it's unclear from the LLVM-IR if a call
  to `llvm.memcpy` will lower to a call to `__aeabi_memcpy`, a call to
  `__aeabi_memcpy4` or machine code) and binary blobs, like
  `libcompiler_builtins.rlib`, for which the tool doesn't have LLVM-IR.

- The default dot style for nodes is the "box" shape and the "monospace" font.

- The fictitious nodes used for function pointer calls and dynamic dispatch are
  now rendered as dashed boexs.

### Fixed

- The tool will not crash when encountering functions that contain floating
  points in their signature.

- Warning about `asm!` and llvm intrinsics will not be displayed more than once
  in the output.

- Fixed miscellaneous parser bugs.

- The tool will now correctly find the definition / declaration of aliased
  Rust symbols; meaning that it will have type information for them and no
  "no type information for `foo`" warning will be displayed.

## [v0.1.1] - 2019-03-03

### Added

- The start point of the call graph can now be specific via the command line.
  When specified the call graph will be filtered to only show nodes reachable
  from the start point.

### Changed

- Only a single edge is now drawn between two nodes; this is the case even if
  one calls the other several times. This greatly reduces the clutter in the
  graph.

- The hash suffix (e.g. `::hfe0e89d04d279bfd`) is now omitted from symbols that
  are unambiguous.

- Programs than don't contain the `.stack_sizes` section are now analyzed,
  instead of rejected, so you'll get their call graph; however, the maximum
  stack usage analysis pass will be skipped.

- The tool will now analyze the max stack usage of call graphs that contain
  cycles instead of giving up.

- The tool will insert edges between nodes that perform indirect function calls
  (via function pointers) and dynamic dispatch of trait objects and *potential*
  callees. The candidates are computed using the (rather limited) type
  information contained in the LLVM-IR so the results can be inaccurate.

### Fixed

- Fixed lots of LLVM-IR parsing bugs. The tool can now deal with complex
  programs like "Hello, world".

- Fixed a bug in the computation of max stack usage. For example, a function `f`
  with local stack usage of `0` calls both `a`, with max stack usage of `>0`,
  and `b`, with max stack usage of `=8`, then `f`'s max stack usage should be
  `>8` -- we used to report `>0`.

## v0.1.0 - 2018-12-03

Initial release

[Unreleased]: https://github.com/japaric/cargo-call-stack/compare/v0.1.14...HEAD
[v0.1.14]: https://github.com/japaric/cargo-call-stack/compare/v0.1.13...v0.1.14
[v0.1.13]: https://github.com/japaric/cargo-call-stack/compare/v0.1.12...v0.1.13
[v0.1.12]: https://github.com/japaric/cargo-call-stack/compare/v0.1.11...v0.1.12
[v0.1.11]: https://github.com/japaric/cargo-call-stack/compare/v0.1.10...v0.1.11
[v0.1.10]: https://github.com/japaric/cargo-call-stack/compare/v0.1.9...v0.1.10
[v0.1.9]: https://github.com/japaric/cargo-call-stack/compare/v0.1.8...v0.1.9
[v0.1.8]: https://github.com/japaric/cargo-call-stack/compare/v0.1.7...v0.1.8
[v0.1.7]: https://github.com/japaric/cargo-call-stack/compare/v0.1.6...v0.1.7
[v0.1.6]: https://github.com/japaric/cargo-call-stack/compare/v0.1.5...v0.1.6
[v0.1.5]: https://github.com/japaric/cargo-call-stack/compare/v0.1.4...v0.1.5
[v0.1.4]: https://github.com/japaric/cargo-call-stack/compare/v0.1.3...v0.1.4
[v0.1.3]: https://github.com/japaric/cargo-call-stack/compare/v0.1.2...v0.1.3
[v0.1.2]: https://github.com/japaric/cargo-call-stack/compare/v0.1.1...v0.1.2
[v0.1.1]: https://github.com/japaric/cargo-call-stack/compare/v0.1.0...v0.1.1

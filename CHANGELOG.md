# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Changed

- For ARMv{6,7}-M programs the tool will also inspect the machine code in the
  output binary (ELF file) to get even more information about the call graph.
  This helps with LLVM intrinsics (where it's unclear from the LLVM-IR if a call
  to `llvm.memcpy` will lower to a call to `__aeabi_memcpy`, a call to
  `__aeabi_memcpy4` or machine code) and binary blobs, like
  `libcompiler_builtins.rlib`, for which the tool doesn't have LLVM-IR.

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

[Unreleased]: https://github.com/japaric/cargo-call-stack/compare/v0.1.1...HEAD
[v0.1.1]: https://github.com/japaric/cargo-call-stack/compare/v0.1.0...v0.1.1

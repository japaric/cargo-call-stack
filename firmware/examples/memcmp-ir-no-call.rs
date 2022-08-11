#![no_main]
#![no_std]

use core::cmp::Ordering;

use panic_halt as _;
// as seen in issue #63 this produces `call @memcmp` in LLVM IR but the intrinsic then is lowered to
// machine code by llvm and there's no `memcmp` symbol in the output ELF
#[no_mangle]
fn _start(a: &str, b: &str) -> bool {
    if a.len() == 4 && b.len() == 4 {
        a.cmp(b) == Ordering::Equal
    } else {
        false
    }
}

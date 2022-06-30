#![no_main]
#![no_std]

use core::{cmp::Ordering, ptr};

use panic_halt as _;

#[cortex_m_rt::entry]
fn main() -> ! {
    unsafe {
        let no = no as usize;
        ptr::addr_of!(no).read_volatile();
    }
    loop {}
}

// as seen in issue #63 this produces `call @memcmp` in LLVM IR but the intrinsic then is lowered to
// machine code by llvm and there's no `memcmp` symbol in the output ELF
fn no(a: &str, b: &str) -> bool {
    if a.len() == 4 && b.len() == 4 {
        a.cmp(b) == Ordering::Equal
    } else {
        false
    }
}

#![no_main]
#![no_std]

use core::arch::asm;

use panic_halt as _;

#[no_mangle]
fn _start(f: fn(&usize) -> bool) -> (usize, usize) {
    // call via function pointer
    f(&0);

    // keep these two functions in the resulting binary
    (foo as usize, bar as usize)
}

fn foo(x: &usize) -> bool {
    // spill variables onto the stack
    unsafe {
        asm!(
            "// {0} {1} {2} {3} {4} {5}",
            in(reg) x as *const _ as usize, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5,
        );
    }

    false
}

fn bar(x: &usize) -> bool {
    unsafe {
        asm!(
            "// {0} {1} {2} {3} {4} {5} {6}",
            in(reg) x as *const _ as usize, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5, in(reg) 6,
        );
    }

    true
}

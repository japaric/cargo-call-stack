#![no_main]
#![no_std]

use core::arch::asm;

use panic_halt as _;

#[no_mangle]
fn _start(f: fn() -> bool) -> (usize, usize) {
    // call via function pointer
    f();

    // keep these two functions in the resulting binary
    (foo as usize, bar as usize)
}

fn foo() -> bool {
    // spill variables onto the stack
    unsafe {
        asm!(
            "// {0} {1} {2} {3} {4} {5}",
            in(reg) 0, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5,
        );
    }

    false
}

fn bar() -> bool {
    unsafe {
        asm!(
            "// {0} {1} {2} {3} {4} {5} {6}",
            in(reg) 0, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5, in(reg) 6,
        );
    }

    true
}

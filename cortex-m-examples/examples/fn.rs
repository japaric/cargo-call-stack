#![no_main]
#![no_std]

use core::{
    arch::asm,
    sync::atomic::{AtomicPtr, Ordering},
};

use cortex_m_rt::{entry, exception};
use panic_halt as _;

static F: AtomicPtr<fn() -> bool> = AtomicPtr::new(foo as *mut _);

#[entry]
fn main() -> ! {
    if let Some(f) = unsafe { F.load(Ordering::Relaxed).as_ref() } {
        // call via function pointer
        f();
    }

    loop {}
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

// this handler can change the function pointer at any time
#[exception]
fn SysTick() {
    F.store(bar as *mut _, Ordering::Relaxed);
}

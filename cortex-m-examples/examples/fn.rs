#![feature(llvm_asm)]
#![no_main]
#![no_std]

extern crate panic_halt;

use core::sync::atomic::{AtomicPtr, Ordering};

use cortex_m_rt::{entry, exception};

static F: AtomicPtr<fn() -> bool> = AtomicPtr::new(foo as *mut _);

#[inline(never)]
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
    unsafe { llvm_asm!("" : : "r"(0) "r"(1) "r"(2) "r"(3) "r"(4) "r"(5)) }

    false
}

fn bar() -> bool {
    unsafe { llvm_asm!("" : : "r"(0) "r"(1) "r"(2) "r"(3) "r"(4) "r"(5) "r"(6) "r"(7)) }

    true
}

// this handler can change the function pointer at any time
#[exception]
fn SysTick() {
    F.store(bar as *mut _, Ordering::Relaxed);
}

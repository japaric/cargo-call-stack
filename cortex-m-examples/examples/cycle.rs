#![feature(asm)]
#![no_main]
#![no_std]

extern crate panic_halt;

use core::sync::atomic::{AtomicBool, Ordering};

use cortex_m_rt::{entry, exception};

static X: AtomicBool = AtomicBool::new(true);

#[inline(never)]
#[entry]
fn main() -> ! {
    foo();

    quux();

    loop {}
}

// these three functions form a cycle that breaks when `SysTick` runs
#[inline(never)]
fn foo() {
    if X.load(Ordering::Relaxed) {
        bar()
    }
}

#[inline(never)]
fn bar() {
    if X.load(Ordering::Relaxed) {
        baz()
    }
}

#[inline(never)]
fn baz() {
    if X.load(Ordering::Relaxed) {
        foo()
    }
}

#[inline(never)]
fn quux() {
    // spill variables onto the stack
    unsafe { asm!("" : : "r"(0) "r"(1) "r"(2) "r"(3) "r"(4) "r"(5)) }
}

#[exception]
fn SysTick() {
    X.store(false, Ordering::Relaxed);
}

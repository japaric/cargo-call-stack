#![no_main]
#![no_std]

use core::{
    arch::asm,
    sync::atomic::{AtomicBool, Ordering},
};

use cortex_m_rt::{entry, exception};
use panic_halt as _;

static X: AtomicBool = AtomicBool::new(true);

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
    unsafe {
        asm!(
            "// {0} {1} {2} {3} {4} {5}",
            in(reg) 0, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5,
        );
    }
}

#[exception]
fn SysTick() {
    X.store(false, Ordering::Relaxed);
}

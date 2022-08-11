#![no_main]
#![no_std]

use core::{
    arch::asm,
    sync::atomic::{AtomicBool, Ordering},
};

use panic_halt as _;

#[no_mangle]
fn _start(x: &AtomicBool) {
    foo(x);
    quux();
}

// these three functions form a cycle that breaks when `x` is `false`
#[inline(never)]
fn foo(x: &AtomicBool) {
    if x.load(Ordering::Relaxed) {
        bar(x)
    }
}

#[inline(never)]
fn bar(x: &AtomicBool) {
    baz(x)
}

#[inline(never)]
fn baz(x: &AtomicBool) {
    foo(x)
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

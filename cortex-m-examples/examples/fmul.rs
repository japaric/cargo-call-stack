#![no_main]
#![no_std]

use core::sync::atomic::{AtomicU32, Ordering};

use cortex_m_rt::exception;
use panic_halt as _;

static X: AtomicU32 = AtomicU32::new(0);

// #[entry] // <- this result in an extra trampoline that breaks our test
#[no_mangle]
fn main() -> ! {
    let x = f32::from_bits(X.load(Ordering::Relaxed));
    let y = x * 1.1;
    X.store(y.to_bits(), Ordering::Relaxed);

    loop {}
}

#[exception]
fn SysTick() {
    let old = X.load(Ordering::Relaxed);
    X.store(old.wrapping_add(1), Ordering::Relaxed);
}

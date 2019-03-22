#![no_main]
#![no_std]

extern crate panic_halt;

use core::sync::atomic::{AtomicU32, Ordering};

use cortex_m_rt::{entry, exception};

static X: AtomicU32 = AtomicU32::new(0);

#[entry]
fn main() -> ! {
    let x = f32::from_bits(X.load(Ordering::Relaxed));
    let y = x * 1.1;
    X.store(y.to_bits(), Ordering::Relaxed);

    loop {}
}

#[exception]
fn SysTick() {
    X.fetch_add(1, Ordering::Relaxed);
}

#![no_main]
#![no_std]

use core::sync::atomic::{AtomicUsize, Ordering};

use cortex_m_rt::{entry, exception};
use panic_halt as _;

static X: AtomicUsize = AtomicUsize::new(0);

#[entry]
fn main() -> ! {
    X.store(div64 as usize, Ordering::Relaxed);

    loop {}
}

fn div64(x: u64, y: u64) -> u64 {
    x / y
}

#[exception]
fn SysTick() {
    X.fetch_add(1, Ordering::Relaxed);
}

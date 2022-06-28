#![no_main]
#![no_std]

use core::sync::atomic::{AtomicUsize, Ordering};

use cortex_m_rt::entry;
use defmt_rtt as _;
use panic_halt as _;

static COUNT: AtomicUsize = AtomicUsize::new(0);

defmt::timestamp!("{=usize}", {
    // NOTE(no-CAS) `timestamps` runs with interrupts disabled
    let n = COUNT.load(Ordering::Relaxed);
    COUNT.store(n + 1, Ordering::Relaxed);
    n
});

#[entry]
fn main() -> ! {
    defmt::println!("Hello, world!");

    loop {}
}

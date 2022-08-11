#![no_main]
#![no_std]

use panic_halt as _;

#[no_mangle]
fn _start(x: u64, y: u64) -> u64 {
    x / y
}

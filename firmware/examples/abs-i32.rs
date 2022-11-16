#![no_main]
#![no_std]

use panic_halt as _;

#[no_mangle]
fn _start() -> usize {
    i32::abs as usize
}

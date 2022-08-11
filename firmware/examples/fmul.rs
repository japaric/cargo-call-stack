#![no_main]
#![no_std]

use panic_halt as _;

#[no_mangle]
fn _start(x: f32) -> f32 {
    x * 1.1
}

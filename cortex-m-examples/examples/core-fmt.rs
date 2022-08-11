#![no_main]
#![no_std]

use core::fmt::{self, Write as _};

use panic_halt as _;

#[no_mangle]
fn _start() {
    write!(W, "hello, world!").ok();
}

struct W;

impl fmt::Write for W {
    fn write_str(&mut self, s: &str) -> fmt::Result {
        for byte in s.as_bytes() {
            unsafe { drop((byte as *const u8).read_volatile()) }
        }
        Ok(())
    }
}

#![no_main]
#![no_std]

use core::fmt::{self, Write as _};

use cortex_m_rt::entry;
use panic_halt as _;

#[entry]
fn main() -> ! {
    write!(W, "hello, world!").ok();

    loop {}
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

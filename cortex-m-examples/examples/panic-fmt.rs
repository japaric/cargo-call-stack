#![no_main]
#![no_std]

use core::{
    fmt::{self, Write as _},
    panic::PanicInfo,
};

use cortex_m_rt::entry;

#[entry]
fn main() -> ! {
    panic!("hello, world")
}

#[panic_handler]
fn panic(info: &PanicInfo) -> ! {
    write!(W, "{}", info).ok();
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

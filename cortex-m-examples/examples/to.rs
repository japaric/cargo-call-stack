#![feature(asm)]
#![no_main]
#![no_std]

extern crate panic_halt;

use cortex_m_rt::{entry, exception};
use spin::Mutex; // spin = "0.5.0"

static TO: Mutex<&'static (dyn Foo + Sync)> = Mutex::new(&Bar);

#[entry]
#[inline(never)]
fn main() -> ! {
    // trait object dispatch
    (*TO.lock()).foo();

    Quux.foo();

    loop {}
}

trait Foo {
    // default implementation of this method
    fn foo(&self) -> bool {
        // spill variables onto the stack
        unsafe { asm!("" : : "r"(0) "r"(1) "r"(2) "r"(3) "r"(4) "r"(5)) }

        false
    }
}

struct Bar;

// uses the default method implementation
impl Foo for Bar {}

struct Baz;

impl Foo for Baz {
    // overrides the default method
    fn foo(&self) -> bool {
        unsafe { asm!("" : : "r"(0) "r"(1) "r"(2) "r"(3) "r"(4) "r"(5) "r"(6) "r"(7)) }

        true
    }
}

struct Quux;

impl Quux {
    // not a trait method!
    #[inline(never)]
    fn foo(&self) -> bool {
        // NOTE(asm!) side effect to preserve function calls to this method
        unsafe { asm!("NOP" : : : : "volatile") }

        false
    }
}

// this handler can change the trait object at any time
#[exception]
fn SysTick() {
    *TO.lock() = &Baz;
}

#![no_main]
#![no_std]

use core::{arch::asm, cell::Cell};

use cortex_m::interrupt::{self, Mutex};
use cortex_m_rt::{entry, exception};
use panic_halt as _;

static TO: interrupt::Mutex<Cell<&'static (dyn Foo + Sync)>> = Mutex::new(Cell::new(&Bar));

#[entry]
fn main() -> ! {
    // trait object dispatch
    let to = interrupt::free(|cs| TO.borrow(cs).get());
    to.foo();

    Quux.foo();

    loop {}
}

trait Foo {
    // default implementation of this method
    fn foo(&self) -> bool {
        // spill variables onto the stack
        unsafe {
            asm!(
                "// {0} {1} {2} {3} {4} {5}",
                in(reg) 0, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5,
            );
        }

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
        unsafe {
            asm!(
                "// {0} {1} {2} {3} {4} {5} {6}",
                in(reg) 0, in(reg) 1, in(reg) 2, in(reg) 3, in(reg) 4, in(reg) 5, in(reg) 6,
            );
        }

        true
    }
}

struct Quux;

impl Quux {
    // not a trait method!
    #[inline(never)]
    fn foo(&self) -> bool {
        // side effect to preserve function calls to this method
        cortex_m::asm::nop();

        false
    }
}

// this handler can change the trait object at any time
#[exception]
fn SysTick() {
    interrupt::free(|cs| {
        TO.borrow(cs).set(&Baz);
    })
}

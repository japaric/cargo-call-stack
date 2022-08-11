#![no_main]
#![no_std]

use core::arch::asm;

use panic_halt as _;

#[no_mangle]
fn _start(trait_object: &dyn Foo) -> (&dyn Foo, &dyn Foo) {
    // trait object dispatch
    trait_object.foo();

    Quux.foo();

    (&Bar, &Baz)
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
    // not a trait method! but function name and signature matches `Foo::foo`'s
    #[inline(never)]
    fn foo(&self) -> bool {
        // side effect to preserve function calls to this method
        unsafe { asm!("NOP") }

        false
    }
}

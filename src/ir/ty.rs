use core::{fmt, str::FromStr};

use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{char, digit1, space0, space1},
    combinator::{map, map_res, opt},
    multi::separated_list,
    sequence::delimited,
    IResult,
};

use crate::ir::FnSig;

#[derive(Clone, Debug, Eq, Hash)]
pub enum Type<'a> {
    // `%"crate::module::Struct::<ConcreteType>"`
    Alias(&'a str),

    // `[0 x i8]`
    Array(usize, Box<Type<'a>>),

    // `double`
    Double,

    // `float`
    Float,

    // `i8`
    Integer(usize),

    // `<{ i8, i16 }>`
    PackedStruct(Vec<Type<'a>>),

    // `{ i8, [0 x i16] }`
    Struct(Vec<Type<'a>>),

    // `i32 (i32)`
    Fn(FnSig<'a>),

    // `i8*`
    Pointer(Box<Type<'a>>),

    // `ptr`
    OpaquePointer,

    // `...`
    Varargs,

    // `<4 x i32>` See: https://llvm.org/doxygen/classllvm_1_1MVT.html
    MVTVector(usize, Box<Type<'a>>),
}

impl<'a> PartialEq for Type<'a> {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::OpaquePointer, Self::OpaquePointer) => false,

            // `derive(PartialEq)` implementation
            (Self::Alias(l0), Self::Alias(r0)) => l0 == r0,
            (Self::Array(l0, l1), Self::Array(r0, r1)) => l0 == r0 && l1 == r1,
            (Self::Integer(l0), Self::Integer(r0)) => l0 == r0,
            (Self::PackedStruct(l0), Self::PackedStruct(r0)) => l0 == r0,
            (Self::Struct(l0), Self::Struct(r0)) => l0 == r0,
            (Self::Fn(l0), Self::Fn(r0)) => l0 == r0,
            (Self::Pointer(l0), Self::Pointer(r0)) => l0 == r0,
            (Self::MVTVector(l0, l1), Self::MVTVector(r0, r1)) => l0 == r0 && l1 == r1,
            _ => core::mem::discriminant(self) == core::mem::discriminant(other),
        }
    }
}

impl<'a> Type<'a> {
    pub fn erased() -> Self {
        Type::Pointer(Box::new(Type::Struct(vec![])))
    }

    // Rust uses the "erased" type `{}*` for dynamic dispatch
    pub fn has_been_erased(&self) -> bool {
        match self {
            Type::Pointer(ty) => match **ty {
                Type::Struct(ref fields) => fields.is_empty(),
                _ => false,
            },
            _ => false,
        }
    }
}

fn fmt_struct(f: &mut fmt::Formatter, fields: &[Type]) -> fmt::Result {
    f.write_str("{")?;
    let mut is_first = true;
    for field in fields {
        if is_first {
            is_first = false;
        } else {
            f.write_str(", ")?;
        }

        write!(f, "{}", field)?;
    }
    if !is_first {
        // not empty
        f.write_str(" ")?;
    }
    f.write_str("}")?;

    Ok(())
}

impl<'a> fmt::Display for Type<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Type::Alias(name) => {
                f.write_str("%\"")?;
                f.write_str(name)?;
                f.write_str("\"")?;
            }

            Type::Array(count, ty) => {
                f.write_str("[")?;
                write!(f, "{}", count)?;
                f.write_str(" x ")?;
                write!(f, "{}", ty)?;
                f.write_str("]")?;
            }

            Type::Double => {
                f.write_str("double")?;
            }

            Type::Float => {
                f.write_str("float")?;
            }

            Type::OpaquePointer => {
                f.write_str("ptr")?;
            }

            Type::Integer(n) => {
                f.write_str("i")?;
                write!(f, "{}", n)?;
            }

            Type::PackedStruct(fields) => {
                f.write_str("<")?;
                fmt_struct(f, fields)?;
                f.write_str(">")?;
            }

            Type::Struct(fields) => {
                fmt_struct(f, fields)?;
            }

            Type::Fn(sig) => {
                write!(f, "{}", sig)?;
            }

            Type::Pointer(ty) => {
                write!(f, "{}", ty)?;
                f.write_str("*")?;
            }
            Type::Varargs => {
                f.write_str("...")?;
            }
            Type::MVTVector(count, ty) => {
                f.write_str("<")?;
                write!(f, "{}", count)?;
                f.write_str(" x ")?;
                write!(f, "{}", ty)?;
                f.write_str(">")?;
            }
        }

        Ok(())
    }
}

fn array(i: &str) -> IResult<&str, Type> {
    delimited(
        char('['),
        |i| {
            let (i, count) = map_res(digit1, usize::from_str)(i)?;
            let i = space1(i)?.0;
            let i = char('x')(i)?.0;
            let i = space1(i)?.0;
            let (i, ty) = type_(i)?;
            Ok((i, Type::Array(count, Box::new(ty))))
        },
        char(']'),
    )(i)
}

fn mvt_vector(i: &str) -> IResult<&str, Type> {
    delimited(
        char('<'),
        |i| {
            let (i, count) = map_res(digit1, usize::from_str)(i)?;
            let i = space1(i)?.0;
            let i = char('x')(i)?.0;
            let i = space1(i)?.0;
            let (i, ty) = type_(i)?;
            Ok((i, Type::MVTVector(count, Box::new(ty))))
        },
        char('>'),
    )(i)
}

fn double(i: &str) -> IResult<&str, Type> {
    Ok((tag("double")(i)?.0, Type::Double))
}

fn float(i: &str) -> IResult<&str, Type> {
    Ok((tag("float")(i)?.0, Type::Float))
}

fn opaque_pointer(i: &str) -> IResult<&str, Type> {
    Ok((tag("ptr")(i)?.0, Type::OpaquePointer))
}

fn integer(i: &str) -> IResult<&str, Type> {
    let i = char('i')(i)?.0;
    let (i, count) = map_res(digit1, usize::from_str)(i)?;
    Ok((i, Type::Integer(count)))
}

fn alias(i: &str) -> IResult<&str, Type> {
    map(super::alias, |a| Type::Alias(a.0))(i)
}

fn varargs(i: &str) -> IResult<&str, Type> {
    Ok((tag("...")(i)?.0, Type::Varargs))
}

fn _struct(i: &str) -> IResult<&str, Vec<Type>> {
    let i = char('{')(i)?.0;
    let i = space0(i)?.0;
    let (i, fields) = separated_list(
        |i| {
            let i = char(',')(i)?.0;
            space1(i)
        },
        type_,
    )(i)?;
    let i = space0(i)?.0;
    let i = char('}')(i)?.0;
    Ok((i, fields))
}

fn packed_struct(i: &str) -> IResult<&str, Type> {
    let i = char('<')(i)?.0;
    let (i, fields) = _struct(i)?;
    let i = char('>')(i)?.0;
    Ok((i, Type::PackedStruct(fields)))
}

fn struct_(i: &str) -> IResult<&str, Type> {
    map(_struct, Type::Struct)(i)
}

pub fn type_(i: &str) -> IResult<&str, Type> {
    let (i, void) = opt(tag("void"))(i)?;

    if void.is_some() {
        // this must be a function
        let i = space1(i)?.0;
        let (mut i, inputs) = fn_inputs(i)?;
        let mut ty = Type::Fn(FnSig {
            inputs,
            output: None,
        });

        // is this a function pointer?
        loop {
            let (i_, star) = opt(char('*'))(i)?;

            if star.is_none() {
                break;
            } else {
                i = i_;
                ty = Type::Pointer(Box::new(ty));
            }
        }

        Ok((i, ty))
    } else {
        let (mut i, mut ty) = alt((
            array,
            packed_struct,
            struct_,
            alias,
            double,
            float,
            opaque_pointer,
            integer,
            varargs,
            mvt_vector,
        ))(i)?;

        // is this a pointer?
        loop {
            let (i_, star) = opt(char('*'))(i)?;

            if star.is_none() {
                break;
            } else {
                i = i_;
                ty = Type::Pointer(Box::new(ty));
            }
        }

        // is this a function?
        loop {
            let (i_, inputs) = opt(|i| {
                let i = space1(i)?.0;
                fn_inputs(i)
            })(i)?;

            if let Some(inputs) = inputs {
                i = i_;
                ty = Type::Fn(FnSig {
                    inputs,
                    output: Some(Box::new(ty)),
                });

                // is this a function pointer?
                loop {
                    let (i_, star) = opt(char('*'))(i)?;

                    if star.is_none() {
                        break;
                    } else {
                        i = i_;
                        ty = Type::Pointer(Box::new(ty));
                    }
                }
            } else {
                break;
            }
        }

        Ok((i, ty))
    }
}

fn fn_inputs(i: &str) -> IResult<&str, Vec<Type>> {
    let i = char('(')(i)?.0;
    let i = space0(i)?.0;
    let (i, inputs) = separated_list(
        |i| {
            let i = char(',')(i)?.0;
            space1(i)
        },
        type_,
    )(i)?;
    let i = char(')')(i)?.0;
    Ok((i, inputs))
}

#[cfg(test)]
mod tests {
    use crate::ir::{FnSig, Type};

    #[test]
    fn fn_inputs() {
        assert_eq!(super::fn_inputs(r#"()"#), Ok(("", vec![])));
    }

    #[test]
    fn sanity() {
        assert_eq!(super::integer("i8"), Ok(("", Type::Integer(8))));
        assert_eq!(super::integer("i16"), Ok(("", Type::Integer(16))));
        assert_eq!(super::integer("i32"), Ok(("", Type::Integer(32))));

        assert_eq!(
            super::array("[0 x i32]"),
            Ok(("", Type::Array(0, Box::new(Type::Integer(32)))))
        );
        assert_eq!(
            super::array("[11 x i8]"),
            Ok(("", Type::Array(11, Box::new(Type::Integer(8)))))
        );

        assert_eq!(
            super::struct_("{ i8, i16 }"),
            Ok(("", Type::Struct(vec![Type::Integer(8), Type::Integer(16)])))
        );
        assert_eq!(super::struct_("{}"), Ok(("", Type::Struct(vec![]))));

        // nested
        assert_eq!(
            super::struct_(
                "{ \
                 { i8, i16 }, \
                 { i8*, i16* } \
                 }"
            ),
            Ok((
                "",
                Type::Struct(vec![
                    Type::Struct(vec![Type::Integer(8), Type::Integer(16)]),
                    Type::Struct(vec![
                        Type::Pointer(Box::new(Type::Integer(8))),
                        Type::Pointer(Box::new(Type::Integer(16))),
                    ]),
                ])
            ))
        );

        assert_eq!(
            super::type_("i8*"),
            Ok(("", Type::Pointer(Box::new(Type::Integer(8)))))
        );

        assert_eq!(
            super::type_("i8**"),
            Ok((
                "",
                Type::Pointer(Box::new(Type::Pointer(Box::new(Type::Integer(8)))))
            ))
        );

        // function pointers
        assert_eq!(
            super::type_("void (i8*)*"),
            Ok((
                "",
                Type::Pointer(Box::new(Type::Fn(FnSig {
                    inputs: vec![Type::Pointer(Box::new(Type::Integer(8)))],
                    output: None,
                })))
            ))
        );

        assert_eq!(
            super::type_("i8 (i8)*"),
            Ok((
                "",
                Type::Pointer(Box::new(Type::Fn(FnSig {
                    inputs: vec![Type::Integer(8)],
                    output: Some(Box::new(Type::Integer(8))),
                })))
            ))
        );

        assert_eq!(
            super::type_("void ()**"),
            Ok((
                "",
                Type::Pointer(Box::new(Type::Pointer(Box::new(Type::Fn(FnSig {
                    inputs: vec![],
                    output: None,
                })))))
            ))
        );
    }

    #[test]
    fn varargs() {
        assert_eq!(super::varargs(r#"..."#), Ok(("", Type::Varargs)));
    }

    #[test]
    fn mvt_vector() {
        assert_eq!(
            super::mvt_vector(r#"<4 x i32>"#),
            Ok(("", Type::MVTVector(4, Box::new(Type::Integer(32)))))
        );
    }
}

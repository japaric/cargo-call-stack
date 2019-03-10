use core::{fmt, str::FromStr};

use nom::{types::CompleteStr, *};

use crate::ir::FnSig;

// NOTE we don't keep track of pointers; `i8` and `i8*` are both considered `Type::Integer`
#[derive(Clone, Debug, Eq, Hash, PartialEq)]
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
        }

        Ok(())
    }
}

named!(array<CompleteStr, Type>, delimited!(
    char!('['),
    do_parse!(
        count: map_res!(digit, |cs: CompleteStr| usize::from_str(cs.0)) >> space >>
            char!('x') >> space >>
            ty: type_ >>
            (Type::Array(count, Box::new(ty)))
    ),
    char!(']')
));

named!(double<CompleteStr, Type>, map!(tag!("double"), |_| Type::Double));

named!(float<CompleteStr, Type>, map!(tag!("float"), |_| Type::Float));

named!(integer<CompleteStr, Type>, do_parse!(
    char!('i') >>
       count: map_res!(digit, |cs: CompleteStr| usize::from_str(cs.0)) >>
        (Type::Integer(count)))
);

named!(alias<CompleteStr, Type>, map!(super::alias, |a| Type::Alias(a.0)));

named!(_struct<CompleteStr, Vec<Type>>, do_parse!(
    char!('{') >> space0 >>
        fields: separated_list!(do_parse!(char!(',') >> space >> (())), type_) >> space0 >>
        char!('}') >>
        (fields)
));

named!(packed_struct<CompleteStr, Type>, do_parse!(
    char!('<') >>
        fields: _struct >>
        char!('>') >>
        (Type::PackedStruct(fields))
));

named!(struct_<CompleteStr, Type>, map!(_struct, Type::Struct));

pub fn type_(input: CompleteStr) -> IResult<CompleteStr, Type> {
    let (rest, void) = opt!(input, tag!("void"))?;

    if void.is_some() {
        // this must be a function
        let (mut rest, inputs) = do_parse!(rest, space >> inputs: fn_inputs >> (inputs))?;
        let mut ty = Type::Fn(FnSig {
            inputs,
            output: None,
        });

        // is this a function pointer?
        loop {
            let (rest_, start) = opt!(rest, char!('*'))?;

            if start.is_none() {
                break;
            } else {
                rest = rest_;
                ty = Type::Pointer(Box::new(ty));
            }
        }

        Ok((rest, ty))
    } else {
        let (mut rest, mut ty) = alt!(
            rest,
            array | packed_struct | struct_ | alias | double | float | integer
        )?;

        // is this a pointer?
        loop {
            let (rest_, start) = opt!(rest, char!('*'))?;

            if start.is_none() {
                break;
            } else {
                rest = rest_;
                ty = Type::Pointer(Box::new(ty));
            }
        }

        // is this a function?
        loop {
            let (rest_, inputs) = opt!(rest, do_parse!(space >> inputs: fn_inputs >> (inputs)))?;

            if let Some(inputs) = inputs {
                rest = rest_;
                ty = Type::Fn(FnSig {
                    inputs,
                    output: Some(Box::new(ty)),
                });

                // is this a function pointer?
                loop {
                    let (rest_, start) = opt!(rest, char!('*'))?;

                    if start.is_none() {
                        break;
                    } else {
                        rest = rest_;
                        ty = Type::Pointer(Box::new(ty));
                    }
                }
            } else {
                break;
            }
        }

        Ok((rest, ty))
    }
}

named!(fn_inputs<CompleteStr, Vec<Type>>, do_parse!(
    char!('(') >> space0 >>
        inputs: separated_list!(do_parse!(char!(',') >> space >> (())), type_) >>
        char!(')') >>
        (inputs)
));

#[cfg(test)]
mod tests {
    use nom::types::CompleteStr as S;

    use crate::ir::{FnSig, Type};

    #[test]
    fn fn_inputs() {
        assert_eq!(super::fn_inputs(S(r#"()"#)), Ok((S(""), vec![])));
    }

    #[test]
    fn sanity() {
        assert_eq!(super::integer(S("i8")), Ok((S(""), Type::Integer(8))));
        assert_eq!(super::integer(S("i16")), Ok((S(""), Type::Integer(16))));
        assert_eq!(super::integer(S("i32")), Ok((S(""), Type::Integer(32))));

        assert_eq!(
            super::array(S("[0 x i32]")),
            Ok((S(""), Type::Array(0, Box::new(Type::Integer(32)))))
        );
        assert_eq!(
            super::array(S("[11 x i8]")),
            Ok((S(""), Type::Array(11, Box::new(Type::Integer(8)))))
        );

        assert_eq!(
            super::struct_(S("{ i8, i16 }")),
            Ok((
                S(""),
                Type::Struct(vec![Type::Integer(8), Type::Integer(16)])
            ))
        );
        assert_eq!(super::struct_(S("{}")), Ok((S(""), Type::Struct(vec![]))));

        // nested
        assert_eq!(
            super::struct_(S("{ \
                              { i8, i16 }, \
                              { i8*, i16* } \
                              }")),
            Ok((
                S(""),
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
            super::type_(S("i8*")),
            Ok((S(""), Type::Pointer(Box::new(Type::Integer(8)))))
        );

        assert_eq!(
            super::type_(S("i8**")),
            Ok((
                S(""),
                Type::Pointer(Box::new(Type::Pointer(Box::new(Type::Integer(8)))))
            ))
        );

        // function pointers
        assert_eq!(
            super::type_(S("void (i8*)*")),
            Ok((
                S(""),
                Type::Pointer(Box::new(Type::Fn(FnSig {
                    inputs: vec![Type::Pointer(Box::new(Type::Integer(8)))],
                    output: None,
                })))
            ))
        );

        assert_eq!(
            super::type_(S("i8 (i8)*")),
            Ok((
                S(""),
                Type::Pointer(Box::new(Type::Fn(FnSig {
                    inputs: vec![Type::Integer(8)],
                    output: Some(Box::new(Type::Integer(8))),
                })))
            ))
        );

        assert_eq!(
            super::type_(S("void ()**")),
            Ok((
                S(""),
                Type::Pointer(Box::new(Type::Pointer(Box::new(Type::Fn(FnSig {
                    inputs: vec![],
                    output: None,
                })))))
            ))
        );
    }
}

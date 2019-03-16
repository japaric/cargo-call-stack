use core::fmt;

use failure::format_err;
use nom::{types::CompleteStr, *};

mod define;
mod item;
mod ty;

pub use crate::ir::{
    define::{Define, Stmt},
    item::{Declare, Item},
    ty::{type_, Type},
};

#[derive(Clone, Debug, Eq, Hash, PartialEq)]
pub struct FnSig<'a> {
    pub inputs: Vec<Type<'a>>,
    pub output: Option<Box<Type<'a>>>,
}

impl<'a> fmt::Display for FnSig<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        if let Some(output) = &self.output {
            write!(f, "{}", output)?;
        } else {
            f.write_str("void")?;
        }

        f.write_str(" (")?;
        let mut is_first = true;
        for input in &self.inputs {
            if is_first {
                is_first = false;
            } else {
                f.write_str(", ")?;
            }

            write!(f, "{}", input)?;
        }
        f.write_str(")")
    }
}

pub fn parse<'a>(ll: &'a str) -> Result<Vec<Item<'a>>, failure::Error> {
    items(CompleteStr(ll)).map(|t| t.1).map_err(|e| {
        format_err!(
            "BUG: failed to parse .ll file; please submit a bug report. Details:\n{}",
            e
        )
    })
}

named!(items<CompleteStr, Vec<Item>>, do_parse!(
    items: separated_list_complete!(many1!(line_ending), crate::ir::item::item) >>
        many0!(line_ending) >>
        eof!() >>
        (items)
));

#[derive(Clone, Copy, Debug, PartialEq)]
struct Comment;

named!(comment<CompleteStr, Comment>, do_parse!(
    char!(';') >>
        not_line_ending >>
        (Comment))
);

#[derive(Clone, Copy, Debug, PartialEq)]
struct Ident<'a>(&'a str);

// LLVM LangRef: `[-a-zA-Z$._][-a-zA-Z$._0-9]*`
// not using `named!` because lifetime inference doesn't work correctly
fn ident<'a>(input: CompleteStr<'a>) -> IResult<CompleteStr<'a>, Ident<'a>> {
    map_res!(
        input,
        take_while1!(|c: char| c.is_alphanumeric() || "-$._".contains(c)),
        |s: CompleteStr<'a>| if s.chars().next().unwrap_or('\0').is_digit(10) {
            Err(())
        } else {
            Ok(Ident(s.0))
        }
    )
}

#[derive(Clone, Copy, Debug, PartialEq)]
struct Global<'a>(Option<&'a str>);

named!(global<CompleteStr, Global>, do_parse!(
    char!('@') >>
        s: alt!(map!(string, |s| Some(s.0)) | map!(digit, |_| None) | map!(ident, |i| Some(i.0))) >>
        (Global(s)))
);

#[derive(Clone, Copy, Debug, PartialEq)]
struct Local;

named!(local<CompleteStr, Local>, do_parse!(
    char!('%') >>
        alt!(map!(digit, drop) | map!(ident, drop)) >>
        (Local))
);

// `internal`, `fastcc`, `dereferenceable(4)`, etc.
#[derive(Clone, Copy, Debug, PartialEq)]
struct Attribute;

named!(attribute<CompleteStr, Attribute>, do_parse!(
    switch!(
        take_while1!(|c: char| c.is_alphabetic() || c == '_'),
        CompleteStr("dereferenceable") | CompleteStr("dereferenceable_or_null")
            => do_parse!(char!('(') >> digit >> char!(')') >> (())) |
        CompleteStr("align") => do_parse!(space >> digit >> (())) |
        // have this branch always error because this is not an attribute but part of a type
        CompleteStr("double") |CompleteStr("float") | CompleteStr("void") =>
            do_parse!(none_of!(" ") >> (())) |
        // have this branch always error because there are not attributes but operations
        CompleteStr("bitcast") | CompleteStr("getelementptr") => do_parse!(none_of!(" ") >> (())) |
        // have this branch always error because there are not attributes but keywords
        CompleteStr("alias") | CompleteStr("global") | CompleteStr("constant") =>
            do_parse!(none_of!(" ") >> (())) |
        _ => do_parse!((()))) >>
        (Attribute)
));

// NOTE constant operation
#[derive(Clone, Copy, Debug, PartialEq)]
struct Bitcast<'a>(Option<&'a str>);

named!(bitcast<CompleteStr, Bitcast>, do_parse!(
    tag!("bitcast") >> space >>
        name: delimited!(
            char!('('),
            do_parse!(
                call!(type_) >> space >>
                    name: global >> space >>
                    tag!("to") >> space >>
                    call!(type_) >> (name.0)
            ),
            char!(')')
        ) >> (Bitcast(name))
));

// NOTE constant operation
#[derive(Clone, Copy, Debug, PartialEq)]
struct GetElementPtr;

named!(getelementptr<CompleteStr, GetElementPtr>, do_parse!(
    tag!("getelementptr") >> space >>
        opt!(do_parse!(tag!("inbounds") >> space >> ())) >>
        delimited!(char!('('), do_parse!(
            type_ >> char!(',') >> space >>
                type_ >> space >>
                global >>
                many1!(do_parse!(char!(',') >> space >> type_ >> space >> digit >> (()))) >>
                (())
        ), char!(')')) >>
        (GetElementPtr)
));

named!(name<CompleteStr, &str>,
       alt!(
           map!(string, |s| s.0) |
           map!(ident, |i| i.0)
       )
);

#[derive(Clone, Copy, Debug, PartialEq)]
pub struct Function<'a>(pub &'a str);

named!(function<CompleteStr, Function>, do_parse!(
    char!('@') >>
        name: name >>
        (Function(name))
));

#[derive(Clone, Copy, Debug, PartialEq)]
struct Alias<'a>(&'a str);

named!(alias<CompleteStr, Alias>, do_parse!(
    char!('%') >>
       name: name >>
        (Alias(name)))
);

#[derive(Clone, Copy, Debug, PartialEq)]
struct String<'a>(&'a str);

// NOTE this will accept things that are not valid in LLVM-IR but we are only dealing with
// well-formed LLVM-IR so this is good enough
named!(string<CompleteStr, String>, do_parse!(
    char!('"') >>
        x: take_until!("\"") >>
        char!('"') >>
        (String(&x)))
);

#[cfg(test)]
mod tests {
    use nom::types::CompleteStr as S;

    use super::{Alias, Comment, FnSig, GetElementPtr, Ident, Local, String, Type};

    #[test]
    fn alias() {
        assert_eq!(
            super::alias(S("%\"blue_pill::ItmLogger\"")),
            Ok((S(""), Alias("blue_pill::ItmLogger")))
        );

        assert_eq!(
            super::alias(S("%ExceptionFrame")),
            Ok((S(""), Alias("ExceptionFrame")))
        );

        assert_eq!(super::alias(S("%value")), Ok((S(""), Alias("value"))));
    }

    #[test]
    fn attribute() {
        assert!(super::attribute(S("void")).is_err());
    }

    #[test]
    fn comment() {
        assert_eq!(
            super::comment(S("; core::ptr::real_drop_in_place")),
            Ok((S(""), Comment)),
        );

        assert_eq!(
            super::comment(S("; Function Attrs: norecurse nounwind readnone")),
            Ok((S(""), Comment)),
        );
    }

    #[test]
    fn getelementptr() {
        assert_eq!(
            super::getelementptr(S("getelementptr inbounds (<{ [0 x i8] }>, <{ [0 x i8] }>* @anon.3751ff68b49c735a867036886cf6a576.71, i32 0, i32 0)")),
            Ok((S(""), GetElementPtr)),
        );
    }

    #[test]
    fn ident() {
        assert_eq!(super::ident(S("__sbss")), Ok((S(""), Ident("__sbss"))));
        assert_eq!(
            super::ident(S("__EXCEPTIONS")),
            Ok((S(""), Ident("__EXCEPTIONS")))
        );

        // NOTE trailing space
        assert_eq!(
            super::ident(S("ExceptionFrame ")),
            Ok((S(" "), Ident("ExceptionFrame")))
        );

        assert!(super::ident(S("\"foo\"")).is_err());
        assert!(super::ident(S("0foo")).is_err());
    }

    #[test]
    fn local() {
        assert_eq!(super::local(S("%113")), Ok((S(""), Local)));

        assert_eq!(super::local(S("%.")), Ok((S(""), Local)));

        assert_eq!(super::local(S("%.9")), Ok((S(""), Local)));
    }

    #[test]
    fn fmt_sig() {
        assert_eq!(
            FnSig {
                inputs: vec![],
                output: None,
            }
            .to_string(),
            "void ()"
        );

        assert_eq!(
            FnSig {
                inputs: vec![Type::Integer(8)],
                output: None,
            }
            .to_string(),
            "void (i8)"
        );

        assert_eq!(
            FnSig {
                inputs: vec![Type::Integer(8)],
                output: Some(Box::new(Type::Integer(8))),
            }
            .to_string(),
            "i8 (i8)"
        );
    }

    #[test]
    fn string() {
        assert_eq!(
            // "こんにちわ"
            super::string(S(r#""\E3\81\93\E3\82\93\E3\81\AB\E3\81\A1\E3\82\8F""#)),
            Ok((
                S(""),
                String(r#"\E3\81\93\E3\82\93\E3\81\AB\E3\81\A1\E3\82\8F"#)
            )),
        );

        assert_eq!(
            super::string(S(r#""Hello, world!""#)),
            Ok((S(""), String("Hello, world!")))
        );

        // "\"He\nllo\""
        assert_eq!(
            super::string(S(r#""\22He\0Allo\22""#)),
            Ok((S(""), String(r#"\22He\0Allo\22"#)))
        );

        // NOTE trailing space
        assert_eq!(
            super::string(S(r#""Hello" "#)),
            Ok((S(" "), String("Hello")))
        );
    }
}

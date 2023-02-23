use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{char, not_line_ending, space0, space1},
    combinator::map,
    multi::{many0, separated_list0},
    IResult,
};

use crate::ir::{define::Define, FnSig};

#[derive(Clone, Debug, PartialEq)]
pub enum Item<'a> {
    // `@__pre_init = unnamed_addr alias void (), void ()* @DefaultPreInit`
    Alias(&'a str, &'a str),

    // `; ModuleID = 'ipv4.e7riqz8u-cgu.0'`
    Comment,

    // `source_filename = "ipv4.e7riqz8u-cgu.0"`
    SourceFilename,

    // `target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"`
    Target,

    // `@0 = private constant <{ [0 x i8 ]}> zeroinitializer, align 4, !dbg 0`
    // `@__sbss = external global i32`
    Global,

    // `%Struct = type { i8, i16 }` ("new type")
    Type,

    // `define void @main() unnamed_addr #3 !dbg !4512 { (..) }`
    Define(Define<'a>),

    // `declare void @llvm.dbg.declare(metadata, metadata, metadata) #4`
    Declare(Declare<'a>),

    // `attributes #0 = { norecurse nounwind readnone "target-cpu"="generic" }`
    Attributes,

    // `!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())`
    Metadata,

    // `module asm "assembly snippet"`
    ModuleAsm,
}

#[derive(Clone, Debug, PartialEq)]
pub struct Declare<'a> {
    pub name: &'a str,
    pub sig: Option<FnSig<'a>>,
}

fn comment(i: &str) -> IResult<&str, Item> {
    let i = super::comment(i)?.0;
    Ok((i, Item::Comment))
}

fn source_filename(i: &str) -> IResult<&str, Item> {
    let i = tag("source_filename")(i)?.0;
    let i = space1(i)?.0;
    let i = char('=')(i)?.0;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Item::SourceFilename))
}

fn target(i: &str) -> IResult<&str, Item> {
    let i = tag("target")(i)?.0;
    let i = space1(i)?.0;
    let i = alt((tag("datalayout"), tag("triple")))(i)?.0;
    let i = space1(i)?.0;
    let i = char('=')(i)?.0;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Item::Target))
}

fn alias(i: &str) -> IResult<&str, Item> {
    let (i, name) = super::function(i)?;
    let i = space1(i)?.0;
    let i = char('=')(i)?.0;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = tag("alias")(i)?.0;
    let i = space1(i)?.0;
    let i = super::type_(i)?.0;
    let i = space0(i)?.0;
    let i = char(',')(i)?.0;
    let i = space1(i)?.0;
    let i = super::type_(i)?.0;
    let i = space1(i)?.0;
    let (i, alias) = super::function(i)?;
    Ok((i, Item::Alias(name.0, alias.0)))
}

fn global(i: &str) -> IResult<&str, Item> {
    let i = super::global(i)?.0;
    let i = space1(i)?.0;
    let i = char('=')(i)?.0;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = alt((tag("global"), tag("constant")))(i)?.0;
    let i = space1(i)?.0;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Item::Global))
}

fn type_(i: &str) -> IResult<&str, Item> {
    let i = super::alias(i)?.0;
    let i = space1(i)?.0;
    let i = char('=')(i)?.0;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Item::Type))
}

fn declare(i: &str) -> IResult<&str, Item> {
    let i = tag("declare")(i)?.0;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let (i, output) = alt((map(super::type_, Some), map(tag("void"), |_| None)))(i)?;
    let i = space1(i)?.0;
    let (i, name) = super::function(i)?;
    let i = char('(')(i)?.0;

    let name = name.0;
    if name.starts_with("llvm.") {
        // llvm intrinsic; we don't care about these
        let i = not_line_ending(i)?.0;
        Ok((i, Item::Declare(Declare { name, sig: None })))
    } else {
        let (i, inputs) = separated_list0(
            |i| {
                let i = char(',')(i)?.0;
                space1(i)
            },
            |i| {
                let (i, ty) = super::type_(i)?;
                let i = many0(|i| {
                    let i = space1(i)?.0;
                    super::attribute(i)
                })(i)?
                .0;
                Ok((i, ty))
            },
        )(i)?;
        let i = char(')')(i)?.0;
        let i = not_line_ending(i)?.0;
        Ok((
            i,
            Item::Declare(Declare {
                name,
                sig: Some(FnSig {
                    output: output.map(Box::new),
                    inputs,
                }),
            }),
        ))
    }
}

fn attributes(i: &str) -> IResult<&str, Item> {
    let i = tag("attributes")(i)?.0;
    let i = space1(i)?.0;
    let i = char('#')(i)?.0;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Item::Attributes))
}

fn metadata(i: &str) -> IResult<&str, Item> {
    let i = tag("!")(i)?.0;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Item::Metadata))
}

fn module_asm(i: &str) -> IResult<&str, Item> {
    let i = tag("module")(i)?.0;
    let i = space1(i)?.0;
    let i = tag("asm")(i)?.0;
    let i = space1(i)?.0;
    let i = super::string(i)?.0;
    Ok((i, Item::ModuleAsm))
}

pub fn item(i: &str) -> IResult<&str, Item> {
    alt((
        comment,
        source_filename,
        target,
        type_,
        global,
        alias,
        map(super::define::parse, Item::Define),
        declare,
        attributes,
        metadata,
        module_asm,
    ))(i)
}

#[cfg(test)]
mod tests {
    use crate::ir::{Declare, FnSig, Item, Type};

    #[test]
    fn alias() {
        assert_eq!(
            super::alias(r#"@__pre_init = unnamed_addr alias void (), void ()* @DefaultPreInit"#),
            Ok(("", Item::Alias("__pre_init", "DefaultPreInit")))
        );
    }

    #[test]
    fn declare() {
        assert_eq!(
            super::declare(r#"declare noalias i8* @malloc(i64) unnamed_addr #3"#),
            Ok((
                "",
                Item::Declare(Declare {
                    name: "malloc",
                    sig: Some(FnSig {
                        inputs: vec![Type::Integer(64)],
                        output: Some(Box::new(Type::Pointer(Box::new(Type::Integer(8)))))
                    })
                })
            ))
        );
    }

    #[test]
    fn global() {
        assert_eq!(
            super::global("@0 = private constant <{ [0 x i8] }> zeroinitializer, align 4, !dbg !0"),
            Ok(("", Item::Global))
        );

        assert_eq!(
            super::global("@DEVICE_PERIPHERALS = local_unnamed_addr global <{ [1 x i8] }> zeroinitializer, align 1, !dbg !175"),
            Ok(("", Item::Global))
        );
    }

    #[test]
    fn module_asm() {
        assert_eq!(super::item(r#"module asm """#), Ok(("", Item::ModuleAsm)));
        assert_eq!(
            super::item(r#"module asm "            .section .llvmbc,\22e\22""#),
            Ok(("", Item::ModuleAsm))
        );
    }

    #[test]
    fn type_() {
        assert_eq!(
            super::type_("%0 = type { i32, { i8*, i8* } }"),
            Ok(("", Item::Type))
        );

        assert_eq!(
            super::type_("%\"blue_pill::ItmLogger\" = type {}"),
            Ok(("", Item::Type))
        );
    }
}

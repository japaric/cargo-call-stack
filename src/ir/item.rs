use nom::{types::CompleteStr, *};

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
    Metadata(Metadata<'a>),
}

#[derive(Clone, Debug, PartialEq)]
pub enum Metadata<'a> {
    // `!llvm.module.flags = !{!1041, !1042, !1043}`
    Named,

    // `!6 = !{!7}`
    Unnamed { id: u32, kind: MetadataKind<'a> },
}

#[derive(Clone, Debug, PartialEq)]
pub enum MetadataKind<'a> {
    // `!{!1, !2}`
    Set(Vec<u32>),

    // `!{!"drop", "Trait"}`
    Drop { trait_: &'a str },

    // `!{!"dyn", !"Trait", !"method"}`
    Dyn { trait_: &'a str, method: &'a str },

    // `!{!"fn", !"fn() -> i32"}`
    Fn { sig: &'a str },
}

#[derive(Clone, Debug, PartialEq)]
pub struct Declare<'a> {
    pub name: &'a str,
    pub sig: Option<FnSig<'a>>,
}

named!(comment<CompleteStr, Item>, map!(super::comment, |_| Item::Comment));

named!(source_filename<CompleteStr, Item>, do_parse!(
    tag!("source_filename") >> space >>
        char!('=') >> not_line_ending >> // shortcut
        (Item::SourceFilename)
));

named!(target<CompleteStr, Item>, do_parse!(
    tag!("target") >> space >>
        alt!(tag!("datalayout") | tag!("triple")) >> space >>
        char!('=') >> not_line_ending >> // shortcut
        (Item::Target)
));

named!(alias<CompleteStr, Item>, do_parse!(
    name: call!(super::function) >> space >>
        char!('=') >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        tag!("alias") >> space >>
        call!(super::type_) >> space0 >>
        char!(',') >> space >>
        call!(super::type_) >> space >>
        alias: call!(super::function) >>
        (Item::Alias(name.0, alias.0))
));

named!(global<CompleteStr, Item>, do_parse!(
    call!(super::global) >> space >>
        char!('=') >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        alt!(tag!("global") | tag!("constant")) >> space >>
        not_line_ending >>
        (Item::Global)
));

named!(type_<CompleteStr, Item>, do_parse!(
    call!(super::alias) >> space >>
        char!('=') >>
    // NOTE shortcut
        not_line_ending >>
        (Item::Type)
));

// named!(declare<CompleteStr, Item>, do_parse!(
//     tag!("declare") >> space >>
//         many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
//         output: alt!(map!(call!(super::type_), Some) | map!(tag!("void"), |_|)) >> space >>
//         name: call!(super::function) >>
//         char!('(') >>
//     // NOTE shortcut
//         not_line_ending >>
//         (Item::Declare(name.0))
// ));

fn declare(input: CompleteStr) -> IResult<CompleteStr, Item> {
    let (rest, (output, name)) = do_parse!(
        input,
        tag!("declare")
            >> space
            >> many0!(do_parse!(call!(super::attribute) >> space >> (())))
            >> output: alt!(map!(call!(super::type_), Some) | map!(tag!("void"), |_| None))
            >> space
            >> name: call!(super::function)
            >> char!('(')
            >> ((output, name.0))
    )?;

    if name.starts_with("llvm.") {
        // llvm intrinsic; we don't care about these
        do_parse!(
            rest,
            not_line_ending >> (Item::Declare(Declare { name, sig: None }))
        )
    } else {
        do_parse!(
            rest,
            inputs:
                separated_list!(
                    do_parse!(char!(',') >> space >> (())),
                    do_parse!(
                        ty: call!(super::type_)
                            >> many0!(do_parse!(space >> call!(super::attribute) >> (())))
                            >> (ty)
                    )
                )
                >> char!(')')
                >> not_line_ending
                >> (Item::Declare(Declare {
                    name,
                    sig: Some(FnSig {
                        output: output.map(Box::new),
                        inputs
                    })
                }))
        )
    }
}

named!(attributes<CompleteStr, Item>, do_parse!(
    tag!("attributes") >> space >> char!('#') >>
        // NOTE shortcut
        not_line_ending >>
        (Item::Attributes)
));

named!(metadata<CompleteStr, Item>, do_parse!(
    tag!("!") >>
        meta: alt!(
            do_parse!(
                id: map_res!(digit, |cs: CompleteStr| cs.0.parse::<u32>()) >> space >>
                    char!('=') >> space >>
                    kind: metadata_kind >>
                    (Metadata::Unnamed { id, kind })) |
            do_parse!(not_line_ending >> (Metadata::Named))
        ) >>
        (Item::Metadata(meta))
));

named!(metadata_kind<CompleteStr, MetadataKind>, do_parse!(
    tag!("!{") >>
    kind: alt!(
        do_parse!(
            tag!("!\"drop\",") >> space >>
                char!('!') >>
                t: call!(super::string) >>
                (MetadataKind::Drop { trait_: t.0 })
        ) |
        do_parse!(
            tag!("!\"dyn\",") >> space >>
                char!('!') >>
                t: call!(super::string) >> char!(',') >> space >>
                char!('!') >>
                m: call!(super::string) >>
                (MetadataKind::Dyn { trait_: t.0, method: m.0 })) |
        do_parse!(
            tag!("!\"fn\",") >> space >>
                char!('!') >>
                s: call!(super::string) >>
                (MetadataKind::Fn { sig: s.0 })
        ) |
        do_parse!(
            ids: separated_list!(
                do_parse!(char!(',') >> space >> (())),
                do_parse!(
                    char!('!') >>
                        n: map_res!(digit, |cs: CompleteStr| cs.0.parse::<u32>()) >>
                        (n)
                )
            ) >>
                (MetadataKind::Set(ids))
        )
    ) >> space0 >> tag!("}") >>
        (kind)
));

named!(pub item<CompleteStr, Item>, alt!(
    comment |
    source_filename |
    target |
    type_ |
    global |
    alias |
    map!(call!(super::define::parse), Item::Define) |
    declare |
    attributes |
    metadata
));

#[cfg(test)]
mod tests {
    use nom::types::CompleteStr as S;

    use crate::ir::{Declare, FnSig, Item, ItemMetadata, MetadataKind, Type};

    #[test]
    fn alias() {
        assert_eq!(
            super::alias(S(
                r#"@__pre_init = unnamed_addr alias void (), void ()* @DefaultPreInit"#
            )),
            Ok((S(""), Item::Alias("__pre_init", "DefaultPreInit")))
        );
    }

    #[test]
    fn declare() {
        assert_eq!(
            super::declare(S(r#"declare noalias i8* @malloc(i64) unnamed_addr #3"#)),
            Ok((
                S(""),
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
            super::global(S(
                "@0 = private constant <{ [0 x i8] }> zeroinitializer, align 4, !dbg !0"
            )),
            Ok((S(""), Item::Global))
        );

        assert_eq!(
            super::global(S(
                "@DEVICE_PERIPHERALS = local_unnamed_addr global <{ [1 x i8] }> zeroinitializer, align 1, !dbg !175"
            )),
            Ok((S(""), Item::Global))
        );
    }

    #[test]
    fn type_() {
        assert_eq!(
            super::type_(S("%\"blue_pill::ItmLogger\" = type {}")),
            Ok((S(""), Item::Type))
        );
    }

    #[test]
    fn metadata() {
        assert_eq!(
            super::metadata(S("!449 = !{!54, !450}")),
            Ok((
                S(""),
                Item::Metadata(ItemMetadata::Unnamed {
                    id: 449,
                    kind: MetadataKind::Set(vec![54, 450])
                })
            ))
        );

        assert_eq!(
            super::metadata(S(r#"!141 = !{!"dyn", !"Foo", !"foo"}"#)),
            Ok((
                S(""),
                Item::Metadata(ItemMetadata::Unnamed {
                    id: 141,
                    kind: MetadataKind::Dyn {
                        trait_: "Foo",
                        method: "foo"
                    },
                })
            ))
        );

        assert_eq!(
            super::metadata(S(r#"!127 = !{!"drop", !"Foo"}"#)),
            Ok((
                S(""),
                Item::Metadata(ItemMetadata::Unnamed {
                    id: 127,
                    kind: MetadataKind::Drop { trait_: "Foo" },
                })
            ))
        );

        assert_eq!(
            super::metadata(S(r#"!98 = !{!"fn", !"fn() -> bool"}"#)),
            Ok((
                S(""),
                Item::Metadata(ItemMetadata::Unnamed {
                    id: 98,
                    kind: MetadataKind::Fn {
                        sig: "fn() -> bool"
                    },
                })
            ))
        );
    }
}

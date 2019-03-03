use nom::{types::CompleteStr, *};

use crate::ir::{FnSig, Type};

#[derive(Clone, Debug, PartialEq)]
pub struct Define<'a> {
    pub name: &'a str,
    pub sig: FnSig<'a>,
    pub stmts: Vec<Stmt<'a>>,
}

#[derive(Clone, Debug, PartialEq)]
pub enum Stmt<'a> {
    // `  call void asm sideeffect "cpsid i"`
    Asm(&'a str),

    BitcastCall(&'a str),

    DirectCall(&'a str),

    IndirectCall(FnSig<'a>),

    Comment,

    // `start:`
    Label,

    Other,
}

#[derive(Clone, Debug, PartialEq)]
struct Parameter<'a>(Type<'a>);

named!(parameter<CompleteStr, Parameter>, do_parse!(
    ty: call!(super::type_) >>
        many0!(do_parse!(space >> call!(super::attribute) >> (()))) >>
        opt!(do_parse!(space >> call!(super::alias) >> (()))) >>
        (Parameter(ty))
));

named!(pub parse<CompleteStr, Define>, do_parse!(
    tag!("define") >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        output: alt!(map!(call!(super::type_), Some) | map!(tag!("void"), |_| None)) >> space >>
        name: call!(super::function) >>
    // parameter list
        char!('(') >>
        inputs: separated_list!(
            do_parse!(char!(',') >> space >> (())),
            map!(parameter, |p| p.0)
        ) >> char!(')') >>
    // TODO we likely want to parse the metadata (`!dbg !0`) that comes after the parameter list
        not_line_ending >> line_ending >>
        stmts: separated_nonempty_list!(many1!(line_ending), call!(super::define::stmt)) >>
        opt!(line_ending) >> tag!("}") >>
        (Define { name: name.0, stmts, sig: FnSig { inputs, output: output.map(Box::new) } })
));

named!(label<CompleteStr, Stmt>, do_parse!(
    alt!(map!(super::ident, drop) | map!(super::string, drop)) >>
        char!(':') >>
        opt!(do_parse!(space >> call!(super::comment) >> ())) >>
        (Stmt::Label)
));

named!(comment<CompleteStr, Stmt>, do_parse!(
    call!(super::comment) >>
        (Stmt::Comment)
));

named!(asm<CompleteStr, Stmt>, do_parse!(
    opt!(do_parse!(tag!("tail") >> space >> (()))) >>
        tag!("call") >> space >>
        alt!(map!(call!(super::type_), drop) | map!(tag!("void"), drop)) >> space >>
        tag!("asm") >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        asm: call!(super::string) >>
    // NOTE shortcut
        not_line_ending >>
        (Stmt::Asm(asm.0))
));

#[derive(Clone, Debug, PartialEq)]
struct Argument<'a>(Type<'a>);

named!(argument<CompleteStr, Argument>, do_parse!(
    ty: call!(super::type_) >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        alt!(
            map!(call!(super::bitcast), drop) |
            map!(call!(super::getelementptr), drop) |
            do_parse!(opt!(char!('%')) >> digit >> (()))) >>
        (Argument(ty))
));

named!(bitcast_call<CompleteStr, Stmt>, do_parse!(
    opt!(do_parse!(tag!("tail") >> space >> (()))) >>
        // XXX can this be `invoke`?
        tag!("call") >> space >>
        // not seen in practice (yet?)
        // many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        alt!(map!(call!(super::type_), drop) | map!(tag!("void"), drop)) >> space >>
        name: call!(super::bitcast) >>
    // NOTE shortcut
        not_line_ending >>
        (Stmt::BitcastCall(name.0))
));

named!(direct_call<CompleteStr, Stmt>, do_parse!(
    opt!(do_parse!(tag!("tail") >> space >> (()))) >>
        alt!(tag!("call") | tag!("invoke")) >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        alt!(map!(call!(super::type_), drop) | map!(tag!("void"), drop)) >> space >>
        name: call!(super::function) >>
    // TODO we likely want to parse the metadata (`!dbg !0`) that comes after the argument list
    // NOTE shortcut
        char!('(') >> not_line_ending >>
        (Stmt::DirectCall(name.0))
));

named!(indirect_call<CompleteStr, Stmt>, do_parse!(
    opt!(do_parse!(tag!("tail") >> space >> (()))) >>
        alt!(tag!("call") | tag!("invoke")) >> space >>
        many0!(do_parse!(call!(super::attribute) >> space >> (()))) >>
        output: alt!(map!(call!(super::type_), Some) | map!(tag!("void"), |_| None)) >> space >>
        char!('%') >> digit >>
        inputs: delimited!(
            char!('('),
            separated_list!(
                do_parse!(char!(',') >> space >> (())),
                map!(argument, |arg| arg.0)
            ),
            char!(')')
        ) >>
    // TODO we likely want to parse the metadata (`!dbg !0`) that comes after the argument list
    // NOTE shortcut
        not_line_ending >>
        (Stmt::IndirectCall(FnSig { inputs, output: output.map(Box::new) }))
));

named!(other<CompleteStr, Stmt>, do_parse!(
    separated_nonempty_list!(
        space,
        map_res!(is_not!(" \t\r\n"), |t: CompleteStr| if t.0 == "call" { Err(()) } else { Ok(()) })
    ) >>
        (Stmt::Other)
));

// NOTE we discard the LHS of assignments
named!(assign<CompleteStr, Stmt>, do_parse!(
    char!('%') >> digit >> space >> char!('=') >> space >>
        rhs: alt!(asm | bitcast_call | direct_call | indirect_call | other) >>
        (rhs)
));

named!(pub stmt<CompleteStr, Stmt>, alt!(
    label |
    comment |
    do_parse!(
        space >>
            stmt: alt!(assign | asm | bitcast_call | direct_call | indirect_call | other) >>
            (stmt)
    )
));

#[cfg(test)]
mod tests {
    use nom::types::CompleteStr as S;

    use super::{Argument, Define, Parameter};
    use crate::ir::{FnSig, Stmt, Type};

    #[test]
    fn argument() {
        assert_eq!(
            super::argument(S(r#"{}* nonnull align 1 %3"#)),
            Ok((
                S(""),
                Argument(Type::Pointer(Box::new(Type::Struct(vec![]))))
            ))
        );

        assert_eq!(
            super::argument(S(r#"[0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [11 x i8] }>* @anon.f060a8fe91113516c6f72b45ea256765.59 to [0 x i8]*)"#)),
            Ok((
                S(""),
                Argument(Type::Pointer(Box::new(Type::Array(0, Box::new(Type::Integer(8))))))
            ))
        );

        assert_eq!(
            super::argument(S(r#"%"core::result::Result<(), io::error::Error>"* noalias nocapture nonnull sret dereferenceable(16) %26"#)),
            Ok((
                S(""),
                Argument(Type::Pointer(Box::new(Type::Alias("core::result::Result<(), io::error::Error>"))))
            ))
        );

        assert_eq!(
            super::argument(S(r#"{}* nonnull align 1 %723"#)),
            Ok((
                S(""),
                Argument(Type::Pointer(Box::new(Type::Struct(vec![]))))
            ))
        );

        assert_eq!(
            super::argument(S(r#"[0 x i8]* noalias nonnull readonly align 1 getelementptr inbounds (<{ [0 x i8] }>, <{ [0 x i8] }>* @anon.3751ff68b49c735a867036886cf6a576.71, i32 0, i32 0)"#)),
            Ok((
                S(""),
                Argument(Type::Pointer(Box::new(Type::Array(0, Box::new(Type::Integer(8))))))
            ))
        );
    }

    #[test]
    fn asm() {
        assert_eq!(
            super::asm(S(
                r#"call void asm sideeffect "cpsie i", "~{memory}"() #7, !dbg !5578, !srcloc !5475"#
            )),
            Ok((S(""), Stmt::Asm("cpsie i")))
        );

        assert_eq!(
            super::asm(S(
                r#"tail call i32 asm sideeffect "mrs $0, BASEPRI", "=r"() #5, !dbg !1270, !srcloc !1280"#
            )),
            Ok((S(""), Stmt::Asm("mrs $0, BASEPRI")))
        );
    }

    #[test]
    fn assign() {
        assert_eq!(
            super::assign(S(r#"%0 = tail call nonnull i32 (i32)* @foo(), !dbg !1200"#)),
            Ok((S(""), Stmt::DirectCall("foo")))
        );
    }

    #[test]
    fn bitcast_call() {
        assert_eq!(
            super::bitcast_call(S(
                r#"tail call i32 bitcast (i8* @__sbss to i32 ()*)() #6, !dbg !1177"#
            )),
            Ok((S(""), Stmt::BitcastCall("__sbss")))
        );
    }

    #[test]
    fn direct_call() {
        assert_eq!(
            super::direct_call(S(
                r#"call void @llvm.dbg.value(metadata %"blue_pill::ItmLogger"* %0, metadata !2111, metadata !DIExpression()), !dbg !2115"#
            )),
            Ok((S(""), Stmt::DirectCall("llvm.dbg.value")))
        );

        assert_eq!(
            super::direct_call(S(r#"tail call nonnull i32 (i32)* @foo(), !dbg !1200"#)),
            Ok((S(""), Stmt::DirectCall("foo")))
        );
    }

    #[test]
    fn indirect_call() {
        assert_eq!(
            super::indirect_call(S(r#"tail call i32 %0(i32 0) #8, !dbg !1200"#)),
            Ok((
                S(""),
                Stmt::IndirectCall(FnSig {
                    inputs: vec![Type::Integer(32)],
                    output: Some(Box::new(Type::Integer(32)))
                })
            ))
        );

        assert_eq!(
            super::indirect_call(S(r#"call zeroext i1 %8({}* nonnull align 1 %3, [0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [11 x i8] }>* @anon.f060a8fe91113516c6f72b45ea256765.59 to [0 x i8]*), i64 11), !dbg !4725, !noalias !4742"#)),
            Ok((
                S(""),
                Stmt::IndirectCall(FnSig {
                    inputs: vec![
                        Type::Pointer(Box::new(Type::Struct(vec![]))),
                        Type::Pointer(Box::new(Type::Array(0, Box::new(Type::Integer(8))))),
                        Type::Integer(64),
                    ],
                    output: Some(Box::new(Type::Integer(1)))
                })
            ))
        );
    }

    #[test]
    fn label() {
        assert_eq!(
            super::label(S(
                r#""_ZN36_$LT$jnet..ether..Frame$LT$B$GT$$GT$11payload_mut17hc31fdc79b700f841E.exit.i.i": ; preds = %bb3.i96.i"#
            )),
            Ok((S(""), Stmt::Label))
        );

        assert_eq!(
            super::label(S(
                r#"bb3.i96.i:                                        ; preds = %bb37.i"#
            )),
            Ok((S(""), Stmt::Label))
        );
    }

    #[test]
    fn other() {
        assert_eq!(
            super::other(S("ret void, !dbg !1377")),
            Ok((S(""), Stmt::Other))
        );
    }

    #[test]
    fn parameter() {
        assert_eq!(
            super::parameter(S(
                r#"%"enc28j60::Enc28j60<stm32f103xx_hal::spi::Spi<stm32f103xx::SPI1, (stm32f103xx_hal::gpio::gpioa::PA5<stm32f103xx_hal::gpio::Alternate<stm32f103xx_hal::gpio::PushPull>>, stm32f103xx_hal::gpio::gpioa::PA6<stm32f103xx_hal::gpio::Input<stm32f103xx_hal::gpio::Floating>>, stm32f103xx_hal::gpio::gpioa::PA7<stm32f103xx_hal::gpio::Alternate<stm32f103xx_hal::gpio::PushPull>>)>, stm32f103xx_hal::gpio::gpioa::PA4<stm32f103xx_hal::gpio::Output<stm32f103xx_hal::gpio::PushPull>>, enc28j60::Unconnected, stm32f103xx_hal::gpio::gpioa::PA3<stm32f103xx_hal::gpio::Output<stm32f103xx_hal::gpio::PushPull>>>"* nocapture align 2 dereferenceable(6)"#
            )),
            Ok((S(""), Parameter(Type::Pointer(Box::new(Type::Alias("enc28j60::Enc28j60<stm32f103xx_hal::spi::Spi<stm32f103xx::SPI1, (stm32f103xx_hal::gpio::gpioa::PA5<stm32f103xx_hal::gpio::Alternate<stm32f103xx_hal::gpio::PushPull>>, stm32f103xx_hal::gpio::gpioa::PA6<stm32f103xx_hal::gpio::Input<stm32f103xx_hal::gpio::Floating>>, stm32f103xx_hal::gpio::gpioa::PA7<stm32f103xx_hal::gpio::Alternate<stm32f103xx_hal::gpio::PushPull>>)>, stm32f103xx_hal::gpio::gpioa::PA4<stm32f103xx_hal::gpio::Output<stm32f103xx_hal::gpio::PushPull>>, enc28j60::Unconnected, stm32f103xx_hal::gpio::gpioa::PA3<stm32f103xx_hal::gpio::Output<stm32f103xx_hal::gpio::PushPull>>>"))))))
        );

        assert_eq!(
            super::parameter(S(
                r#"%"jnet::mac::Addr"* noalias nocapture readonly dereferenceable(6) %value"#
            )),
            Ok((
                S(""),
                Parameter(Type::Pointer(Box::new(Type::Alias("jnet::mac::Addr"))))
            ))
        );
    }

    #[test]
    fn parse() {
        assert_eq!(
            super::parse(S(
                r#"define internal void @_ZN4core3ptr18real_drop_in_place17h10d0d6d6b26fb8afE(%"blue_pill::ItmLogger"* nocapture nonnull align 1) unnamed_addr #0 !dbg !2105 {
start:
  ret void
}"#
            )),
            Ok(
                (S(""),
                 Define {
                     name: "_ZN4core3ptr18real_drop_in_place17h10d0d6d6b26fb8afE",
                     stmts: vec![Stmt::Label, Stmt::Other],
                     sig: FnSig {
                         inputs: vec![Type::Pointer(Box::new(Type::Alias("blue_pill::ItmLogger")))],
                         output: None,
                     },
                 }))
        );

        assert_eq!(
            super::parse(S(
                r#"define internal fastcc void @_ZN3std10sys_common12thread_local22register_dtor_fallback17h254497a6d25774eeE(i8*, void (i8*)* nonnull) unnamed_addr #0 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality !dbg !5158 {
start:
  ret void
}"#
            )),
            Ok(
                (S(""),
                 Define {
                     name: "_ZN3std10sys_common12thread_local22register_dtor_fallback17h254497a6d25774eeE",
                     stmts: vec![Stmt::Label, Stmt::Other],
                     sig: FnSig {
                         inputs: vec![
                             Type::Pointer(Box::new(Type::Integer(8))),
                             Type::Pointer(Box::new(Type::Fn(FnSig {
                                 inputs: vec![Type::Pointer(Box::new(Type::Integer(8)))],
                                 output: None,
                             }))),
                         ],
                         output: None,
                     },
                 }))
        );

        assert_eq!(
            super::parse(S(
                r#"define internal fastcc void @_ZN3std9panicking20rust_panic_with_hook17hac9cf78024704ab4E({}* nonnull align 1, [3 x i64]* noalias readonly align 8 dereferenceable(24), i64* noalias readonly align 8 dereferenceable_or_null(48), { [0 x i64], { [0 x i8]*, i64 }, [0 x i32], i32, [0 x i32], i32, [0 x i32] }* noalias nocapture readonly align 8 dereferenceable(24)) unnamed_addr #10 personality i32 (i32, i32, i64, %"unwind::libunwind::_Unwind_Exception"*, %"unwind::libunwind::_Unwind_Context"*)* @rust_eh_personality !dbg !6634 {
start:
  ret void
}"#
            )),
            Ok(
                (S(""),
                 Define {
                     name: "_ZN3std9panicking20rust_panic_with_hook17hac9cf78024704ab4E",
                     stmts: vec![Stmt::Label, Stmt::Other],
                     sig: FnSig {
                         inputs: vec![
                             Type::Pointer(Box::new(Type::Struct(vec![]))),
                             Type::Pointer(Box::new(Type::Array(3, Box::new(Type::Integer(64))))),
                             Type::Pointer(Box::new(Type::Integer(64))),
                             Type::Pointer(Box::new(Type::Struct(vec![
                                 Type::Array(0, Box::new(Type::Integer(64))),
                                 Type::Struct(vec![
                                     Type::Pointer(Box::new(Type::Array(0, Box::new(Type::Integer(8))))),
                                     Type::Integer(64),
                                 ]),
                                 Type::Array(0, Box::new(Type::Integer(32))),
                                 Type::Integer(32),
                                 Type::Array(0, Box::new(Type::Integer(32))),
                                 Type::Integer(32),
                                 Type::Array(0, Box::new(Type::Integer(32))),
                             ]))),
                         ],
                         output: None,
                     },
                 }))
        );

        assert_eq!(
            super::parse(S(
                r#"define noalias void ()** @foo() unnamed_addr #0 !dbg !1272 {
start:
  ret void ()** null, !dbg !1278
}"#
            )),
            Ok((
                S(""),
                Define {
                    name: "foo",
                    stmts: vec![Stmt::Label, Stmt::Other],
                    sig: FnSig {
                        inputs: vec![],
                        output: Some(Box::new(Type::Pointer(Box::new(Type::Pointer(Box::new(
                            Type::Fn(FnSig {
                                inputs: vec![],
                                output: None,
                            })
                        )))))),
                    },
                }
            ))
        );
    }

}

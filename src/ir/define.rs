use nom::{
    branch::alt,
    bytes::complete::{is_not, tag},
    character::complete::{char, digit1, line_ending, not_line_ending, space1},
    combinator::{map, map_res, opt},
    multi::{many0, many1, separated_list, separated_nonempty_list},
    sequence::delimited,
    IResult,
};

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

    BitcastCall(Option<&'a str>),

    DirectCall(&'a str),

    IndirectCall(FnSig<'a>),

    Comment,

    // `start:`
    Label,

    Other,
}

#[derive(Clone, Debug, PartialEq)]
struct Parameter<'a>(Type<'a>);

fn parameter(i: &str) -> IResult<&str, Parameter> {
    let (i, ty) = super::type_(i)?;
    let i = many0(|i| {
        let i = space1(i)?.0;
        super::attribute(i)
    })(i)?
    .0;
    let i = opt(|i| {
        let i = space1(i)?.0;
        super::alias(i)
    })(i)?
    .0;
    let i = opt(|i| {
        let i = space1(i)?.0;
        super::local(i)
    })(i)?
    .0;
    Ok((i, Parameter(ty)))
}

pub fn parse(i: &str) -> IResult<&str, Define> {
    let i = tag("define")(i)?.0;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let (i, output) = alt((map(super::type_, Some), map(tag("void"), |_| None)))(i)?;
    let i = space1(i)?.0;
    let (i, name) = super::function(i)?;

    // parameter list
    let i = char('(')(i)?.0;
    let (i, inputs) = separated_list(
        |i| {
            let i = char(',')(i)?.0;
            space1(i)
        },
        map(parameter, |p| p.0),
    )(i)?;
    let i = char(')')(i)?.0;

    // TODO we likely want to parse the metadata (`!dbg !0`) that comes after the parameter list
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    let i = line_ending(i)?.0;
    let (i, stmts) = separated_nonempty_list(many1(line_ending), super::define::stmt)(i)?;
    let i = opt(line_ending)(i)?.0;
    let i = tag("}")(i)?.0;
    Ok((
        i,
        Define {
            name: name.0,
            stmts,
            sig: FnSig {
                inputs,
                output: output.map(Box::new),
            },
        },
    ))
}

fn label(i: &str) -> IResult<&str, Stmt> {
    let i = alt((
        map(super::ident, drop),
        map(super::string, drop),
        map(digit1, drop),
    ))(i)?
    .0;
    let i = char(':')(i)?.0;
    let i = opt(|i| {
        let i = space1(i)?.0;
        super::comment(i)
    })(i)?
    .0;
    Ok((i, Stmt::Label))
}

fn comment(i: &str) -> IResult<&str, Stmt> {
    let i = super::comment(i)?.0;
    Ok((i, Stmt::Comment))
}

fn asm(i: &str) -> IResult<&str, Stmt> {
    let i = opt(|i| {
        let i = tag("tail")(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = tag("call")(i)?.0;
    let i = space1(i)?.0;
    let i = alt((map(super::type_, drop), map(tag("void"), drop)))(i)?.0;
    let i = space1(i)?.0;
    let i = tag("asm")(i)?.0;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::ident(i)?.0;
        space1(i)
    })(i)?
    .0;
    let (i, s) = super::string(i)?;
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Stmt::Asm(s.0)))
}

#[derive(Clone, Debug, PartialEq)]
struct Argument<'a>(Type<'a>);

fn argument(i: &str) -> IResult<&str, Argument> {
    let (i, ty) = super::type_(i)?;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = alt((
        map(super::bitcast, drop),
        map(super::getelementptr, drop),
        map(super::local, drop),
        map(super::function, drop),
        map(digit1, drop),
    ))(i)?
    .0;
    Ok((i, Argument(ty)))
}

fn bitcast_call(i: &str) -> IResult<&str, Stmt> {
    let i = opt(|i| {
        let i = tag("tail")(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = tag("call")(i)?.0;
    let i = space1(i)?.0;

    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;

    let i = alt((map(super::type_, drop), map(tag("void"), drop)))(i)?.0;
    let i = space1(i)?.0;
    let (i, name) = super::bitcast(i)?;

    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Stmt::BitcastCall(name.0)))
}

fn direct_call(i: &str) -> IResult<&str, Stmt> {
    let i = opt(|i| {
        let i = tag("tail")(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = alt((tag("call"), tag("invoke")))(i)?.0;
    let i = space1(i)?.0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = alt((map(super::type_, drop), map(tag("void"), drop)))(i)?.0;
    let i = space1(i)?.0;
    let (i, name) = super::function(i)?;
    let i = char('(')(i)?.0;
    // TODO we likely want to parse the metadata (`!dbg !0`) that comes after the argument list
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((i, Stmt::DirectCall(name.0)))
}

fn indirect_call(i: &str) -> IResult<&str, Stmt> {
    let i = opt(|i| {
        let i = tag("tail")(i)?.0;
        space1(i)
    })(i)?
    .0;
    let i = many0(|i| {
        let i = super::attribute(i)?.0;
        space1(i)
    })(i)?
    .0;
    let (i, output) = alt((map(super::type_, Some), map(tag("void"), |_| None)))(i)?;
    let i = space1(i)?.0;
    let i = super::local(i)?.0;
    let (i, inputs) = delimited(
        char('('),
        separated_list(
            |i| {
                let i = char(',')(i)?.0;
                space1(i)
            },
            map(argument, |a| a.0),
        ),
        char(')'),
    )(i)?;
    // TODO we likely want to parse the metadata (`!dbg !0`) that comes after the argument list
    // NOTE shortcut
    let i = not_line_ending(i)?.0;
    Ok((
        i,
        Stmt::IndirectCall(FnSig {
            inputs,
            output: output.map(Box::new),
        }),
    ))
}

fn other(i: &str) -> IResult<&str, Stmt> {
    let i = separated_nonempty_list(
        space1,
        map_res(is_not(" \t\r\n"), |i| {
            if i == "call" {
                Err(())
            } else {
                Ok(())
            }
        }),
    )(i)?
    .0;
    Ok((i, Stmt::Other))
}

// NOTE we discard the LHS of assignments
fn assign(i: &str) -> IResult<&str, Stmt> {
    let i = super::local(i)?.0;
    let i = space1(i)?.0;
    let i = char('=')(i)?.0;
    let i = space1(i)?.0;
    alt((asm, bitcast_call, direct_call, indirect_call, other))(i)
}

fn stmt(i: &str) -> IResult<&str, Stmt> {
    alt((label, comment, |i| {
        let i = space1(i)?.0;
        alt((assign, asm, bitcast_call, direct_call, indirect_call, other))(i)
    }))(i)
}

#[cfg(test)]
mod tests {
    use super::{Argument, Define, Parameter};
    use crate::ir::{FnSig, Stmt, Type};

    #[test]
    fn argument() {
        assert_eq!(
            super::argument(r#"{}* nonnull align 1 %3"#),
            Ok(("", Argument(Type::Pointer(Box::new(Type::Struct(vec![]))))))
        );

        assert_eq!(
            super::argument(
                r#"[0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [11 x i8] }>* @anon.f060a8fe91113516c6f72b45ea256765.59 to [0 x i8]*)"#
            ),
            Ok((
                "",
                Argument(Type::Pointer(Box::new(Type::Array(
                    0,
                    Box::new(Type::Integer(8))
                ))))
            ))
        );

        // not seen in practice in a while; `sret(%"SomeType")` does appear in practice
        // assert_eq!(
        //     super::argument(
        //         r#"%"core::result::Result<(), io::error::Error>"* noalias nocapture nonnull sret dereferenceable(16) %26"#
        //     ),
        //     Ok((
        //         "",
        //         Argument(Type::Pointer(Box::new(Type::Alias(
        //             "core::result::Result<(), io::error::Error>"
        //         ))))
        //     ))
        // );

        assert_eq!(
            super::argument(r#"{}* nonnull align 1 %723"#),
            Ok(("", Argument(Type::Pointer(Box::new(Type::Struct(vec![]))))))
        );

        assert_eq!(
            super::argument(
                r#"[0 x i8]* noalias nonnull readonly align 1 getelementptr inbounds (<{ [0 x i8] }>, <{ [0 x i8] }>* @anon.3751ff68b49c735a867036886cf6a576.71, i32 0, i32 0)"#
            ),
            Ok((
                "",
                Argument(Type::Pointer(Box::new(Type::Array(
                    0,
                    Box::new(Type::Integer(8))
                ))))
            ))
        );
    }

    #[test]
    fn asm() {
        assert_eq!(
            super::asm(
                r#"call void asm sideeffect "cpsie i", "~{memory}"() #7, !dbg !5578, !srcloc !5475"#
            ),
            Ok(("", Stmt::Asm("cpsie i")))
        );

        assert_eq!(
            super::asm(
                r#"tail call i32 asm sideeffect "mrs $0, BASEPRI", "=r"() #5, !dbg !1270, !srcloc !1280"#
            ),
            Ok(("", Stmt::Asm("mrs $0, BASEPRI")))
        );
    }

    #[test]
    fn assign() {
        assert_eq!(
            super::assign(r#"%0 = tail call nonnull i32 (i32)* @foo(), !dbg !1200"#),
            Ok(("", Stmt::DirectCall("foo")))
        );

        assert_eq!(
            super::assign(
                r#"%113 = call zeroext i1 %112({}* nonnull align 1 %109, [0 x i8]* noalias nonnull readonly align 1 %., i32 %.9) #10, !dbg !30714, !noalias !30727"#
            ),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![
                        Type::Pointer(Box::new(Type::Struct(vec![]))),
                        Type::Pointer(Box::new(Type::Array(0, Box::new(Type::Integer(8))))),
                        Type::Integer(32),
                    ],
                    output: Some(Box::new(Type::Integer(1))),
                })
            ))
        );

        assert_eq!(
            super::assign(
                r#"%_0.sroa.0.0.insert.insert.i.i39 = tail call i32 @llvm.bswap.i32(i32 %page.0.i38) #9"#
            ),
            Ok(("", Stmt::DirectCall("llvm.bswap.i32")))
        );
    }

    #[test]
    fn bitcast_call() {
        assert_eq!(
            super::bitcast_call(
                r#"tail call fastcc i32 bitcast (i8* @__sbss to i32 ()*)() #6, !dbg !1177"#
            ),
            Ok(("", Stmt::BitcastCall(Some("__sbss"))))
        );
    }

    #[test]
    fn direct_call() {
        assert_eq!(
            super::direct_call(
                r#"call void @llvm.dbg.value(metadata %"blue_pill::ItmLogger"* %0, metadata !2111, metadata !DIExpression()), !dbg !2115"#
            ),
            Ok(("", Stmt::DirectCall("llvm.dbg.value")))
        );

        assert_eq!(
            super::direct_call(r#"tail call nonnull i32 (i32)* @foo(), !dbg !1200"#),
            Ok(("", Stmt::DirectCall("foo")))
        );

        assert_eq!(
            super::direct_call(r#"tail call i32 @llvm.bswap.i32(i32 %page.0.i) #9"#),
            Ok(("", Stmt::DirectCall("llvm.bswap.i32")))
        );

        assert_eq!(
            super::direct_call(
                r#"call i32 (i32, i64, ...) @ioctl(i32 %175, i64 1074295912, i64* nonnull %152) #10, !noalias !5657"#
            ),
            Ok(("", Stmt::DirectCall("ioctl")))
        );

        assert_eq!(
            super::direct_call(r#"call <4 x i32> @llvm.bswap.v4i32(<4 x i32> %2481)"#),
            Ok(("", Stmt::DirectCall("llvm.bswap.v4i32")))
        );
    }

    #[test]
    fn indirect_call() {
        assert_eq!(
            super::indirect_call(r#"tail call i32 %0(i32 0) #8, !dbg !1200"#),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![Type::Integer(32)],
                    output: Some(Box::new(Type::Integer(32)))
                })
            ))
        );

        assert_eq!(
            super::indirect_call(
                r#"call zeroext i1 %8({}* nonnull align 1 %3, [0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [11 x i8] }>* @anon.f060a8fe91113516c6f72b45ea256765.59 to [0 x i8]*), i64 11), !dbg !4725, !noalias !4742"#
            ),
            Ok((
                "",
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

        assert_eq!(
            super::indirect_call(
                r#"call zeroext i1 %98({}* nonnull align 1 %93, [0 x i8]* noalias nonnull readonly align 1 bitcast (<{ [10 x i8] }>* @1 to [0 x i8]*), i32 10) #10, !dbg !5301"#
            ),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![
                        Type::Pointer(Box::new(Type::Struct(vec![]))),
                        Type::Pointer(Box::new(Type::Array(0, Box::new(Type::Integer(8))))),
                        Type::Integer(32),
                    ],
                    output: Some(Box::new(Type::Integer(1)))
                })
            ))
        );

        assert_eq!(
            super::indirect_call("call zeroext i1 %_8() #7, !dbg !1250"),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![],
                    output: Some(Box::new(Type::Integer(1))),
                })
            ))
        );

        assert_eq!(
            super::indirect_call("tail call i32 %_23.i(i8 %f.1)"),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![Type::Integer(8)],
                    output: Some(Box::new(Type::Integer(32))),
                })
            ))
        );

        assert_eq!(
            super::indirect_call("call void %125({}* nonnull align 1 %_17.0.i.i.i.i.i, i32* nonnull align 4 dereferenceable(180) bitcast (i8* getelementptr inbounds (<{ [228 x i8] }>, <{ [228 x i8] }>* @_ZN17at28c_rs_firmware3APP7usb_dev17h0475a05cee83d665E, i32 0, i32 0, i32 44) to i32*), i16* noalias nonnull readonly align 2 dereferenceable(10) %121) #13, !dbg !14831, !noalias !13140"),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![
                        Type::Pointer(Box::new(Type::Struct(vec![]))), Type::Pointer(Box::new(Type::Integer(32))), Type::Pointer(Box::new(Type::Integer(16)))
                    ],
                    output: None,
                })
            ))
        );
    }

    #[test]
    fn call_gh58() {
        assert_eq!(
            super::indirect_call("tail call void %f()"),
            Ok((
                "",
                Stmt::IndirectCall(FnSig {
                    inputs: vec![],
                    output: None,
                })
            ))
        );
    }

    #[test]
    fn label() {
        assert_eq!(
            super::label(r#""payload_mut.exit.i.i": ; preds = %bb3.i96.i"#),
            Ok(("", Stmt::Label))
        );

        assert_eq!(
            super::label(r#"bb3.i96.i: ; preds = %bb37.i"#),
            Ok(("", Stmt::Label))
        );
    }

    #[test]
    fn other() {
        assert_eq!(super::other("ret void, !dbg !1377"), Ok(("", Stmt::Other)));
    }

    #[test]
    fn parameter() {
        assert_eq!(
            super::parameter(r#"%"Enc28j60<Spi<SPI1, (PA5<Alternate<PushPull>>, PA6<Input<Floating>>, PA7<Alternate<PushPull>>)>, PA4<Output<PushPull>>, Unconnected, PA3<Output<PushPull>>>"* nocapture align 2 dereferenceable(6)"#),
            Ok(("", Parameter(Type::Pointer(Box::new(Type::Alias("Enc28j60<Spi<SPI1, (PA5<Alternate<PushPull>>, PA6<Input<Floating>>, PA7<Alternate<PushPull>>)>, PA4<Output<PushPull>>, Unconnected, PA3<Output<PushPull>>>"))))))
        );

        assert_eq!(
            super::parameter(
                r#"%"jnet::mac::Addr"* noalias nocapture readonly dereferenceable(6) %value"#
            ),
            Ok((
                "",
                Parameter(Type::Pointer(Box::new(Type::Alias("jnet::mac::Addr"))))
            ))
        );

        assert_eq!(
            super::parameter(r#"float"#),
            Ok(("", Parameter(Type::Float)))
        );

        assert_eq!(
            super::parameter(
                r#"%ExceptionFrame* noalias nocapture readonly align 4 dereferenceable(32) %0"#
            ),
            Ok((
                "",
                Parameter(Type::Pointer(Box::new(Type::Alias("ExceptionFrame"))))
            ))
        );
    }

    #[test]
    fn parse() {
        assert_eq!(
            super::parse(include_str!("define/parse1.ll")),
            Ok((
                "",
                Define {
                    name: "_ZN4core3ptr18real_drop_in_place17h10d0d6d6b26fb8afE",
                    stmts: vec![Stmt::Label, Stmt::Other],
                    sig: FnSig {
                        inputs: vec![Type::Pointer(Box::new(Type::Alias("blue_pill::ItmLogger")))],
                        output: None,
                    },
                }
            ))
        );

        let name = "_ZN3std10sys_common12thread_local22register_dtor_fallback17h254497a6d25774eeE";
        assert_eq!(
            super::parse(include_str!("define/parse2.ll")),
            Ok((
                "",
                Define {
                    name,
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
                }
            ))
        );

        assert_eq!(
            super::parse(include_str!("define/parse3.ll")),
            Ok((
                "",
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
                                    Type::Pointer(Box::new(Type::Array(
                                        0,
                                        Box::new(Type::Integer(8))
                                    ))),
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
                }
            ))
        );

        assert_eq!(
            super::parse(include_str!("define/parse4.ll")),
            Ok((
                "",
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

        assert_eq!(
            super::parse(include_str!("define/parse5.ll")),
            Ok((
                "",
                Define {
                    name: "_ZN3app3foo17h3337355bfdc88d96E",
                    stmts: vec![
                        Stmt::Label,
                        Stmt::DirectCall("llvm.dbg.value"),
                        Stmt::Other,
                        Stmt::Other,
                    ],
                    sig: FnSig {
                        inputs: vec![Type::Float],
                        output: Some(Box::new(Type::Float)),
                    },
                }
            ))
        );

        assert_eq!(
            super::parse(include_str!("define/parse6.ll").trim()),
            Ok((
                "",
                Define {
                    name: "_defmt_acquire",
                    stmts: vec![Stmt::Other],
                    sig: FnSig {
                        inputs: vec![Type::Pointer(Box::new(Type::Alias(
                            "core::option::Option<defmt::InternalFormatter>"
                        )))],
                        output: None,
                    },
                }
            ))
        );

        assert_eq!(
            super::parse(include_str!("define/parse7.ll").trim()),
            Ok((
                "",
                Define {
                    name: "__aeabi_uidivmod",
                    stmts: vec![Stmt::Label, Stmt::Asm("push {lr}"), Stmt::Other],
                    sig: FnSig {
                        inputs: vec![],
                        output: None,
                    },
                }
            ))
        );
    }
}

define internal fastcc float @_ZN3app3foo17h3337355bfdc88d96E(float) unnamed_addr #0 !dbg !1183 {
start:
  call void @llvm.dbg.value(metadata float %0, metadata !1187, metadata !DIExpression()), !dbg !1188
  %1 = fmul float %0, 0x3FF19999A0000000, !dbg !1189
  ret float %1, !dbg !1190
}
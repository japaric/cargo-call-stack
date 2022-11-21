define internal noundef zeroext i1 @_ZN21example_crate9mod_19ExampleStruct13example_method17he93ae98acbb4840aE() unnamed_addr #7 !dbg !104889 {
  %1 = load ptr, ptr @_ZN21example_crate9mod_122STATIC_217hf5dc7549df71c743E.0, align 4, !dbg !104902, !nonnull !28, !noundef !28
  tail call void %1(i32 noundef 0, i32 undef) #39, !dbg !104902
  call void @llvm.dbg.value(metadata ptr @_ZN21example_crate9mod_15STATIC_417hbf104ea2eff23a2cE, metadata !104891, metadata !DIExpression()), !dbg !104903
  call void @llvm.dbg.value(metadata ptr @_ZN21example_crate9mod_15STATIC_417hbf104ea2eff23a2cE, metadata !104893, metadata !DIExpression()), !dbg !104904
; call example_crate::mod_2::mod_3::ExampleStruct2::example_method
  %2 = tail call fastcc { i8, ptr } @_ZN21example_crate6mod_214mod_313ExampleStruct213example_method17hfb321e74ed0de54eE() #39, !dbg !104905
  %3 = extractvalue { i8, ptr } %2, 0, !dbg !104905
  %4 = extractvalue { i8, ptr } %2, 1, !dbg !104905
  call void @llvm.dbg.value(metadata i1 undef, metadata !104897, metadata !DIExpression(DW_OP_LLVM_convert, 1, DW_ATE_unsigned, DW_OP_LLVM_convert, 8, DW_ATE_unsigned, DW_OP_stack_value)), !dbg !104906
  call void @llvm.dbg.value(metadata ptr %4, metadata !104899, metadata !DIExpression()), !dbg !104906
  %5 = and i8 %3, 1, !dbg !104907
  %6 = icmp ne i8 %5, 0, !dbg !104907
  %7 = load ptr, ptr @_ZN21example_crate9mod_122STATIC_217hf5dc7549df71c743E.0, align 4, !dbg !104906, !nonnull !28
  %8 = load i32, ptr %4, align 4, !dbg !104906
  br i1 %6, label %10, label %9, !dbg !104907

9:                                                ; preds = %0
  tail call void %7(i32 noundef 2, i32 %8) #39, !dbg !104908
  call void @llvm.dbg.value(metadata i8 0, metadata !104900, metadata !DIExpression()), !dbg !104909
  br label %15, !dbg !104910

10:                                               ; preds = %0
  tail call void %7(i32 noundef 1, i32 %8) #39, !dbg !104911
  %11 = getelementptr inbounds %34, ptr %4, i32 0, i32 1, !dbg !104912
  call void @llvm.dbg.value(metadata ptr %11, metadata !104913, metadata !DIExpression()), !dbg !104916
  %12 = load ptr, ptr %11, align 4, !dbg !104917, !nonnull !28, !noundef !28
  call void @llvm.dbg.value(metadata ptr poison, metadata !104918, metadata !DIExpression()), !dbg !104925
  call void @llvm.dbg.value(metadata ptr %12, metadata !104924, metadata !DIExpression()), !dbg !104925
  call void @llvm.dbg.value(metadata !28, metadata !104927, metadata !DIExpression()), !dbg !104934
  call void @llvm.dbg.value(metadata ptr %12, metadata !104933, metadata !DIExpression()), !dbg !104934
  call void @llvm.dbg.value(metadata !28, metadata !104936, metadata !DIExpression()), !dbg !104946
  call void @llvm.dbg.value(metadata ptr %12, metadata !104941, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !104946
  call void @llvm.dbg.value(metadata i32 1, metadata !104941, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !104946
  call void @llvm.dbg.value(metadata !28, metadata !104948, metadata !DIExpression()), !dbg !104955
  call void @llvm.dbg.value(metadata i32 1, metadata !104954, metadata !DIExpression(DW_OP_LLVM_fragment, 0, 32)), !dbg !104955
  call void @llvm.dbg.value(metadata ptr %12, metadata !104954, metadata !DIExpression(DW_OP_LLVM_fragment, 32, 32)), !dbg !104955
  store i1 true, ptr @_ZN21example_crate10mod_49mod_514STATIC_317h3296c1e70243f1dfE.0, align 4, !dbg !104957
  store ptr %12, ptr @_ZN21example_crate10mod_49mod_514STATIC_317h3296c1e70243f1dfE.1, align 4, !dbg !104957, !noalias !104958
  %13 = getelementptr inbounds %164, ptr %12, i32 0, i32 1, !dbg !104961
  store ptr %13, ptr getelementptr inbounds (<{ [16 x i8] }>, ptr @_ZN21example_crate10mod_49mod_514STATIC_117h6df3a03feae3bb2aE, i32 0, i32 0, i32 4), align 4, !dbg !104962, !noalias !104958
  %14 = getelementptr inbounds %164, ptr %12, i32 0, i32 2, !dbg !104963
  store ptr %14, ptr getelementptr inbounds (<{ [16 x i8] }>, ptr @_ZN21example_crate10mod_49mod_514STATIC_117h6df3a03feae3bb2aE, i32 0, i32 0, i32 8), align 4, !dbg !104964, !noalias !104958
  call void @llvm.dbg.value(metadata i8 1, metadata !104900, metadata !DIExpression()), !dbg !104909
  br label %15, !dbg !104965

15:                                               ; preds = %10, %9
  call void @llvm.dbg.value(metadata i8 poison, metadata !104900, metadata !DIExpression()), !dbg !104909
  %16 = load ptr, ptr @_ZN21example_crate9mod_122STATIC_217hf5dc7549df71c743E.0, align 4, !dbg !104966, !nonnull !28, !noundef !28
  tail call void %16(i32 noundef 3, i32 undef) #39, !dbg !104966
  ret i1 %6, !dbg !104967
}

define internal fastcc void @_ZN4ring2io10der_writer22write_positive_integer17h2cbd2a5c98e3e635E(ptr noundef nonnull align 1 %0, ptr noalias nocapture noundef readonly align 8 dereferenceable(24) %1, ptr %.0.val, i64 %.8.val) unnamed_addr #1 personality ptr @rust_eh_personality {
  %3 = icmp eq i64 %.8.val, 0
  br i1 %3, label %4, label %_ZN4ring2io8positive8Positive10first_byte17h8adc827486783c8bE.exit, !prof !4429

4:                                                ; preds = %2
; call core::panicking::panic_bounds_check
  tail call fastcc void @_ZN4core9panicking18panic_bounds_check17h4183f129c0f2d665E(i64 0, i64 0, ptr noalias noundef nonnull readonly align 8 dereferenceable(24) @anon.d6133c3b30208f5fca04db122d621065.14) #79, !noalias !51502
  unreachable

_ZN4ring2io8positive8Positive10first_byte17h8adc827486783c8bE.exit: ; preds = %2
  %5 = icmp ne ptr %.0.val, null
  tail call void @llvm.assume(i1 %5)
  %6 = load i8, ptr %.0.val, align 1, !noalias !51502
  tail call void @llvm.experimental.noalias.scope.decl(metadata !51875)
  %7 = icmp sgt i8 %6, -1
  %not. = xor i1 %7, true
  %spec.select = zext i1 %not. to i64
  %8 = add i64 %spec.select, %.8.val
  %9 = getelementptr inbounds ptr, ptr %1, i64 3
  %10 = load ptr, ptr %9, align 8, !invariant.load !31, !alias.scope !51875, !nonnull !31
  tail call void %10(ptr noundef nonnull align 1 %0, i8 2), !noalias !51875
  %11 = icmp ult i64 %8, 128
  br i1 %11, label %16, label %12

12:                                               ; preds = %_ZN4ring2io8positive8Positive10first_byte17h8adc827486783c8bE.exit
  %13 = icmp ult i64 %8, 256
  br i1 %13, label %14, label %19

14:                                               ; preds = %22, %12
  %15 = phi i8 [ %24, %22 ], [ -127, %12 ]
  tail call void %10(ptr noundef nonnull align 1 %0, i8 %15), !noalias !51875
  br label %16

16:                                               ; preds = %14, %_ZN4ring2io8positive8Positive10first_byte17h8adc827486783c8bE.exit
  %17 = trunc i64 %8 to i8
  tail call void %10(ptr noundef nonnull align 1 %0, i8 %17), !noalias !51875
  br i1 %7, label %25, label %18

18:                                               ; preds = %16
  tail call void %10(ptr noundef nonnull align 1 %0, i8 0), !noalias !51878
  br label %25

19:                                               ; preds = %12
  %20 = icmp ult i64 %8, 65536
  br i1 %20, label %22, label %21

21:                                               ; preds = %19
; call core::panicking::panic
  tail call fastcc void @_ZN4core9panicking5panic17h994e41dd01ee4ae7E(ptr noalias noundef nonnull readonly align 1 @anon.c850c2dd380da8d8c417acd313921560.0, i64 40, ptr noalias noundef nonnull readonly align 8 dereferenceable(24) @anon.557936f52e6ffec790ffbbb74fc64e51.20) #79, !noalias !51875
  unreachable

22:                                               ; preds = %19
  tail call void %10(ptr noundef nonnull align 1 %0, i8 -126), !noalias !51875
  %23 = lshr i64 %8, 8
  %24 = trunc i64 %23 to i8
  br label %14

25:                                               ; preds = %18, %16
  tail call void @llvm.experimental.noalias.scope.decl(metadata !51881)
  %26 = getelementptr inbounds ptr, ptr %1, i64 4
  %27 = load ptr, ptr %26, align 8, !invariant.load !31, !alias.scope !51881, !noalias !51884, !nonnull !31
  tail call void %27(ptr noundef nonnull align 1 %0, ptr noalias noundef nonnull readonly align 1 %.0.val, i64 %.8.val), !noalias !51881
  ret void
}
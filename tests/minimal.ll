; ModuleID = 'minimal.h63efuwf-cgu.0'
source_filename = "minimal.h63efuwf-cgu.0"
target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7m-none-unknown-eabi"

%ExceptionFrame = type { [0 x i32], i32, [0 x i32], i32, [0 x i32], i32, [0 x i32], i32, [0 x i32], i32, [0 x i32], i32, [0 x i32], i32, [0 x i32], i32, [0 x i32] }

@"error: cortex-m-rt appears more than once in the dependency graph" = local_unnamed_addr constant <{ [0 x i8] }> zeroinitializer, align 1, !dbg !0
@__RESET_VECTOR = local_unnamed_addr constant <{ i8*, [0 x i8] }> <{ i8* bitcast (void ()* @Reset to i8*), [0 x i8] zeroinitializer }>, section ".vector_table.reset_vector", align 4, !dbg !5
@__sbss = external global i32
@__ebss = external global i32
@__sdata = external global i32
@__edata = external global i32
@__sidata = external local_unnamed_addr global i32
@__EXCEPTIONS = local_unnamed_addr constant <{ i8*, i8*, i8*, i8*, i8*, [16 x i8], i8*, i8*, [4 x i8], i8*, i8*, [0 x i8] }> <{ i8* bitcast (void ()* @NonMaskableInt to i8*), i8* bitcast (void ()* @HardFault to i8*), i8* bitcast (void ()* @MemoryManagement to i8*), i8* bitcast (void ()* @BusFault to i8*), i8* bitcast (void ()* @UsageFault to i8*), [16 x i8] zeroinitializer, i8* bitcast (void ()* @SVCall to i8*), i8* bitcast (void ()* @DebugMonitor to i8*), [4 x i8] zeroinitializer, i8* bitcast (void ()* @PendSV to i8*), i8* bitcast (void ()* @SysTick to i8*), [0 x i8] zeroinitializer }>, section ".vector_table.exceptions", align 4, !dbg !11
@__INTERRUPTS = local_unnamed_addr constant <{ i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, [0 x i8] }> <{ i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), i8* bitcast (void ()* @DefaultHandler to i8*), [0 x i8] zeroinitializer }>, section ".vector_table.interrupts", align 4, !dbg !25
@CORE_PERIPHERALS = local_unnamed_addr global <{ [1 x i8] }> zeroinitializer, align 1, !dbg !30

; Function Attrs: noreturn nounwind
define void @main() unnamed_addr #0 !dbg !956 {
start:
  tail call void @__nop() #1, !dbg !958
  br label %bb1, !dbg !964

bb1:                                              ; preds = %bb1, %start
  br label %bb1, !dbg !965
}

; Function Attrs: nounwind
declare void @__nop() unnamed_addr #1

; Function Attrs: noreturn nounwind
define void @Reset() unnamed_addr #0 !dbg !966 {
  tail call void @__pre_init(), !dbg !967
  call void @llvm.dbg.value(metadata i32* @__sbss, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* @__ebss, metadata !976, metadata !DIExpression()), !dbg !980
  br i1 icmp ult (i32* @__sbss, i32* @__ebss), label %1, label %.loopexit2, !dbg !982

; <label>:1:                                      ; preds = %0
  br i1 icmp ne (i32 and (i32 add (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), i32* @__ebss), i32* @__ebss, i32* getelementptr inbounds (i32, i32* @__sbss, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sbss to i32))) to i32), i32 2), i32 1), i32 3), i32 0), label %2, label %3, !dbg !983

; <label>:2:                                      ; preds = %1
  call void @llvm.dbg.value(metadata i32* @__sbss, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* @__sbss, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* @__sbss, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* @__sbss, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), metadata !968, metadata !DIExpression()), !dbg !980
  br i1 icmp ne (i32 sub (i32 and (i32 add (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), i32* @__ebss), i32* @__ebss, i32* getelementptr inbounds (i32, i32* @__sbss, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sbss to i32))) to i32), i32 2), i32 1), i32 3), i32 1), i32 0), label %90, label %3, !dbg !982

; <label>:3:                                      ; preds = %91, %90, %2, %1
  %4 = phi i32* [ @__sbss, %1 ], [ getelementptr inbounds (i32, i32* @__sbss, i32 1), %2 ], [ getelementptr (i32, i32* @__sbss, i32 2), %90 ], [ getelementptr (i32, i32* @__sbss, i32 3), %91 ]
  br i1 icmp ult (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), i32* @__ebss), i32* @__ebss, i32* getelementptr inbounds (i32, i32* @__sbss, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sbss to i32))) to i32), i32 2), i32 3), label %.loopexit2, label %.preheader1, !dbg !983

.preheader1:                                      ; preds = %3, %130
  %5 = phi i32* [ %134, %130 ], [ %4, %3 ]
  call void @llvm.dbg.value(metadata i32* %5, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %5, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %5, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %5, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %6 = getelementptr inbounds i32, i32* %5, i32 1, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %6, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %6, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %6, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %6, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %6, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %7 = getelementptr inbounds i32, i32* %5, i32 2, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %7, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %7, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %7, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %7, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %7, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %8 = getelementptr inbounds i32, i32* %5, i32 3, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %8, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %8, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %8, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %8, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %8, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %9 = getelementptr inbounds i32, i32* %5, i32 4, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %9, metadata !968, metadata !DIExpression()), !dbg !980
  %10 = icmp ult i32* %9, @__ebss, !dbg !1004
  br i1 %10, label %118, label %.loopexit2, !dbg !982

.loopexit2:                                       ; preds = %.preheader1, %118, %124, %130, %3, %0
  call void @llvm.dbg.value(metadata i32* @__sdata, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* @__edata, metadata !1011, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* @__sidata, metadata !1012, metadata !DIExpression()), !dbg !1013
  br i1 icmp ult (i32* @__sdata, i32* @__edata), label %11, label %.loopexit, !dbg !1015

; <label>:11:                                     ; preds = %.loopexit2
  br i1 icmp ne (i32 and (i32 add (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), i32* @__edata), i32* @__edata, i32* getelementptr inbounds (i32, i32* @__sdata, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sdata to i32))) to i32), i32 2), i32 1), i32 3), i32 0), label %12, label %14

; <label>:12:                                     ; preds = %11
  call void @llvm.dbg.value(metadata i32* @__sdata, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* @__sidata, metadata !1012, metadata !DIExpression()), !dbg !1013
  %13 = load i32, i32* @__sidata, align 4
  call void @llvm.dbg.value(metadata i32* @__sdata, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %13, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %13, i32* @__sdata, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* @__sdata, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32* @__sidata, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sidata, i32 1), metadata !1012, metadata !DIExpression()), !dbg !1013
  br i1 icmp ne (i32 sub (i32 and (i32 add (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), i32* @__edata), i32* @__edata, i32* getelementptr inbounds (i32, i32* @__sdata, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sdata to i32))) to i32), i32 2), i32 1), i32 3), i32 1), i32 0), label %86, label %14, !dbg !1015

; <label>:14:                                     ; preds = %88, %86, %12, %11
  %15 = phi i32* [ @__sdata, %11 ], [ getelementptr inbounds (i32, i32* @__sdata, i32 1), %12 ], [ getelementptr (i32, i32* @__sdata, i32 2), %86 ], [ getelementptr (i32, i32* @__sdata, i32 3), %88 ]
  %16 = phi i32* [ @__sidata, %11 ], [ getelementptr inbounds (i32, i32* @__sidata, i32 1), %12 ], [ getelementptr (i32, i32* @__sidata, i32 2), %86 ], [ getelementptr (i32, i32* @__sidata, i32 3), %88 ]
  br i1 icmp ult (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), i32* @__edata), i32* @__edata, i32* getelementptr inbounds (i32, i32* @__sdata, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sdata to i32))) to i32), i32 2), i32 3), label %.loopexit, label %.preheader

.preheader:                                       ; preds = %14
  %17 = ptrtoint i32* %15 to i32
  %scevgep = getelementptr i32, i32* %15, i32 4
  %18 = icmp ugt i32* %scevgep, @__edata
  %umax = select i1 %18, i32* %scevgep, i32* @__edata
  %umax3 = bitcast i32* %umax to i8*
  %19 = xor i32 %17, -1
  %uglygep = getelementptr i8, i8* %umax3, i32 %19
  %uglygep4 = ptrtoint i8* %uglygep to i32
  %20 = lshr i32 %uglygep4, 4
  %21 = add nuw nsw i32 %20, 1
  %xtraiter = and i32 %21, 3
  %lcmp.mod = icmp eq i32 %xtraiter, 0
  br i1 %lcmp.mod, label %.prol.loopexit, label %.prol.preheader

.prol.preheader:                                  ; preds = %.preheader
  call void @llvm.dbg.value(metadata i32* %15, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %16, metadata !1012, metadata !DIExpression()), !dbg !1013
  %22 = load i32, i32* %16, align 4
  call void @llvm.dbg.value(metadata i32* %15, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %22, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %22, i32* %15, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %15, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %23 = getelementptr inbounds i32, i32* %15, i32 1, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %16, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %24 = getelementptr inbounds i32, i32* %16, i32 1, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %23, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %24, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %23, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %24, metadata !1012, metadata !DIExpression()), !dbg !1013
  %25 = load i32, i32* %24, align 4
  call void @llvm.dbg.value(metadata i32* %23, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %25, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %25, i32* %23, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %23, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %26 = getelementptr inbounds i32, i32* %15, i32 2, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %24, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %27 = getelementptr inbounds i32, i32* %16, i32 2, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %26, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %27, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %26, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %27, metadata !1012, metadata !DIExpression()), !dbg !1013
  %28 = load i32, i32* %27, align 4
  call void @llvm.dbg.value(metadata i32* %26, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %28, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %28, i32* %26, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %26, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %29 = getelementptr inbounds i32, i32* %15, i32 3, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %27, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %30 = getelementptr inbounds i32, i32* %16, i32 3, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %29, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %30, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %29, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %30, metadata !1012, metadata !DIExpression()), !dbg !1013
  %31 = load i32, i32* %30, align 4
  call void @llvm.dbg.value(metadata i32* %29, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %31, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %31, i32* %29, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %29, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %32 = getelementptr inbounds i32, i32* %15, i32 4, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %30, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %33 = getelementptr inbounds i32, i32* %16, i32 4, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %32, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %33, metadata !1012, metadata !DIExpression()), !dbg !1013
  %prol.iter.cmp = icmp eq i32 %xtraiter, 1, !dbg !1015
  br i1 %prol.iter.cmp, label %.prol.loopexit, label %92, !dbg !1015

.prol.loopexit:                                   ; preds = %105, %.prol.preheader, %92, %.preheader
  %.unr = phi i32* [ %15, %.preheader ], [ %32, %.prol.preheader ], [ %103, %92 ], [ %116, %105 ]
  %.unr5 = phi i32* [ %16, %.preheader ], [ %33, %.prol.preheader ], [ %104, %92 ], [ %117, %105 ]
  %34 = icmp ult i8* %uglygep, inttoptr (i32 48 to i8*)
  br i1 %34, label %.loopexit, label %.preheader.new

.preheader.new:                                   ; preds = %.prol.loopexit, %.preheader.new
  %35 = phi i32* [ %83, %.preheader.new ], [ %.unr, %.prol.loopexit ]
  %36 = phi i32* [ %84, %.preheader.new ], [ %.unr5, %.prol.loopexit ]
  call void @llvm.dbg.value(metadata i32* %35, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %36, metadata !1012, metadata !DIExpression()), !dbg !1013
  %37 = load i32, i32* %36, align 4
  call void @llvm.dbg.value(metadata i32* %35, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %37, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %37, i32* %35, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %35, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %38 = getelementptr inbounds i32, i32* %35, i32 1, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %36, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %39 = getelementptr inbounds i32, i32* %36, i32 1, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %38, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %39, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %38, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %39, metadata !1012, metadata !DIExpression()), !dbg !1013
  %40 = load i32, i32* %39, align 4
  call void @llvm.dbg.value(metadata i32* %38, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %40, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %40, i32* %38, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %38, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %41 = getelementptr inbounds i32, i32* %35, i32 2, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %39, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %42 = getelementptr inbounds i32, i32* %36, i32 2, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %41, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %42, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %41, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %42, metadata !1012, metadata !DIExpression()), !dbg !1013
  %43 = load i32, i32* %42, align 4
  call void @llvm.dbg.value(metadata i32* %41, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %43, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %43, i32* %41, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %41, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %44 = getelementptr inbounds i32, i32* %35, i32 3, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %42, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %45 = getelementptr inbounds i32, i32* %36, i32 3, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %44, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %45, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %44, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %45, metadata !1012, metadata !DIExpression()), !dbg !1013
  %46 = load i32, i32* %45, align 4
  call void @llvm.dbg.value(metadata i32* %44, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %46, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %46, i32* %44, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %44, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %47 = getelementptr inbounds i32, i32* %35, i32 4, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %45, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %48 = getelementptr inbounds i32, i32* %36, i32 4, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %47, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %48, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %47, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %48, metadata !1012, metadata !DIExpression()), !dbg !1013
  %49 = load i32, i32* %48, align 4
  call void @llvm.dbg.value(metadata i32* %47, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %49, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %49, i32* %47, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %47, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %50 = getelementptr inbounds i32, i32* %35, i32 5, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %48, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %51 = getelementptr inbounds i32, i32* %36, i32 5, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %50, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %51, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %50, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %51, metadata !1012, metadata !DIExpression()), !dbg !1013
  %52 = load i32, i32* %51, align 4
  call void @llvm.dbg.value(metadata i32* %50, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %52, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %52, i32* %50, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %50, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %53 = getelementptr inbounds i32, i32* %35, i32 6, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %51, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %54 = getelementptr inbounds i32, i32* %36, i32 6, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %53, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %54, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %53, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %54, metadata !1012, metadata !DIExpression()), !dbg !1013
  %55 = load i32, i32* %54, align 4
  call void @llvm.dbg.value(metadata i32* %53, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %55, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %55, i32* %53, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %53, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %56 = getelementptr inbounds i32, i32* %35, i32 7, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %54, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %57 = getelementptr inbounds i32, i32* %36, i32 7, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %56, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %57, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %56, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %57, metadata !1012, metadata !DIExpression()), !dbg !1013
  %58 = load i32, i32* %57, align 4
  call void @llvm.dbg.value(metadata i32* %56, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %58, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %58, i32* %56, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %56, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %59 = getelementptr inbounds i32, i32* %35, i32 8, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %57, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %60 = getelementptr inbounds i32, i32* %36, i32 8, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %59, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %60, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %59, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %60, metadata !1012, metadata !DIExpression()), !dbg !1013
  %61 = load i32, i32* %60, align 4
  call void @llvm.dbg.value(metadata i32* %59, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %61, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %61, i32* %59, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %59, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %62 = getelementptr inbounds i32, i32* %35, i32 9, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %60, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %63 = getelementptr inbounds i32, i32* %36, i32 9, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %62, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %63, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %62, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %63, metadata !1012, metadata !DIExpression()), !dbg !1013
  %64 = load i32, i32* %63, align 4
  call void @llvm.dbg.value(metadata i32* %62, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %64, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %64, i32* %62, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %62, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %65 = getelementptr inbounds i32, i32* %35, i32 10, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %63, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %66 = getelementptr inbounds i32, i32* %36, i32 10, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %65, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %66, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %65, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %66, metadata !1012, metadata !DIExpression()), !dbg !1013
  %67 = load i32, i32* %66, align 4
  call void @llvm.dbg.value(metadata i32* %65, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %67, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %67, i32* %65, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %65, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %68 = getelementptr inbounds i32, i32* %35, i32 11, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %66, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %69 = getelementptr inbounds i32, i32* %36, i32 11, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %68, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %69, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %68, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %69, metadata !1012, metadata !DIExpression()), !dbg !1013
  %70 = load i32, i32* %69, align 4
  call void @llvm.dbg.value(metadata i32* %68, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %70, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %70, i32* %68, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %68, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %71 = getelementptr inbounds i32, i32* %35, i32 12, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %69, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %72 = getelementptr inbounds i32, i32* %36, i32 12, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %71, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %72, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %71, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %72, metadata !1012, metadata !DIExpression()), !dbg !1013
  %73 = load i32, i32* %72, align 4
  call void @llvm.dbg.value(metadata i32* %71, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %73, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %73, i32* %71, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %71, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %74 = getelementptr inbounds i32, i32* %35, i32 13, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %72, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %75 = getelementptr inbounds i32, i32* %36, i32 13, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %74, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %75, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %74, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %75, metadata !1012, metadata !DIExpression()), !dbg !1013
  %76 = load i32, i32* %75, align 4
  call void @llvm.dbg.value(metadata i32* %74, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %76, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %76, i32* %74, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %74, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %77 = getelementptr inbounds i32, i32* %35, i32 14, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %75, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %78 = getelementptr inbounds i32, i32* %36, i32 14, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %77, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %78, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %77, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %78, metadata !1012, metadata !DIExpression()), !dbg !1013
  %79 = load i32, i32* %78, align 4
  call void @llvm.dbg.value(metadata i32* %77, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %79, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %79, i32* %77, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %77, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %80 = getelementptr inbounds i32, i32* %35, i32 15, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %78, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %81 = getelementptr inbounds i32, i32* %36, i32 15, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %80, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %81, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %80, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %81, metadata !1012, metadata !DIExpression()), !dbg !1013
  %82 = load i32, i32* %81, align 4
  call void @llvm.dbg.value(metadata i32* %80, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %82, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %82, i32* %80, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %80, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %83 = getelementptr inbounds i32, i32* %35, i32 16, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %81, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %84 = getelementptr inbounds i32, i32* %36, i32 16, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %83, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %84, metadata !1012, metadata !DIExpression()), !dbg !1013
  %85 = icmp ult i32* %83, @__edata, !dbg !1035
  br i1 %85, label %.preheader.new, label %.loopexit, !dbg !1015

.loopexit:                                        ; preds = %.prol.loopexit, %.preheader.new, %14, %.loopexit2
  tail call void @main(), !dbg !1036
  unreachable, !dbg !1036

; <label>:86:                                     ; preds = %12
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sidata, i32 1), metadata !1012, metadata !DIExpression()), !dbg !1013
  %87 = load i32, i32* getelementptr inbounds (i32, i32* @__sidata, i32 1), align 4
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %87, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %87, i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sidata, i32 1), metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sdata, i32 2), metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sidata, i32 2), metadata !1012, metadata !DIExpression()), !dbg !1013
  br i1 icmp ne (i32 sub (i32 sub (i32 and (i32 add (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sdata, i32 1), i32* @__edata), i32* @__edata, i32* getelementptr inbounds (i32, i32* @__sdata, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sdata to i32))) to i32), i32 2), i32 1), i32 3), i32 1), i32 1), i32 0), label %88, label %14, !dbg !1015

; <label>:88:                                     ; preds = %86
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sdata, i32 2), metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sidata, i32 2), metadata !1012, metadata !DIExpression()), !dbg !1013
  %89 = load i32, i32* getelementptr (i32, i32* @__sidata, i32 2), align 4
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sdata, i32 2), metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %89, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %89, i32* getelementptr (i32, i32* @__sdata, i32 2), align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sdata, i32 2), metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sidata, i32 2), metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sdata, i32 3), metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sidata, i32 3), metadata !1012, metadata !DIExpression()), !dbg !1013
  br label %14

; <label>:90:                                     ; preds = %2
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sbss, i32 2), metadata !968, metadata !DIExpression()), !dbg !980
  br i1 icmp ne (i32 sub (i32 sub (i32 and (i32 add (i32 lshr (i32 ptrtoint (i8* getelementptr (i8, i8* bitcast (i32* select (i1 icmp ult (i32* getelementptr inbounds (i32, i32* @__sbss, i32 1), i32* @__ebss), i32* @__ebss, i32* getelementptr inbounds (i32, i32* @__sbss, i32 1)) to i8*), i32 sub (i32 -1, i32 ptrtoint (i32* @__sbss to i32))) to i32), i32 2), i32 1), i32 3), i32 1), i32 1), i32 0), label %91, label %3, !dbg !982

; <label>:91:                                     ; preds = %90
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sbss, i32 2), metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sbss, i32 2), metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* getelementptr (i32, i32* @__sbss, i32 2), align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sbss, i32 2), metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32* getelementptr (i32, i32* @__sbss, i32 3), metadata !968, metadata !DIExpression()), !dbg !980
  br label %3

; <label>:92:                                     ; preds = %.prol.preheader
  call void @llvm.dbg.value(metadata i32* %32, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %33, metadata !1012, metadata !DIExpression()), !dbg !1013
  %93 = load i32, i32* %33, align 4
  call void @llvm.dbg.value(metadata i32* %32, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %93, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %93, i32* %32, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %32, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %94 = getelementptr inbounds i32, i32* %15, i32 5, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %33, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %95 = getelementptr inbounds i32, i32* %16, i32 5, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %94, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %95, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %94, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %95, metadata !1012, metadata !DIExpression()), !dbg !1013
  %96 = load i32, i32* %95, align 4
  call void @llvm.dbg.value(metadata i32* %94, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %96, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %96, i32* %94, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %94, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %97 = getelementptr inbounds i32, i32* %15, i32 6, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %95, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %98 = getelementptr inbounds i32, i32* %16, i32 6, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %97, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %98, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %97, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %98, metadata !1012, metadata !DIExpression()), !dbg !1013
  %99 = load i32, i32* %98, align 4
  call void @llvm.dbg.value(metadata i32* %97, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %99, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %99, i32* %97, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %97, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %100 = getelementptr inbounds i32, i32* %15, i32 7, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %98, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %101 = getelementptr inbounds i32, i32* %16, i32 7, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %100, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %101, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %100, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %101, metadata !1012, metadata !DIExpression()), !dbg !1013
  %102 = load i32, i32* %101, align 4
  call void @llvm.dbg.value(metadata i32* %100, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %102, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %102, i32* %100, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %100, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %103 = getelementptr inbounds i32, i32* %15, i32 8, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %101, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %104 = getelementptr inbounds i32, i32* %16, i32 8, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %103, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %104, metadata !1012, metadata !DIExpression()), !dbg !1013
  %prol.iter.cmp.1 = icmp eq i32 %xtraiter, 2, !dbg !1015
  br i1 %prol.iter.cmp.1, label %.prol.loopexit, label %105, !dbg !1015

; <label>:105:                                    ; preds = %92
  call void @llvm.dbg.value(metadata i32* %103, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %104, metadata !1012, metadata !DIExpression()), !dbg !1013
  %106 = load i32, i32* %104, align 4
  call void @llvm.dbg.value(metadata i32* %103, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %106, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %106, i32* %103, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %103, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %107 = getelementptr inbounds i32, i32* %15, i32 9, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %104, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %108 = getelementptr inbounds i32, i32* %16, i32 9, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %107, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %108, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %107, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %108, metadata !1012, metadata !DIExpression()), !dbg !1013
  %109 = load i32, i32* %108, align 4
  call void @llvm.dbg.value(metadata i32* %107, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %109, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %109, i32* %107, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %107, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %110 = getelementptr inbounds i32, i32* %15, i32 10, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %108, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %111 = getelementptr inbounds i32, i32* %16, i32 10, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %110, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %111, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %110, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %111, metadata !1012, metadata !DIExpression()), !dbg !1013
  %112 = load i32, i32* %111, align 4
  call void @llvm.dbg.value(metadata i32* %110, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %112, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %112, i32* %110, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %110, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %113 = getelementptr inbounds i32, i32* %15, i32 11, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %111, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %114 = getelementptr inbounds i32, i32* %16, i32 11, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %113, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %114, metadata !1012, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %113, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %114, metadata !1012, metadata !DIExpression()), !dbg !1013
  %115 = load i32, i32* %114, align 4
  call void @llvm.dbg.value(metadata i32* %113, metadata !1016, metadata !DIExpression()), !dbg !1020
  call void @llvm.dbg.value(metadata i32 %115, metadata !1019, metadata !DIExpression()), !dbg !1020
  store i32 %115, i32* %113, align 4, !dbg !1022
  call void @llvm.dbg.value(metadata i32* %113, metadata !993, metadata !DIExpression()), !dbg !1023
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1023
  %116 = getelementptr inbounds i32, i32* %15, i32 12, !dbg !1033
  call void @llvm.dbg.value(metadata i32* %114, metadata !1025, metadata !DIExpression()), !dbg !1031
  call void @llvm.dbg.value(metadata i32 1, metadata !1030, metadata !DIExpression()), !dbg !1031
  %117 = getelementptr inbounds i32, i32* %16, i32 12, !dbg !1034
  call void @llvm.dbg.value(metadata i32* %116, metadata !1005, metadata !DIExpression()), !dbg !1013
  call void @llvm.dbg.value(metadata i32* %117, metadata !1012, metadata !DIExpression()), !dbg !1013
  br label %.prol.loopexit

; <label>:118:                                    ; preds = %.preheader1
  call void @llvm.dbg.value(metadata i32* %9, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %9, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %9, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %9, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %119 = getelementptr inbounds i32, i32* %5, i32 5, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %119, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %119, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %119, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %119, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %119, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %120 = getelementptr inbounds i32, i32* %5, i32 6, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %120, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %120, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %120, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %120, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %120, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %121 = getelementptr inbounds i32, i32* %5, i32 7, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %121, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %121, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %121, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %121, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %121, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %122 = getelementptr inbounds i32, i32* %5, i32 8, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %122, metadata !968, metadata !DIExpression()), !dbg !980
  %123 = icmp ult i32* %122, @__ebss, !dbg !1004
  br i1 %123, label %124, label %.loopexit2, !dbg !982

; <label>:124:                                    ; preds = %118
  call void @llvm.dbg.value(metadata i32* %122, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %122, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %122, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %122, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %125 = getelementptr inbounds i32, i32* %5, i32 9, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %125, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %125, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %125, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %125, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %125, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %126 = getelementptr inbounds i32, i32* %5, i32 10, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %126, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %126, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %126, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %126, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %126, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %127 = getelementptr inbounds i32, i32* %5, i32 11, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %127, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %127, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %127, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %127, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %127, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %128 = getelementptr inbounds i32, i32* %5, i32 12, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %128, metadata !968, metadata !DIExpression()), !dbg !980
  %129 = icmp ult i32* %128, @__ebss, !dbg !1004
  br i1 %129, label %130, label %.loopexit2, !dbg !982

; <label>:130:                                    ; preds = %124
  call void @llvm.dbg.value(metadata i32* %128, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %128, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %128, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %128, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %131 = getelementptr inbounds i32, i32* %5, i32 13, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %131, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %131, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %131, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %131, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %131, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %132 = getelementptr inbounds i32, i32* %5, i32 14, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %132, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %132, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %132, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %132, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %132, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %133 = getelementptr inbounds i32, i32* %5, i32 15, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %133, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %133, metadata !968, metadata !DIExpression()), !dbg !980
  call void @llvm.dbg.value(metadata i32* %133, metadata !989, metadata !DIExpression()), !dbg !992
  call void @llvm.dbg.value(metadata i32 0, metadata !990, metadata !DIExpression()), !dbg !992
  store volatile i32 0, i32* %133, align 4, !dbg !983
  call void @llvm.dbg.value(metadata i32* %133, metadata !993, metadata !DIExpression()), !dbg !1001
  call void @llvm.dbg.value(metadata i32 1, metadata !1000, metadata !DIExpression()), !dbg !1001
  %134 = getelementptr inbounds i32, i32* %5, i32 16, !dbg !1003
  call void @llvm.dbg.value(metadata i32* %134, metadata !968, metadata !DIExpression()), !dbg !980
  %135 = icmp ult i32* %134, @__ebss, !dbg !1004
  br i1 %135, label %.preheader1, label %.loopexit2, !dbg !982
}

; Function Attrs: nounwind
declare void @__pre_init() unnamed_addr #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare void @NonMaskableInt() unnamed_addr #1

; Function Attrs: nounwind
declare void @HardFault() unnamed_addr #1

; Function Attrs: nounwind
declare void @MemoryManagement() unnamed_addr #1

; Function Attrs: nounwind
declare void @BusFault() unnamed_addr #1

; Function Attrs: nounwind
declare void @UsageFault() unnamed_addr #1

; Function Attrs: nounwind
declare void @SVCall() unnamed_addr #1

; Function Attrs: nounwind
declare void @DebugMonitor() unnamed_addr #1

; Function Attrs: nounwind
declare void @PendSV() unnamed_addr #1

; Function Attrs: nounwind
declare void @SysTick() unnamed_addr #1

; Function Attrs: nounwind
declare void @DefaultHandler() unnamed_addr #1

; Function Attrs: noreturn nounwind
define void @UserHardFault_(%ExceptionFrame* noalias nocapture readonly dereferenceable(32)) unnamed_addr #0 !dbg !1037 {
  call void @llvm.dbg.value(metadata %ExceptionFrame* %0, metadata !1052, metadata !DIExpression()), !dbg !1053
  fence syncscope("singlethread") seq_cst
  br label %2, !dbg !1054

; <label>:2:                                      ; preds = %2, %1
  br label %2, !dbg !1054
}

; Function Attrs: norecurse noreturn nounwind
define void @DefaultHandler_() unnamed_addr #3 !dbg !1055 {
  fence syncscope("singlethread") seq_cst
  br label %1, !dbg !1056

; <label>:1:                                      ; preds = %1, %0
  br label %1, !dbg !1056
}

; Function Attrs: norecurse nounwind readnone
define void @DefaultPreInit() unnamed_addr #4 !dbg !1057 {
  ret void, !dbg !1058
}

attributes #0 = { noreturn nounwind }
attributes #1 = { nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { norecurse noreturn nounwind }
attributes #4 = { norecurse nounwind readnone }

!llvm.dbg.cu = !{!36, !39, !76, !78, !172, !174, !176, !178, !180, !183}
!llvm.module.flags = !{!955}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "__ONCE__", linkageName: "error: cortex-m-rt appears more than once in the dependency graph", scope: !2, file: !3, line: 403, type: !4, isLocal: false, isDefinition: true, align: 1)
!2 = !DINamespace(name: "cortex_m_rt", scope: null)
!3 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-rt-0.6.5/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-rt-0.6.5")
!4 = !DIBasicType(name: "()", encoding: DW_ATE_unsigned)
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "__RESET_VECTOR", scope: !2, file: !3, line: 471, type: !7, isLocal: false, isDefinition: true, align: 4)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "unsafe extern \22C\22 fn() -> !", baseType: !8, size: 32, align: 32)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "!", encoding: DW_ATE_unsigned)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "__EXCEPTIONS", scope: !2, file: !3, line: 623, type: !13, isLocal: false, isDefinition: true, align: 4)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 448, align: 32, elements: !23)
!14 = !DICompositeType(tag: DW_TAG_union_type, name: "Vector", scope: !2, file: !15, size: 32, align: 32, elements: !16, identifier: "6a5f0655d5cdee93ccd027c6625ca1ad")
!15 = !DIFile(filename: "<unknown>", directory: "")
!16 = !{!17, !21}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "handler", scope: !14, file: !15, baseType: !18, size: 32, align: 32)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "unsafe extern \22C\22 fn()", baseType: !19, size: 32, align: 32)
!19 = !DISubroutineType(types: !20)
!20 = !{null}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !14, file: !15, baseType: !22, size: 32, align: 32)
!22 = !DIBasicType(name: "usize", size: 32, encoding: DW_ATE_unsigned)
!23 = !{!24}
!24 = !DISubrange(count: 14)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "__INTERRUPTS", scope: !2, file: !3, line: 683, type: !27, isLocal: false, isDefinition: true, align: 4)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 7680, align: 32, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 240)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "CORE_PERIPHERALS", scope: !32, file: !34, line: 153, type: !35, isLocal: false, isDefinition: true, align: 1)
!32 = !DINamespace(name: "peripheral", scope: !33)
!33 = !DINamespace(name: "cortex_m", scope: null)
!34 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-0.5.8/src/peripheral/mod.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-0.5.8")
!35 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!36 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !37, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !38)
!37 = !DIFile(filename: "examples/minimal.rs", directory: "/tmp/app")
!38 = !{}
!39 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !3, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !40, globals: !66)
!40 = !{!41, !48, !57}
!41 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Result", scope: !42, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !45)
!42 = !DINamespace(name: "result", scope: !43)
!43 = !DINamespace(name: "core", scope: null)
!44 = !DIBasicType(name: "u8", size: 8, encoding: DW_ATE_unsigned)
!45 = !{!46, !47}
!46 = !DIEnumerator(name: "Ok", value: 0)
!47 = !DIEnumerator(name: "Err", value: 1)
!48 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Alignment", scope: !49, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !52)
!49 = !DINamespace(name: "v1", scope: !50)
!50 = !DINamespace(name: "rt", scope: !51)
!51 = !DINamespace(name: "fmt", scope: !43)
!52 = !{!53, !54, !55, !56}
!53 = !DIEnumerator(name: "Left", value: 0)
!54 = !DIEnumerator(name: "Right", value: 1)
!55 = !DIEnumerator(name: "Center", value: 2)
!56 = !DIEnumerator(name: "Unknown", value: 3)
!57 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Ordering", scope: !58, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !60)
!58 = !DINamespace(name: "atomic", scope: !59)
!59 = !DINamespace(name: "sync", scope: !43)
!60 = !{!61, !62, !63, !64, !65}
!61 = !DIEnumerator(name: "Relaxed", value: 0)
!62 = !DIEnumerator(name: "Release", value: 1)
!63 = !DIEnumerator(name: "Acquire", value: 2)
!64 = !DIEnumerator(name: "AcqRel", value: 3)
!65 = !DIEnumerator(name: "SeqCst", value: 4)
!66 = !{!0, !67, !5, !11, !25}
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !69, isLocal: true, isDefinition: true)
!69 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !70, identifier: "vtable")
!70 = !DICompositeType(tag: DW_TAG_structure_type, name: "Hex", scope: !71, file: !15, size: 32, align: 32, elements: !73, identifier: "57adee6998f317a6c1692663cb4a3c9b")
!71 = !DINamespace(name: "fmt", scope: !72)
!72 = !DINamespace(name: "{{impl}}", scope: !2)
!73 = !{!74}
!74 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !70, file: !15, baseType: !75, size: 32, align: 32)
!75 = !DIBasicType(name: "u32", size: 32, encoding: DW_ATE_unsigned)
!76 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !77, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !38)
!77 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/r0-0.2.2/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/r0-0.2.2")
!78 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !79, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !80, globals: !137)
!79 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-0.5.8/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-0.5.8")
!80 = !{!41, !48, !81, !93, !98, !103, !112, !117, !123, !127, !131, !135}
!81 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Exception", scope: !82, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !83)
!82 = !DINamespace(name: "scb", scope: !32)
!83 = !{!84, !85, !86, !87, !88, !89, !90, !91, !92}
!84 = !DIEnumerator(name: "NonMaskableInt", value: 0)
!85 = !DIEnumerator(name: "HardFault", value: 1)
!86 = !DIEnumerator(name: "MemoryManagement", value: 2)
!87 = !DIEnumerator(name: "BusFault", value: 3)
!88 = !DIEnumerator(name: "UsageFault", value: 4)
!89 = !DIEnumerator(name: "SVCall", value: 5)
!90 = !DIEnumerator(name: "DebugMonitor", value: 6)
!91 = !DIEnumerator(name: "PendSV", value: 7)
!92 = !DIEnumerator(name: "SysTick", value: 8)
!93 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Option", scope: !94, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !95)
!94 = !DINamespace(name: "option", scope: !43)
!95 = !{!96, !97}
!96 = !DIEnumerator(name: "None", value: 0)
!97 = !DIEnumerator(name: "Some", value: 1)
!98 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "CsselrCacheType", scope: !99, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !100)
!99 = !DINamespace(name: "cpuid", scope: !32)
!100 = !{!101, !102}
!101 = !DIEnumerator(name: "DataOrUnified", value: 0)
!102 = !DIEnumerator(name: "Instruction", value: 1)
!103 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "SystemHandler", scope: !82, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !104)
!104 = !{!105, !106, !107, !108, !109, !110, !111}
!105 = !DIEnumerator(name: "MemoryManagement", value: 0)
!106 = !DIEnumerator(name: "BusFault", value: 1)
!107 = !DIEnumerator(name: "UsageFault", value: 2)
!108 = !DIEnumerator(name: "SVCall", value: 3)
!109 = !DIEnumerator(name: "DebugMonitor", value: 4)
!110 = !DIEnumerator(name: "PendSV", value: 5)
!111 = !DIEnumerator(name: "SysTick", value: 6)
!112 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "SystClkSource", scope: !113, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !114)
!113 = !DINamespace(name: "syst", scope: !32)
!114 = !{!115, !116}
!115 = !DIEnumerator(name: "Core", value: 0)
!116 = !DIEnumerator(name: "External", value: 1)
!117 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Npriv", scope: !118, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !120)
!118 = !DINamespace(name: "control", scope: !119)
!119 = !DINamespace(name: "register", scope: !33)
!120 = !{!121, !122}
!121 = !DIEnumerator(name: "Privileged", value: 0)
!122 = !DIEnumerator(name: "Unprivileged", value: 1)
!123 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Spsel", scope: !118, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !124)
!124 = !{!125, !126}
!125 = !DIEnumerator(name: "Msp", value: 0)
!126 = !DIEnumerator(name: "Psp", value: 1)
!127 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Fpca", scope: !118, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !128)
!128 = !{!129, !130}
!129 = !DIEnumerator(name: "Active", value: 0)
!130 = !DIEnumerator(name: "NotActive", value: 1)
!131 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Faultmask", scope: !132, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !133)
!132 = !DINamespace(name: "faultmask", scope: !119)
!133 = !{!129, !134}
!134 = !DIEnumerator(name: "Inactive", value: 1)
!135 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "Primask", scope: !136, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !133)
!136 = !DINamespace(name: "primask", scope: !119)
!137 = !{!138, !30, !160, !164, !168}
!138 = !DIGlobalVariableExpression(var: !139, expr: !DIExpression())
!139 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !140, isLocal: true, isDefinition: true)
!140 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !141, identifier: "vtable")
!141 = !DICompositeType(tag: DW_TAG_structure_type, name: "Adapter<cortex_m::itm::Port>", scope: !142, file: !15, size: 32, align: 32, elements: !144, identifier: "cec539aaf13d31f7c99d9aa3a6b546bd")
!142 = !DINamespace(name: "write_fmt", scope: !143)
!143 = !DINamespace(name: "Write", scope: !51)
!144 = !{!145}
!145 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !141, file: !15, baseType: !146, size: 32, align: 32)
!146 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&mut cortex_m::itm::Port", baseType: !147, size: 32, align: 32)
!147 = !DICompositeType(tag: DW_TAG_structure_type, name: "Port", scope: !148, file: !15, size: 32, align: 32, elements: !149, identifier: "33a666dfd5a6150ccf54d79ef94dec09")
!148 = !DINamespace(name: "itm", scope: !33)
!149 = !{!150}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !147, file: !15, baseType: !151, size: 32, align: 32)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&mut cortex_m::peripheral::itm::Stim", baseType: !152, size: 32, align: 32)
!152 = !DICompositeType(tag: DW_TAG_structure_type, name: "Stim", scope: !153, file: !15, size: 32, align: 32, elements: !154, identifier: "153cbcd56163b66e8bc9f95ef6b01fe8")
!153 = !DINamespace(name: "itm", scope: !32)
!154 = !{!155}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "register", scope: !152, file: !15, baseType: !156, size: 32, align: 32)
!156 = !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeCell<u32>", scope: !157, file: !15, size: 32, align: 32, elements: !158, identifier: "b959bd3f519b02d8550d281d771c666d")
!157 = !DINamespace(name: "cell", scope: !43)
!158 = !{!159}
!159 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !156, file: !15, baseType: !75, size: 32, align: 32)
!160 = !DIGlobalVariableExpression(var: !161, expr: !DIExpression())
!161 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !162, isLocal: true, isDefinition: true)
!162 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !163, identifier: "vtable")
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&u8", baseType: !44, size: 32, align: 32)
!164 = !DIGlobalVariableExpression(var: !165, expr: !DIExpression())
!165 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !166, isLocal: true, isDefinition: true)
!166 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !167, identifier: "vtable")
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&cortex_m::peripheral::scb::Exception", baseType: !81, size: 32, align: 32)
!168 = !DIGlobalVariableExpression(var: !169, expr: !DIExpression())
!169 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !170, isLocal: true, isDefinition: true)
!170 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !171, identifier: "vtable")
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&u32", baseType: !75, size: 32, align: 32)
!172 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !173, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !38)
!173 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/volatile-register-0.2.0/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/volatile-register-0.2.0")
!174 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !175, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !38)
!175 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/vcell-0.1.0/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/vcell-0.1.0")
!176 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !177, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !38)
!177 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/bare-metal-0.2.4/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/bare-metal-0.2.4")
!178 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !179, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !38)
!179 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/aligned-0.2.0/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/aligned-0.2.0")
!180 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !181, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !182)
!181 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/panic-halt-0.2.0/src/lib.rs", directory: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/panic-halt-0.2.0")
!182 = !{!57, !48, !41}
!183 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !184, producer: "clang LLVM (rustc version 1.32.0-nightly (b68fc18c4 2018-11-27))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !185, globals: !222)
!184 = !DIFile(filename: "src/libcore/lib.rs", directory: "/rustc/b68fc18c45350e1cdcd83cecf0f12e294e55af56/")
!185 = !{!186, !192, !197, !208, !48, !41, !214}
!186 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "FloatErrorKind", scope: !187, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !189)
!187 = !DINamespace(name: "dec2flt", scope: !188)
!188 = !DINamespace(name: "num", scope: !43)
!189 = !{!190, !191}
!190 = !DIEnumerator(name: "Empty", value: 0)
!191 = !DIEnumerator(name: "Invalid", value: 1)
!192 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "IntErrorKind", scope: !188, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !193)
!193 = !{!190, !194, !195, !196}
!194 = !DIEnumerator(name: "InvalidDigit", value: 1)
!195 = !DIEnumerator(name: "Overflow", value: 2)
!196 = !DIEnumerator(name: "Underflow", value: 3)
!197 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "AsciiCharacterClass", scope: !188, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !198)
!198 = !{!199, !200, !201, !202, !203, !204, !205, !206, !207}
!199 = !DIEnumerator(name: "C", value: 0)
!200 = !DIEnumerator(name: "Cw", value: 1)
!201 = !DIEnumerator(name: "W", value: 2)
!202 = !DIEnumerator(name: "D", value: 3)
!203 = !DIEnumerator(name: "L", value: 4)
!204 = !DIEnumerator(name: "Lx", value: 5)
!205 = !DIEnumerator(name: "U", value: 6)
!206 = !DIEnumerator(name: "Ux", value: 7)
!207 = !DIEnumerator(name: "P", value: 8)
!208 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "CharErrorKind", scope: !209, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !211)
!209 = !DINamespace(name: "convert", scope: !210)
!210 = !DINamespace(name: "char", scope: !43)
!211 = !{!212, !213}
!212 = !DIEnumerator(name: "EmptyString", value: 0)
!213 = !DIEnumerator(name: "TooManyChars", value: 1)
!214 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "EscapeUnicodeState", scope: !210, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagFixedEnum, elements: !215)
!215 = !{!216, !217, !218, !219, !220, !221}
!216 = !DIEnumerator(name: "Done", value: 0)
!217 = !DIEnumerator(name: "RightBrace", value: 1)
!218 = !DIEnumerator(name: "Value", value: 2)
!219 = !DIEnumerator(name: "LeftBrace", value: 3)
!220 = !DIEnumerator(name: "Type", value: 4)
!221 = !DIEnumerator(name: "Backslash", value: 5)
!222 = !{!223, !232, !234, !239, !244, !249, !252, !257, !271, !277, !279, !284, !291, !313, !341, !344, !380, !383, !386, !389, !392, !395, !398, !401, !404, !421, !423, !427, !434, !438, !442, !446, !458, !462, !467, !471, !476, !486, !490, !494, !498, !502, !506, !534, !538, !545, !570, !579, !703, !712, !716, !718, !722, !726, !730, !739, !743, !752, !785, !789, !793, !808, !812, !819, !822, !825, !834, !841, !849, !858, !880, !894, !901, !905, !909, !913, !925, !935, !940, !945, !950}
!223 = !DIGlobalVariableExpression(var: !224, expr: !DIExpression())
!224 = distinct !DIGlobalVariable(name: "POW10", linkageName: "_ZN4core3num7flt2dec8strategy6dragon5POW1017h1c25ede7648bdec0E", scope: !225, file: !228, line: 24, type: !229, isLocal: true, isDefinition: true, align: 4)
!225 = !DINamespace(name: "dragon", scope: !226)
!226 = !DINamespace(name: "strategy", scope: !227)
!227 = !DINamespace(name: "flt2dec", scope: !188)
!228 = !DIFile(filename: "src/libcore/num/flt2dec/strategy/dragon.rs", directory: "/rustc/b68fc18c45350e1cdcd83cecf0f12e294e55af56/")
!229 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 320, align: 32, elements: !230)
!230 = !{!231}
!231 = !DISubrange(count: 10)
!232 = !DIGlobalVariableExpression(var: !233, expr: !DIExpression())
!233 = distinct !DIGlobalVariable(name: "TWOPOW10", linkageName: "_ZN4core3num7flt2dec8strategy6dragon8TWOPOW1017h97f083cabee69b3dE", scope: !225, file: !228, line: 26, type: !229, isLocal: true, isDefinition: true, align: 4)
!234 = !DIGlobalVariableExpression(var: !235, expr: !DIExpression())
!235 = distinct !DIGlobalVariable(name: "POW10TO16", linkageName: "_ZN4core3num7flt2dec8strategy6dragon9POW10TO1617h61e3d10318d551dfE", scope: !225, file: !228, line: 30, type: !236, isLocal: true, isDefinition: true, align: 4)
!236 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 64, align: 32, elements: !237)
!237 = !{!238}
!238 = !DISubrange(count: 2)
!239 = !DIGlobalVariableExpression(var: !240, expr: !DIExpression())
!240 = distinct !DIGlobalVariable(name: "POW10TO32", linkageName: "_ZN4core3num7flt2dec8strategy6dragon9POW10TO3217hd422e6755b34d1a1E", scope: !225, file: !228, line: 31, type: !241, isLocal: true, isDefinition: true, align: 4)
!241 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 128, align: 32, elements: !242)
!242 = !{!243}
!243 = !DISubrange(count: 4)
!244 = !DIGlobalVariableExpression(var: !245, expr: !DIExpression())
!245 = distinct !DIGlobalVariable(name: "POW10TO64", linkageName: "_ZN4core3num7flt2dec8strategy6dragon9POW10TO6417h42f7a7ee7e9b1b01E", scope: !225, file: !228, line: 32, type: !246, isLocal: true, isDefinition: true, align: 4)
!246 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 224, align: 32, elements: !247)
!247 = !{!248}
!248 = !DISubrange(count: 7)
!249 = !DIGlobalVariableExpression(var: !250, expr: !DIExpression())
!250 = distinct !DIGlobalVariable(name: "POW10TO128", linkageName: "_ZN4core3num7flt2dec8strategy6dragon10POW10TO12817hfdfd0ce157825364E", scope: !225, file: !228, line: 33, type: !251, isLocal: true, isDefinition: true, align: 4)
!251 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 448, align: 32, elements: !23)
!252 = !DIGlobalVariableExpression(var: !253, expr: !DIExpression())
!253 = distinct !DIGlobalVariable(name: "POW10TO256", linkageName: "_ZN4core3num7flt2dec8strategy6dragon10POW10TO25617h9d6ca0da319bfe05E", scope: !225, file: !228, line: 36, type: !254, isLocal: true, isDefinition: true, align: 4)
!254 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 864, align: 32, elements: !255)
!255 = !{!256}
!256 = !DISubrange(count: 27)
!257 = !DIGlobalVariableExpression(var: !258, expr: !DIExpression())
!258 = distinct !DIGlobalVariable(name: "CACHED_POW10", linkageName: "_ZN4core3num7flt2dec8strategy5grisu12CACHED_POW1017hc7fcdb47ba9205eeE", scope: !259, file: !260, line: 37, type: !261, isLocal: false, isDefinition: true, align: 8)
!259 = !DINamespace(name: "grisu", scope: !226)
!260 = !DIFile(filename: "src/libcore/num/flt2dec/strategy/grisu.rs", directory: "/rustc/b68fc18c45350e1cdcd83cecf0f12e294e55af56/")
!261 = !DICompositeType(tag: DW_TAG_array_type, baseType: !262, size: 10368, align: 64, elements: !269)
!262 = !DICompositeType(tag: DW_TAG_structure_type, name: "(u64, i16, i16)", file: !15, size: 128, align: 64, elements: !263, identifier: "ce95d83cebadd2eb5df998d041323504")
!263 = !{!264, !266, !268}
!264 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !262, file: !15, baseType: !265, size: 64, align: 64)
!265 = !DIBasicType(name: "u64", size: 64, encoding: DW_ATE_unsigned)
!266 = !DIDerivedType(tag: DW_TAG_member, name: "__1", scope: !262, file: !15, baseType: !267, size: 16, align: 16, offset: 64)
!267 = !DIBasicType(name: "i16", size: 16, encoding: DW_ATE_signed)
!268 = !DIDerivedType(tag: DW_TAG_member, name: "__2", scope: !262, file: !15, baseType: !267, size: 16, align: 16, offset: 80)
!269 = !{!270}
!270 = !DISubrange(count: 81)
!271 = !DIGlobalVariableExpression(var: !272, expr: !DIExpression())
!272 = distinct !DIGlobalVariable(name: "ASCII_LOWERCASE_MAP", linkageName: "_ZN4core3num19ASCII_LOWERCASE_MAP17h8d7e31719da6a88cE", scope: !188, file: !273, line: 4947, type: !274, isLocal: false, isDefinition: true, align: 1)
!273 = !DIFile(filename: "src/libcore/num/mod.rs", directory: "/rustc/b68fc18c45350e1cdcd83cecf0f12e294e55af56/")
!274 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 2048, align: 8, elements: !275)
!275 = !{!276}
!276 = !DISubrange(count: 256)
!277 = !DIGlobalVariableExpression(var: !278, expr: !DIExpression())
!278 = distinct !DIGlobalVariable(name: "ASCII_UPPERCASE_MAP", linkageName: "_ZN4core3num19ASCII_UPPERCASE_MAP17hf55319194481bf5fE", scope: !188, file: !273, line: 4986, type: !274, isLocal: false, isDefinition: true, align: 1)
!279 = !DIGlobalVariableExpression(var: !280, expr: !DIExpression())
!280 = distinct !DIGlobalVariable(name: "ASCII_CHARACTER_CLASS", linkageName: "_ZN4core3num21ASCII_CHARACTER_CLASS17h7527e62507f9b1c9E", scope: !188, file: !273, line: 5038, type: !281, isLocal: false, isDefinition: true, align: 1)
!281 = !DICompositeType(tag: DW_TAG_array_type, baseType: !197, size: 1024, align: 8, elements: !282)
!282 = !{!283}
!283 = !DISubrange(count: 128)
!284 = !DIGlobalVariableExpression(var: !285, expr: !DIExpression())
!285 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !286, isLocal: true, isDefinition: true)
!286 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !287, identifier: "vtable")
!287 = !DICompositeType(tag: DW_TAG_structure_type, name: "NoPayload", scope: !288, file: !15, align: 8, elements: !38, identifier: "d0afb762eabd382c7c9fa48e4d30fc1c")
!288 = !DINamespace(name: "internal_constructor", scope: !289)
!289 = !DINamespace(name: "{{impl}}", scope: !290)
!290 = !DINamespace(name: "panic", scope: !43)
!291 = !DIGlobalVariableExpression(var: !292, expr: !DIExpression())
!292 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !293, isLocal: true, isDefinition: true)
!293 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !294, identifier: "vtable")
!294 = !DICompositeType(tag: DW_TAG_structure_type, name: "Filter<core::slice::Split<u8, core::str::IsAsciiWhitespace>, core::str::IsNotEmpty>", scope: !295, file: !15, size: 96, align: 32, elements: !296, identifier: "d8adf90717ddbacf9dbddd8f494861ad")
!295 = !DINamespace(name: "iter", scope: !43)
!296 = !{!297, !311}
!297 = !DIDerivedType(tag: DW_TAG_member, name: "iter", scope: !294, file: !15, baseType: !298, size: 96, align: 32)
!298 = !DICompositeType(tag: DW_TAG_structure_type, name: "Split<u8, core::str::IsAsciiWhitespace>", scope: !299, file: !15, size: 96, align: 32, elements: !300, identifier: "8c12065e79fb13c251ddceaae7478ce1")
!299 = !DINamespace(name: "slice", scope: !43)
!300 = !{!301, !307, !310}
!301 = !DIDerivedType(tag: DW_TAG_member, name: "v", scope: !298, file: !15, baseType: !302, size: 64, align: 32)
!302 = !DICompositeType(tag: DW_TAG_structure_type, name: "&[u8]", file: !15, size: 64, align: 32, elements: !303, identifier: "77a791bc5b00f512104688e88bf00bee")
!303 = !{!304, !306}
!304 = !DIDerivedType(tag: DW_TAG_member, name: "data_ptr", scope: !302, file: !15, baseType: !305, size: 32, align: 32)
!305 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*const u8", baseType: !44, size: 32, align: 32)
!306 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !302, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "pred", scope: !298, file: !15, baseType: !308, align: 8)
!308 = !DICompositeType(tag: DW_TAG_structure_type, name: "IsAsciiWhitespace", scope: !309, file: !15, align: 8, elements: !38, identifier: "8d7642f9c50ab07da2e94e1caa3f0633")
!309 = !DINamespace(name: "str", scope: !43)
!310 = !DIDerivedType(tag: DW_TAG_member, name: "finished", scope: !298, file: !15, baseType: !35, size: 8, align: 8, offset: 64)
!311 = !DIDerivedType(tag: DW_TAG_member, name: "predicate", scope: !294, file: !15, baseType: !312, align: 8)
!312 = !DICompositeType(tag: DW_TAG_structure_type, name: "IsNotEmpty", scope: !309, file: !15, align: 8, elements: !38, identifier: "624ab5334813a8b8760ea96cf1577e27")
!313 = !DIGlobalVariableExpression(var: !314, expr: !DIExpression())
!314 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !315, isLocal: true, isDefinition: true)
!315 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !316, identifier: "vtable")
!316 = !DICompositeType(tag: DW_TAG_structure_type, name: "SplitTerminator<char>", scope: !309, file: !15, size: 320, align: 32, elements: !317, identifier: "9384ba5d23b8f74b732ed4e8184245d4")
!317 = !{!318}
!318 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !316, file: !15, baseType: !319, size: 320, align: 32)
!319 = !DICompositeType(tag: DW_TAG_structure_type, name: "SplitInternal<char>", scope: !309, file: !15, size: 320, align: 32, elements: !320, identifier: "cdc4f98aa56ac69cc3d5c9e921eb330f")
!320 = !{!321, !322, !323, !339, !340}
!321 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !319, file: !15, baseType: !22, size: 32, align: 32)
!322 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !319, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!323 = !DIDerivedType(tag: DW_TAG_member, name: "matcher", scope: !319, file: !15, baseType: !324, size: 224, align: 32, offset: 64)
!324 = !DICompositeType(tag: DW_TAG_structure_type, name: "CharSearcher", scope: !325, file: !15, size: 224, align: 32, elements: !326, identifier: "33c5d24f1dd2bc3952d8e24906b466f6")
!325 = !DINamespace(name: "pattern", scope: !309)
!326 = !{!327, !332, !333, !334, !336, !337}
!327 = !DIDerivedType(tag: DW_TAG_member, name: "haystack", scope: !324, file: !15, baseType: !328, size: 64, align: 32)
!328 = !DICompositeType(tag: DW_TAG_structure_type, name: "&str", file: !15, size: 64, align: 32, elements: !329, identifier: "111094d970b097647de579f9c509ef08")
!329 = !{!330, !331}
!330 = !DIDerivedType(tag: DW_TAG_member, name: "data_ptr", scope: !328, file: !15, baseType: !305, size: 32, align: 32)
!331 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !328, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!332 = !DIDerivedType(tag: DW_TAG_member, name: "finger", scope: !324, file: !15, baseType: !22, size: 32, align: 32, offset: 64)
!333 = !DIDerivedType(tag: DW_TAG_member, name: "finger_back", scope: !324, file: !15, baseType: !22, size: 32, align: 32, offset: 96)
!334 = !DIDerivedType(tag: DW_TAG_member, name: "needle", scope: !324, file: !15, baseType: !335, size: 32, align: 32, offset: 128)
!335 = !DIBasicType(name: "char", size: 32, encoding: DW_ATE_unsigned_char)
!336 = !DIDerivedType(tag: DW_TAG_member, name: "utf8_size", scope: !324, file: !15, baseType: !22, size: 32, align: 32, offset: 160)
!337 = !DIDerivedType(tag: DW_TAG_member, name: "utf8_encoded", scope: !324, file: !15, baseType: !338, size: 32, align: 8, offset: 192)
!338 = !DICompositeType(tag: DW_TAG_array_type, baseType: !44, size: 32, align: 8, elements: !242)
!339 = !DIDerivedType(tag: DW_TAG_member, name: "allow_trailing_empty", scope: !319, file: !15, baseType: !35, size: 8, align: 8, offset: 288)
!340 = !DIDerivedType(tag: DW_TAG_member, name: "finished", scope: !319, file: !15, baseType: !35, size: 8, align: 8, offset: 296)
!341 = !DIGlobalVariableExpression(var: !342, expr: !DIExpression())
!342 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !343, isLocal: true, isDefinition: true)
!343 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !298, identifier: "vtable")
!344 = !DIGlobalVariableExpression(var: !345, expr: !DIExpression())
!345 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !346, isLocal: true, isDefinition: true)
!346 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !347, identifier: "vtable")
!347 = !DICompositeType(tag: DW_TAG_structure_type, name: "Split<core::str::IsWhitespace>", scope: !309, file: !15, size: 256, align: 32, elements: !348, identifier: "530e2f0be446a555abcf3977701567ee")
!348 = !{!349}
!349 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !347, file: !15, baseType: !350, size: 256, align: 32)
!350 = !DICompositeType(tag: DW_TAG_structure_type, name: "SplitInternal<core::str::IsWhitespace>", scope: !309, file: !15, size: 256, align: 32, elements: !351, identifier: "35a04550c8482a40dd0ecdebe2bc29fe")
!351 = !{!352, !353, !354, !378, !379}
!352 = !DIDerivedType(tag: DW_TAG_member, name: "start", scope: !350, file: !15, baseType: !22, size: 32, align: 32)
!353 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !350, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!354 = !DIDerivedType(tag: DW_TAG_member, name: "matcher", scope: !350, file: !15, baseType: !355, size: 160, align: 32, offset: 64)
!355 = !DICompositeType(tag: DW_TAG_structure_type, name: "CharPredicateSearcher<core::str::IsWhitespace>", scope: !325, file: !15, size: 160, align: 32, elements: !356, identifier: "d6aa1bfd58bee2bb811203783a775e1a")
!356 = !{!357}
!357 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !355, file: !15, baseType: !358, size: 160, align: 32)
!358 = !DICompositeType(tag: DW_TAG_structure_type, name: "MultiCharEqSearcher<core::str::IsWhitespace>", scope: !325, file: !15, size: 160, align: 32, elements: !359, identifier: "9d59d7426ff6bed14079b3d5b2e0f7e6")
!359 = !{!360, !362, !363}
!360 = !DIDerivedType(tag: DW_TAG_member, name: "char_eq", scope: !358, file: !15, baseType: !361, align: 8)
!361 = !DICompositeType(tag: DW_TAG_structure_type, name: "IsWhitespace", scope: !309, file: !15, align: 8, elements: !38, identifier: "3f53ba50e18fce552615fca6d3165d4")
!362 = !DIDerivedType(tag: DW_TAG_member, name: "haystack", scope: !358, file: !15, baseType: !328, size: 64, align: 32)
!363 = !DIDerivedType(tag: DW_TAG_member, name: "char_indices", scope: !358, file: !15, baseType: !364, size: 96, align: 32, offset: 64)
!364 = !DICompositeType(tag: DW_TAG_structure_type, name: "CharIndices", scope: !309, file: !15, size: 96, align: 32, elements: !365, identifier: "7951ee409e1d00d2fda263da82e398d6")
!365 = !{!366, !367}
!366 = !DIDerivedType(tag: DW_TAG_member, name: "front_offset", scope: !364, file: !15, baseType: !22, size: 32, align: 32)
!367 = !DIDerivedType(tag: DW_TAG_member, name: "iter", scope: !364, file: !15, baseType: !368, size: 64, align: 32, offset: 32)
!368 = !DICompositeType(tag: DW_TAG_structure_type, name: "Chars", scope: !309, file: !15, size: 64, align: 32, elements: !369, identifier: "eea33d512d98d19df97c66c8e68851")
!369 = !{!370}
!370 = !DIDerivedType(tag: DW_TAG_member, name: "iter", scope: !368, file: !15, baseType: !371, size: 64, align: 32)
!371 = !DICompositeType(tag: DW_TAG_structure_type, name: "Iter<u8>", scope: !299, file: !15, size: 64, align: 32, elements: !372, identifier: "e936e02d083466263400f501508d40d4")
!372 = !{!373, !374, !375}
!373 = !DIDerivedType(tag: DW_TAG_member, name: "ptr", scope: !371, file: !15, baseType: !305, size: 32, align: 32)
!374 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !371, file: !15, baseType: !305, size: 32, align: 32, offset: 32)
!375 = !DIDerivedType(tag: DW_TAG_member, name: "_marker", scope: !371, file: !15, baseType: !376, align: 8)
!376 = !DICompositeType(tag: DW_TAG_structure_type, name: "PhantomData<&u8>", scope: !377, file: !15, align: 8, elements: !38, identifier: "7aa7aa9ae9c8e6011a5de1c97ee7d305")
!377 = !DINamespace(name: "marker", scope: !43)
!378 = !DIDerivedType(tag: DW_TAG_member, name: "allow_trailing_empty", scope: !350, file: !15, baseType: !35, size: 8, align: 8, offset: 224)
!379 = !DIDerivedType(tag: DW_TAG_member, name: "finished", scope: !350, file: !15, baseType: !35, size: 8, align: 8, offset: 232)
!380 = !DIGlobalVariableExpression(var: !381, expr: !DIExpression())
!381 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !382, isLocal: true, isDefinition: true)
!382 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !302, identifier: "vtable")
!383 = !DIGlobalVariableExpression(var: !384, expr: !DIExpression())
!384 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !385, isLocal: true, isDefinition: true)
!385 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !35, identifier: "vtable")
!386 = !DIGlobalVariableExpression(var: !387, expr: !DIExpression())
!387 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !388, isLocal: true, isDefinition: true)
!388 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !328, identifier: "vtable")
!389 = !DIGlobalVariableExpression(var: !390, expr: !DIExpression())
!390 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !391, isLocal: true, isDefinition: true)
!391 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !364, identifier: "vtable")
!392 = !DIGlobalVariableExpression(var: !393, expr: !DIExpression())
!393 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !394, isLocal: true, isDefinition: true)
!394 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !22, identifier: "vtable")
!395 = !DIGlobalVariableExpression(var: !396, expr: !DIExpression())
!396 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !397, isLocal: true, isDefinition: true)
!397 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !324, identifier: "vtable")
!398 = !DIGlobalVariableExpression(var: !399, expr: !DIExpression())
!399 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !400, isLocal: true, isDefinition: true)
!400 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !355, identifier: "vtable")
!401 = !DIGlobalVariableExpression(var: !402, expr: !DIExpression())
!402 = distinct !DIGlobalVariable(name: "UTF8_CHAR_WIDTH", linkageName: "_ZN4core3str15UTF8_CHAR_WIDTH17hf0af70b1ba485250E", scope: !309, file: !403, line: 1548, type: !274, isLocal: false, isDefinition: true, align: 1)
!403 = !DIFile(filename: "src/libcore/str/mod.rs", directory: "/rustc/b68fc18c45350e1cdcd83cecf0f12e294e55af56/")
!404 = !DIGlobalVariableExpression(var: !405, expr: !DIExpression())
!405 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !406, isLocal: true, isDefinition: true)
!406 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !407, identifier: "vtable")
!407 = !DICompositeType(tag: DW_TAG_structure_type, name: "PadAdapter", scope: !408, file: !15, size: 96, align: 32, elements: !409, identifier: "cf2fa87b9e39c54a24718cee1003cd96")
!408 = !DINamespace(name: "builders", scope: !51)
!409 = !{!410, !420}
!410 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !407, file: !15, baseType: !411, size: 64, align: 32)
!411 = !DICompositeType(tag: DW_TAG_structure_type, name: "&mut Write", scope: !51, file: !15, size: 64, align: 32, elements: !412, identifier: "6cf3e025927d2ea463575d97829f8e0f")
!412 = !{!413, !415}
!413 = !DIDerivedType(tag: DW_TAG_member, name: "pointer", scope: !411, file: !15, baseType: !414, size: 32, align: 32, flags: DIFlagArtificial)
!414 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*mut u8", baseType: !44, size: 32, align: 32)
!415 = !DIDerivedType(tag: DW_TAG_member, name: "vtable", scope: !411, file: !15, baseType: !416, size: 32, align: 32, offset: 32, flags: DIFlagArtificial)
!416 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&[usize; 3]", baseType: !417, size: 32, align: 32)
!417 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 96, align: 32, elements: !418)
!418 = !{!419}
!419 = !DISubrange(count: 3)
!420 = !DIDerivedType(tag: DW_TAG_member, name: "on_newline", scope: !407, file: !15, baseType: !35, size: 8, align: 8, offset: 64)
!421 = !DIGlobalVariableExpression(var: !422, expr: !DIExpression())
!422 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !162, isLocal: true, isDefinition: true)
!423 = !DIGlobalVariableExpression(var: !424, expr: !DIExpression())
!424 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !425, isLocal: true, isDefinition: true)
!425 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !426, identifier: "vtable")
!426 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&char", baseType: !335, size: 32, align: 32)
!427 = !DIGlobalVariableExpression(var: !428, expr: !DIExpression())
!428 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !429, isLocal: true, isDefinition: true)
!429 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !430, identifier: "vtable")
!430 = !DICompositeType(tag: DW_TAG_structure_type, name: "Adapter<core::fmt::builders::PadAdapter>", scope: !142, file: !15, size: 32, align: 32, elements: !431, identifier: "a67f3a0b491de055bb7918b664a1ad5f")
!431 = !{!432}
!432 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !430, file: !15, baseType: !433, size: 32, align: 32)
!433 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&mut core::fmt::builders::PadAdapter", baseType: !407, size: 32, align: 32)
!434 = !DIGlobalVariableExpression(var: !435, expr: !DIExpression())
!435 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !436, isLocal: true, isDefinition: true)
!436 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !437, identifier: "vtable")
!437 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&u64", baseType: !265, size: 32, align: 32)
!438 = !DIGlobalVariableExpression(var: !439, expr: !DIExpression())
!439 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !440, isLocal: true, isDefinition: true)
!440 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !441, identifier: "vtable")
!441 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&i16", baseType: !267, size: 32, align: 32)
!442 = !DIGlobalVariableExpression(var: !443, expr: !DIExpression())
!443 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !444, isLocal: true, isDefinition: true)
!444 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !445, identifier: "vtable")
!445 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&bool", baseType: !35, size: 32, align: 32)
!446 = !DIGlobalVariableExpression(var: !447, expr: !DIExpression())
!447 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !448, isLocal: true, isDefinition: true)
!448 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !449, identifier: "vtable")
!449 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::num::flt2dec::decoder::Decoded", baseType: !450, size: 32, align: 32)
!450 = !DICompositeType(tag: DW_TAG_structure_type, name: "Decoded", scope: !451, file: !15, size: 256, align: 64, elements: !452, identifier: "c81f2c90484130e8bd2e35d1b5cbdf1")
!451 = !DINamespace(name: "decoder", scope: !227)
!452 = !{!453, !454, !455, !456, !457}
!453 = !DIDerivedType(tag: DW_TAG_member, name: "mant", scope: !450, file: !15, baseType: !265, size: 64, align: 64)
!454 = !DIDerivedType(tag: DW_TAG_member, name: "minus", scope: !450, file: !15, baseType: !265, size: 64, align: 64, offset: 64)
!455 = !DIDerivedType(tag: DW_TAG_member, name: "plus", scope: !450, file: !15, baseType: !265, size: 64, align: 64, offset: 128)
!456 = !DIDerivedType(tag: DW_TAG_member, name: "exp", scope: !450, file: !15, baseType: !267, size: 16, align: 16, offset: 192)
!457 = !DIDerivedType(tag: DW_TAG_member, name: "inclusive", scope: !450, file: !15, baseType: !35, size: 8, align: 8, offset: 208)
!458 = !DIGlobalVariableExpression(var: !459, expr: !DIExpression())
!459 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !460, isLocal: true, isDefinition: true)
!460 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !461, identifier: "vtable")
!461 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&&[u8]", baseType: !302, size: 32, align: 32)
!462 = !DIGlobalVariableExpression(var: !463, expr: !DIExpression())
!463 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !464, isLocal: true, isDefinition: true)
!464 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !465, identifier: "vtable")
!465 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&u16", baseType: !466, size: 32, align: 32)
!466 = !DIBasicType(name: "u16", size: 16, encoding: DW_ATE_unsigned)
!467 = !DIGlobalVariableExpression(var: !468, expr: !DIExpression())
!468 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !469, isLocal: true, isDefinition: true)
!469 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !470, identifier: "vtable")
!470 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&usize", baseType: !22, size: 32, align: 32)
!471 = !DIGlobalVariableExpression(var: !472, expr: !DIExpression())
!472 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !473, isLocal: true, isDefinition: true)
!473 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !474, identifier: "vtable")
!474 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&i64", baseType: !475, size: 32, align: 32)
!475 = !DIBasicType(name: "i64", size: 64, encoding: DW_ATE_signed)
!476 = !DIGlobalVariableExpression(var: !477, expr: !DIExpression())
!477 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !478, isLocal: true, isDefinition: true)
!478 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !479, identifier: "vtable")
!479 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::num::dec2flt::parse::Decimal", baseType: !480, size: 32, align: 32)
!480 = !DICompositeType(tag: DW_TAG_structure_type, name: "Decimal", scope: !481, file: !15, size: 192, align: 64, elements: !482, identifier: "7a666c1d043a9c645db5319bddc71d21")
!481 = !DINamespace(name: "parse", scope: !187)
!482 = !{!483, !484, !485}
!483 = !DIDerivedType(tag: DW_TAG_member, name: "integral", scope: !480, file: !15, baseType: !302, size: 64, align: 32, offset: 64)
!484 = !DIDerivedType(tag: DW_TAG_member, name: "fractional", scope: !480, file: !15, baseType: !302, size: 64, align: 32, offset: 128)
!485 = !DIDerivedType(tag: DW_TAG_member, name: "exp", scope: !480, file: !15, baseType: !475, size: 64, align: 64)
!486 = !DIGlobalVariableExpression(var: !487, expr: !DIExpression())
!487 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !488, isLocal: true, isDefinition: true)
!488 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !489, identifier: "vtable")
!489 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::num::dec2flt::FloatErrorKind", baseType: !186, size: 32, align: 32)
!490 = !DIGlobalVariableExpression(var: !491, expr: !DIExpression())
!491 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !492, isLocal: true, isDefinition: true)
!492 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !493, identifier: "vtable")
!493 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&()", baseType: !4, size: 32, align: 32)
!494 = !DIGlobalVariableExpression(var: !495, expr: !DIExpression())
!495 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !496, isLocal: true, isDefinition: true)
!496 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !497, identifier: "vtable")
!497 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::num::IntErrorKind", baseType: !192, size: 32, align: 32)
!498 = !DIGlobalVariableExpression(var: !499, expr: !DIExpression())
!499 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !500, isLocal: true, isDefinition: true)
!500 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !501, identifier: "vtable")
!501 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::char::convert::CharErrorKind", baseType: !208, size: 32, align: 32)
!502 = !DIGlobalVariableExpression(var: !503, expr: !DIExpression())
!503 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !504, isLocal: true, isDefinition: true)
!504 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !505, identifier: "vtable")
!505 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::char::EscapeUnicodeState", baseType: !214, size: 32, align: 32)
!506 = !DIGlobalVariableExpression(var: !507, expr: !DIExpression())
!507 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !508, isLocal: true, isDefinition: true)
!508 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !509, identifier: "vtable")
!509 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::char::EscapeDefaultState", baseType: !510, size: 32, align: 32)
!510 = !DICompositeType(tag: DW_TAG_structure_type, name: "EscapeDefaultState", scope: !210, file: !15, size: 128, align: 32, elements: !511, identifier: "be8b943514833cc5ed230ea491bf84d2")
!511 = !{!512}
!512 = !DICompositeType(tag: DW_TAG_variant_part, scope: !210, file: !15, size: 128, align: 32, elements: !513, identifier: "be8b943514833cc5ed230ea491bf84d2", discriminator: !533)
!513 = !{!514, !516, !520, !524}
!514 = !DIDerivedType(tag: DW_TAG_member, name: "Done", scope: !512, file: !15, baseType: !515, size: 128, align: 32, extraData: i64 0)
!515 = !DICompositeType(tag: DW_TAG_structure_type, name: "Done", scope: !510, file: !15, size: 128, align: 32, elements: !38, identifier: "be8b943514833cc5ed230ea491bf84d2::Done")
!516 = !DIDerivedType(tag: DW_TAG_member, name: "Char", scope: !512, file: !15, baseType: !517, size: 128, align: 32, extraData: i64 1)
!517 = !DICompositeType(tag: DW_TAG_structure_type, name: "Char", scope: !510, file: !15, size: 128, align: 32, elements: !518, identifier: "be8b943514833cc5ed230ea491bf84d2::Char")
!518 = !{!519}
!519 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !517, file: !15, baseType: !335, size: 32, align: 32, offset: 32)
!520 = !DIDerivedType(tag: DW_TAG_member, name: "Backslash", scope: !512, file: !15, baseType: !521, size: 128, align: 32, extraData: i64 2)
!521 = !DICompositeType(tag: DW_TAG_structure_type, name: "Backslash", scope: !510, file: !15, size: 128, align: 32, elements: !522, identifier: "be8b943514833cc5ed230ea491bf84d2::Backslash")
!522 = !{!523}
!523 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !521, file: !15, baseType: !335, size: 32, align: 32, offset: 32)
!524 = !DIDerivedType(tag: DW_TAG_member, name: "Unicode", scope: !512, file: !15, baseType: !525, size: 128, align: 32, extraData: i64 3)
!525 = !DICompositeType(tag: DW_TAG_structure_type, name: "Unicode", scope: !510, file: !15, size: 128, align: 32, elements: !526, identifier: "be8b943514833cc5ed230ea491bf84d2::Unicode")
!526 = !{!527}
!527 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !525, file: !15, baseType: !528, size: 96, align: 32, offset: 32)
!528 = !DICompositeType(tag: DW_TAG_structure_type, name: "EscapeUnicode", scope: !210, file: !15, size: 96, align: 32, elements: !529, identifier: "437d68c06a03cbf9260742b59d551a92")
!529 = !{!530, !531, !532}
!530 = !DIDerivedType(tag: DW_TAG_member, name: "c", scope: !528, file: !15, baseType: !335, size: 32, align: 32)
!531 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !528, file: !15, baseType: !214, size: 8, align: 8, offset: 64)
!532 = !DIDerivedType(tag: DW_TAG_member, name: "hex_digit_idx", scope: !528, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!533 = !DIDerivedType(tag: DW_TAG_member, scope: !210, file: !15, baseType: !75, size: 32, align: 32, flags: DIFlagArtificial)
!534 = !DIGlobalVariableExpression(var: !535, expr: !DIExpression())
!535 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !536, isLocal: true, isDefinition: true)
!536 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !537, identifier: "vtable")
!537 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::char::EscapeUnicode", baseType: !528, size: 32, align: 32)
!538 = !DIGlobalVariableExpression(var: !539, expr: !DIExpression())
!539 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !540, isLocal: true, isDefinition: true)
!540 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !541, identifier: "vtable")
!541 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::char::EscapeDefault", baseType: !542, size: 32, align: 32)
!542 = !DICompositeType(tag: DW_TAG_structure_type, name: "EscapeDefault", scope: !210, file: !15, size: 128, align: 32, elements: !543, identifier: "53d098f359486f2b357502b0e7f5c5c5")
!543 = !{!544}
!544 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !542, file: !15, baseType: !510, size: 128, align: 32)
!545 = !DIGlobalVariableExpression(var: !546, expr: !DIExpression())
!546 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !547, isLocal: true, isDefinition: true)
!547 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !548, identifier: "vtable")
!548 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::char::CaseMappingIter", baseType: !549, size: 32, align: 32)
!549 = !DICompositeType(tag: DW_TAG_structure_type, name: "CaseMappingIter", scope: !210, file: !15, size: 128, align: 32, elements: !550, identifier: "ff47fb3c5c5c0d3beb445a6c8469daf")
!550 = !{!551}
!551 = !DICompositeType(tag: DW_TAG_variant_part, scope: !210, file: !15, size: 128, align: 32, elements: !552, identifier: "ff47fb3c5c5c0d3beb445a6c8469daf", discriminator: !533)
!552 = !{!553, !559, !564, !568}
!553 = !DIDerivedType(tag: DW_TAG_member, name: "Three", scope: !551, file: !15, baseType: !554, size: 128, align: 32, extraData: i64 0)
!554 = !DICompositeType(tag: DW_TAG_structure_type, name: "Three", scope: !549, file: !15, size: 128, align: 32, elements: !555, identifier: "ff47fb3c5c5c0d3beb445a6c8469daf::Three")
!555 = !{!556, !557, !558}
!556 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !554, file: !15, baseType: !335, size: 32, align: 32, offset: 32)
!557 = !DIDerivedType(tag: DW_TAG_member, name: "__1", scope: !554, file: !15, baseType: !335, size: 32, align: 32, offset: 64)
!558 = !DIDerivedType(tag: DW_TAG_member, name: "__2", scope: !554, file: !15, baseType: !335, size: 32, align: 32, offset: 96)
!559 = !DIDerivedType(tag: DW_TAG_member, name: "Two", scope: !551, file: !15, baseType: !560, size: 128, align: 32, extraData: i64 1)
!560 = !DICompositeType(tag: DW_TAG_structure_type, name: "Two", scope: !549, file: !15, size: 128, align: 32, elements: !561, identifier: "ff47fb3c5c5c0d3beb445a6c8469daf::Two")
!561 = !{!562, !563}
!562 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !560, file: !15, baseType: !335, size: 32, align: 32, offset: 32)
!563 = !DIDerivedType(tag: DW_TAG_member, name: "__1", scope: !560, file: !15, baseType: !335, size: 32, align: 32, offset: 64)
!564 = !DIDerivedType(tag: DW_TAG_member, name: "One", scope: !551, file: !15, baseType: !565, size: 128, align: 32, extraData: i64 2)
!565 = !DICompositeType(tag: DW_TAG_structure_type, name: "One", scope: !549, file: !15, size: 128, align: 32, elements: !566, identifier: "ff47fb3c5c5c0d3beb445a6c8469daf::One")
!566 = !{!567}
!567 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !565, file: !15, baseType: !335, size: 32, align: 32, offset: 32)
!568 = !DIDerivedType(tag: DW_TAG_member, name: "Zero", scope: !551, file: !15, baseType: !569, size: 128, align: 32, extraData: i64 3)
!569 = !DICompositeType(tag: DW_TAG_structure_type, name: "Zero", scope: !549, file: !15, size: 128, align: 32, elements: !38, identifier: "ff47fb3c5c5c0d3beb445a6c8469daf::Zero")
!570 = !DIGlobalVariableExpression(var: !571, expr: !DIExpression())
!571 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !572, isLocal: true, isDefinition: true)
!572 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !573, identifier: "vtable")
!573 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&&Any", baseType: !574, size: 32, align: 32)
!574 = !DICompositeType(tag: DW_TAG_structure_type, name: "&Any", scope: !575, file: !15, size: 64, align: 32, elements: !576, identifier: "e55f3655b574c38c8dbedec6ab269506")
!575 = !DINamespace(name: "any", scope: !43)
!576 = !{!577, !578}
!577 = !DIDerivedType(tag: DW_TAG_member, name: "pointer", scope: !574, file: !15, baseType: !414, size: 32, align: 32, flags: DIFlagArtificial)
!578 = !DIDerivedType(tag: DW_TAG_member, name: "vtable", scope: !574, file: !15, baseType: !416, size: 32, align: 32, offset: 32, flags: DIFlagArtificial)
!579 = !DIGlobalVariableExpression(var: !580, expr: !DIExpression())
!580 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !581, isLocal: true, isDefinition: true)
!581 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !582, identifier: "vtable")
!582 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::option::Option<&core::fmt::Arguments>", baseType: !583, size: 32, align: 32)
!583 = !DICompositeType(tag: DW_TAG_structure_type, name: "Option<&core::fmt::Arguments>", scope: !94, file: !15, size: 32, align: 32, elements: !584, identifier: "f58e0edc219742098357ee06d0af5693")
!584 = !{!585}
!585 = !DICompositeType(tag: DW_TAG_variant_part, scope: !94, file: !15, size: 32, align: 32, elements: !586, identifier: "f58e0edc219742098357ee06d0af5693", discriminator: !656)
!586 = !{!587, !589}
!587 = !DIDerivedType(tag: DW_TAG_member, name: "None", scope: !585, file: !15, baseType: !588, size: 32, align: 32, extraData: i64 0)
!588 = !DICompositeType(tag: DW_TAG_structure_type, name: "None", scope: !583, file: !15, size: 32, align: 32, elements: !38, identifier: "f58e0edc219742098357ee06d0af5693::None")
!589 = !DIDerivedType(tag: DW_TAG_member, name: "Some", scope: !585, file: !15, baseType: !590, size: 32, align: 32)
!590 = !DICompositeType(tag: DW_TAG_structure_type, name: "Some", scope: !583, file: !15, size: 32, align: 32, elements: !591, identifier: "f58e0edc219742098357ee06d0af5693::Some")
!591 = !{!592}
!592 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !590, file: !15, baseType: !593, size: 32, align: 32)
!593 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::fmt::Arguments", baseType: !594, size: 32, align: 32)
!594 = !DICompositeType(tag: DW_TAG_structure_type, name: "Arguments", scope: !51, file: !15, size: 192, align: 32, elements: !595, identifier: "a2582b2167f281e2d2971df01c446b66")
!595 = !{!596, !602, !657}
!596 = !DIDerivedType(tag: DW_TAG_member, name: "pieces", scope: !594, file: !15, baseType: !597, size: 64, align: 32)
!597 = !DICompositeType(tag: DW_TAG_structure_type, name: "&[&str]", file: !15, size: 64, align: 32, elements: !598, identifier: "6dc4ddb2dbcf2912a5f3983b5bf0572")
!598 = !{!599, !601}
!599 = !DIDerivedType(tag: DW_TAG_member, name: "data_ptr", scope: !597, file: !15, baseType: !600, size: 32, align: 32)
!600 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*const &str", baseType: !328, size: 32, align: 32)
!601 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !597, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!602 = !DIDerivedType(tag: DW_TAG_member, name: "fmt", scope: !594, file: !15, baseType: !603, size: 64, align: 32, offset: 64)
!603 = !DICompositeType(tag: DW_TAG_structure_type, name: "Option<&[core::fmt::rt::v1::Argument]>", scope: !94, file: !15, size: 64, align: 32, elements: !604, identifier: "205521da2f9e61e1e82dfe3b8ecbff8e")
!604 = !{!605}
!605 = !DICompositeType(tag: DW_TAG_variant_part, scope: !94, file: !15, size: 64, align: 32, elements: !606, identifier: "205521da2f9e61e1e82dfe3b8ecbff8e", discriminator: !656)
!606 = !{!607, !609}
!607 = !DIDerivedType(tag: DW_TAG_member, name: "None", scope: !605, file: !15, baseType: !608, size: 64, align: 32, extraData: i64 0)
!608 = !DICompositeType(tag: DW_TAG_structure_type, name: "None", scope: !603, file: !15, size: 64, align: 32, elements: !38, identifier: "205521da2f9e61e1e82dfe3b8ecbff8e::None")
!609 = !DIDerivedType(tag: DW_TAG_member, name: "Some", scope: !605, file: !15, baseType: !610, size: 64, align: 32)
!610 = !DICompositeType(tag: DW_TAG_structure_type, name: "Some", scope: !603, file: !15, size: 64, align: 32, elements: !611, identifier: "205521da2f9e61e1e82dfe3b8ecbff8e::Some")
!611 = !{!612}
!612 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !610, file: !15, baseType: !613, size: 64, align: 32)
!613 = !DICompositeType(tag: DW_TAG_structure_type, name: "&[core::fmt::rt::v1::Argument]", file: !15, size: 64, align: 32, elements: !614, identifier: "557073d9d26373db1d584e778b6995d9")
!614 = !{!615, !655}
!615 = !DIDerivedType(tag: DW_TAG_member, name: "data_ptr", scope: !613, file: !15, baseType: !616, size: 32, align: 32)
!616 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*const core::fmt::rt::v1::Argument", baseType: !617, size: 32, align: 32)
!617 = !DICompositeType(tag: DW_TAG_structure_type, name: "Argument", scope: !49, file: !15, size: 288, align: 32, elements: !618, identifier: "ae6a81863408e78c1f432efadd0b7b03")
!618 = !{!619, !631}
!619 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !617, file: !15, baseType: !620, size: 64, align: 32)
!620 = !DICompositeType(tag: DW_TAG_structure_type, name: "Position", scope: !49, file: !15, size: 64, align: 32, elements: !621, identifier: "4a091e33871e22a211b277fcd941c352")
!621 = !{!622}
!622 = !DICompositeType(tag: DW_TAG_variant_part, scope: !49, file: !15, size: 64, align: 32, elements: !623, identifier: "4a091e33871e22a211b277fcd941c352", discriminator: !630)
!623 = !{!624, !626}
!624 = !DIDerivedType(tag: DW_TAG_member, name: "Next", scope: !622, file: !15, baseType: !625, size: 64, align: 32, extraData: i64 0)
!625 = !DICompositeType(tag: DW_TAG_structure_type, name: "Next", scope: !620, file: !15, size: 64, align: 32, elements: !38, identifier: "4a091e33871e22a211b277fcd941c352::Next")
!626 = !DIDerivedType(tag: DW_TAG_member, name: "At", scope: !622, file: !15, baseType: !627, size: 64, align: 32, extraData: i64 1)
!627 = !DICompositeType(tag: DW_TAG_structure_type, name: "At", scope: !620, file: !15, size: 64, align: 32, elements: !628, identifier: "4a091e33871e22a211b277fcd941c352::At")
!628 = !{!629}
!629 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !627, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!630 = !DIDerivedType(tag: DW_TAG_member, scope: !49, file: !15, baseType: !75, size: 32, align: 32, flags: DIFlagArtificial)
!631 = !DIDerivedType(tag: DW_TAG_member, name: "format", scope: !617, file: !15, baseType: !632, size: 224, align: 32, offset: 64)
!632 = !DICompositeType(tag: DW_TAG_structure_type, name: "FormatSpec", scope: !49, file: !15, size: 224, align: 32, elements: !633, identifier: "fa44e21fb4b888ff715afedcb693e0c2")
!633 = !{!634, !635, !636, !637, !654}
!634 = !DIDerivedType(tag: DW_TAG_member, name: "fill", scope: !632, file: !15, baseType: !335, size: 32, align: 32)
!635 = !DIDerivedType(tag: DW_TAG_member, name: "align", scope: !632, file: !15, baseType: !48, size: 8, align: 8, offset: 192)
!636 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !632, file: !15, baseType: !75, size: 32, align: 32, offset: 32)
!637 = !DIDerivedType(tag: DW_TAG_member, name: "precision", scope: !632, file: !15, baseType: !638, size: 64, align: 32, offset: 64)
!638 = !DICompositeType(tag: DW_TAG_structure_type, name: "Count", scope: !49, file: !15, size: 64, align: 32, elements: !639, identifier: "d897a2b747764cbd2d8de33955143443")
!639 = !{!640}
!640 = !DICompositeType(tag: DW_TAG_variant_part, scope: !49, file: !15, size: 64, align: 32, elements: !641, identifier: "d897a2b747764cbd2d8de33955143443", discriminator: !630)
!641 = !{!642, !646, !650, !652}
!642 = !DIDerivedType(tag: DW_TAG_member, name: "Is", scope: !640, file: !15, baseType: !643, size: 64, align: 32, extraData: i64 0)
!643 = !DICompositeType(tag: DW_TAG_structure_type, name: "Is", scope: !638, file: !15, size: 64, align: 32, elements: !644, identifier: "d897a2b747764cbd2d8de33955143443::Is")
!644 = !{!645}
!645 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !643, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!646 = !DIDerivedType(tag: DW_TAG_member, name: "Param", scope: !640, file: !15, baseType: !647, size: 64, align: 32, extraData: i64 1)
!647 = !DICompositeType(tag: DW_TAG_structure_type, name: "Param", scope: !638, file: !15, size: 64, align: 32, elements: !648, identifier: "d897a2b747764cbd2d8de33955143443::Param")
!648 = !{!649}
!649 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !647, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!650 = !DIDerivedType(tag: DW_TAG_member, name: "NextParam", scope: !640, file: !15, baseType: !651, size: 64, align: 32, extraData: i64 2)
!651 = !DICompositeType(tag: DW_TAG_structure_type, name: "NextParam", scope: !638, file: !15, size: 64, align: 32, elements: !38, identifier: "d897a2b747764cbd2d8de33955143443::NextParam")
!652 = !DIDerivedType(tag: DW_TAG_member, name: "Implied", scope: !640, file: !15, baseType: !653, size: 64, align: 32, extraData: i64 3)
!653 = !DICompositeType(tag: DW_TAG_structure_type, name: "Implied", scope: !638, file: !15, size: 64, align: 32, elements: !38, identifier: "d897a2b747764cbd2d8de33955143443::Implied")
!654 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !632, file: !15, baseType: !638, size: 64, align: 32, offset: 128)
!655 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !613, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!656 = !DIDerivedType(tag: DW_TAG_member, scope: !94, file: !15, baseType: !75, size: 32, align: 32, flags: DIFlagArtificial)
!657 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !594, file: !15, baseType: !658, size: 64, align: 32, offset: 128)
!658 = !DICompositeType(tag: DW_TAG_structure_type, name: "&[core::fmt::ArgumentV1]", file: !15, size: 64, align: 32, elements: !659, identifier: "70d56a9e31a5c3cadfe594057e1fdbbf")
!659 = !{!660, !702}
!660 = !DIDerivedType(tag: DW_TAG_member, name: "data_ptr", scope: !658, file: !15, baseType: !661, size: 32, align: 32)
!661 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*const core::fmt::ArgumentV1", baseType: !662, size: 32, align: 32)
!662 = !DICompositeType(tag: DW_TAG_structure_type, name: "ArgumentV1", scope: !51, file: !15, size: 64, align: 32, elements: !663, identifier: "2ba0d92697d197dedcc10959d4bd8f0")
!663 = !{!664, !671}
!664 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !662, file: !15, baseType: !665, size: 32, align: 32)
!665 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::fmt::Void", baseType: !666, size: 32, align: 32)
!666 = !DICompositeType(tag: DW_TAG_structure_type, name: "Void", scope: !51, file: !15, align: 8, elements: !667, identifier: "dfa60ce130fe7076595b932dddde3417")
!667 = !{!668, !669}
!668 = !DIDerivedType(tag: DW_TAG_member, name: "_priv", scope: !666, file: !15, baseType: !4, align: 8)
!669 = !DIDerivedType(tag: DW_TAG_member, name: "_oibit_remover", scope: !666, file: !15, baseType: !670, align: 8)
!670 = !DICompositeType(tag: DW_TAG_structure_type, name: "PhantomData<*mut Fn<()>>", scope: !377, file: !15, align: 8, elements: !38, identifier: "ef68e39b7ba1a3bab616d35ffb7109cb")
!671 = !DIDerivedType(tag: DW_TAG_member, name: "formatter", scope: !662, file: !15, baseType: !672, size: 32, align: 32, offset: 32)
!672 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "fn(&core::fmt::Void, &mut core::fmt::Formatter) -> core::result::Result<(), core::fmt::Error>", baseType: !673, size: 32, align: 32)
!673 = !DISubroutineType(types: !674)
!674 = !{!41, !665, !675}
!675 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&mut core::fmt::Formatter", baseType: !676, size: 32, align: 32)
!676 = !DICompositeType(tag: DW_TAG_structure_type, name: "Formatter", scope: !51, file: !15, size: 416, align: 32, elements: !677, identifier: "9e46afe4c8983886659111910fc3c318")
!677 = !{!678, !679, !680, !681, !692, !693, !694, !701}
!678 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !676, file: !15, baseType: !75, size: 32, align: 32)
!679 = !DIDerivedType(tag: DW_TAG_member, name: "fill", scope: !676, file: !15, baseType: !335, size: 32, align: 32, offset: 32)
!680 = !DIDerivedType(tag: DW_TAG_member, name: "align", scope: !676, file: !15, baseType: !48, size: 8, align: 8, offset: 384)
!681 = !DIDerivedType(tag: DW_TAG_member, name: "width", scope: !676, file: !15, baseType: !682, size: 64, align: 32, offset: 64)
!682 = !DICompositeType(tag: DW_TAG_structure_type, name: "Option<usize>", scope: !94, file: !15, size: 64, align: 32, elements: !683, identifier: "5c2135ffea288805b4e962188bac1c29")
!683 = !{!684}
!684 = !DICompositeType(tag: DW_TAG_variant_part, scope: !94, file: !15, size: 64, align: 32, elements: !685, identifier: "5c2135ffea288805b4e962188bac1c29", discriminator: !656)
!685 = !{!686, !688}
!686 = !DIDerivedType(tag: DW_TAG_member, name: "None", scope: !684, file: !15, baseType: !687, size: 64, align: 32, extraData: i64 0)
!687 = !DICompositeType(tag: DW_TAG_structure_type, name: "None", scope: !682, file: !15, size: 64, align: 32, elements: !38, identifier: "5c2135ffea288805b4e962188bac1c29::None")
!688 = !DIDerivedType(tag: DW_TAG_member, name: "Some", scope: !684, file: !15, baseType: !689, size: 64, align: 32, extraData: i64 1)
!689 = !DICompositeType(tag: DW_TAG_structure_type, name: "Some", scope: !682, file: !15, size: 64, align: 32, elements: !690, identifier: "5c2135ffea288805b4e962188bac1c29::Some")
!690 = !{!691}
!691 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !689, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!692 = !DIDerivedType(tag: DW_TAG_member, name: "precision", scope: !676, file: !15, baseType: !682, size: 64, align: 32, offset: 128)
!693 = !DIDerivedType(tag: DW_TAG_member, name: "buf", scope: !676, file: !15, baseType: !411, size: 64, align: 32, offset: 192)
!694 = !DIDerivedType(tag: DW_TAG_member, name: "curarg", scope: !676, file: !15, baseType: !695, size: 64, align: 32, offset: 256)
!695 = !DICompositeType(tag: DW_TAG_structure_type, name: "Iter<core::fmt::ArgumentV1>", scope: !299, file: !15, size: 64, align: 32, elements: !696, identifier: "2fae940d5f7e7edcc450a9284595c36b")
!696 = !{!697, !698, !699}
!697 = !DIDerivedType(tag: DW_TAG_member, name: "ptr", scope: !695, file: !15, baseType: !661, size: 32, align: 32)
!698 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !695, file: !15, baseType: !661, size: 32, align: 32, offset: 32)
!699 = !DIDerivedType(tag: DW_TAG_member, name: "_marker", scope: !695, file: !15, baseType: !700, align: 8)
!700 = !DICompositeType(tag: DW_TAG_structure_type, name: "PhantomData<&core::fmt::ArgumentV1>", scope: !377, file: !15, align: 8, elements: !38, identifier: "9d6979d6a8797bc4a67093ff57c16f4")
!701 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !676, file: !15, baseType: !658, size: 64, align: 32, offset: 320)
!702 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !658, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!703 = !DIGlobalVariableExpression(var: !704, expr: !DIExpression())
!704 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !705, isLocal: true, isDefinition: true)
!705 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !706, identifier: "vtable")
!706 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::panic::Location", baseType: !707, size: 32, align: 32)
!707 = !DICompositeType(tag: DW_TAG_structure_type, name: "Location", scope: !290, file: !15, size: 128, align: 32, elements: !708, identifier: "7e2717e4f739a44e121af42214c076e")
!708 = !{!709, !710, !711}
!709 = !DIDerivedType(tag: DW_TAG_member, name: "file", scope: !707, file: !15, baseType: !328, size: 64, align: 32)
!710 = !DIDerivedType(tag: DW_TAG_member, name: "line", scope: !707, file: !15, baseType: !75, size: 32, align: 32, offset: 64)
!711 = !DIDerivedType(tag: DW_TAG_member, name: "col", scope: !707, file: !15, baseType: !75, size: 32, align: 32, offset: 96)
!712 = !DIGlobalVariableExpression(var: !713, expr: !DIExpression())
!713 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !714, isLocal: true, isDefinition: true)
!714 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !715, identifier: "vtable")
!715 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&&str", baseType: !328, size: 32, align: 32)
!716 = !DIGlobalVariableExpression(var: !717, expr: !DIExpression())
!717 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !170, isLocal: true, isDefinition: true)
!718 = !DIGlobalVariableExpression(var: !719, expr: !DIExpression())
!719 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !720, isLocal: true, isDefinition: true)
!720 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !721, identifier: "vtable")
!721 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::slice::Iter<u8>", baseType: !371, size: 32, align: 32)
!722 = !DIGlobalVariableExpression(var: !723, expr: !DIExpression())
!723 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !724, isLocal: true, isDefinition: true)
!724 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !725, identifier: "vtable")
!725 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&&core::fmt::Arguments", baseType: !593, size: 32, align: 32)
!726 = !DIGlobalVariableExpression(var: !727, expr: !DIExpression())
!727 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !728, isLocal: true, isDefinition: true)
!728 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !729, identifier: "vtable")
!729 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&[u8; 4]", baseType: !338, size: 32, align: 32)
!730 = !DIGlobalVariableExpression(var: !731, expr: !DIExpression())
!731 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !732, isLocal: true, isDefinition: true)
!732 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !733, identifier: "vtable")
!733 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&&[char]", baseType: !734, size: 32, align: 32)
!734 = !DICompositeType(tag: DW_TAG_structure_type, name: "&[char]", file: !15, size: 64, align: 32, elements: !735, identifier: "16f8db883ed191d4c91b9485bb15ac7")
!735 = !{!736, !738}
!736 = !DIDerivedType(tag: DW_TAG_member, name: "data_ptr", scope: !734, file: !15, baseType: !737, size: 32, align: 32)
!737 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*const char", baseType: !335, size: 32, align: 32)
!738 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !734, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!739 = !DIGlobalVariableExpression(var: !740, expr: !DIExpression())
!740 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !741, isLocal: true, isDefinition: true)
!741 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !742, identifier: "vtable")
!742 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::CharIndices", baseType: !364, size: 32, align: 32)
!743 = !DIGlobalVariableExpression(var: !744, expr: !DIExpression())
!744 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !745, isLocal: true, isDefinition: true)
!745 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !746, identifier: "vtable")
!746 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::pattern::MultiCharEqSearcher<&[char]>", baseType: !747, size: 32, align: 32)
!747 = !DICompositeType(tag: DW_TAG_structure_type, name: "MultiCharEqSearcher<&[char]>", scope: !325, file: !15, size: 224, align: 32, elements: !748, identifier: "afd7de97dd8482d9dfe93a6fb318a62")
!748 = !{!749, !750, !751}
!749 = !DIDerivedType(tag: DW_TAG_member, name: "char_eq", scope: !747, file: !15, baseType: !734, size: 64, align: 32)
!750 = !DIDerivedType(tag: DW_TAG_member, name: "haystack", scope: !747, file: !15, baseType: !328, size: 64, align: 32, offset: 64)
!751 = !DIDerivedType(tag: DW_TAG_member, name: "char_indices", scope: !747, file: !15, baseType: !364, size: 96, align: 32, offset: 128)
!752 = !DIGlobalVariableExpression(var: !753, expr: !DIExpression())
!753 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !754, isLocal: true, isDefinition: true)
!754 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !755, identifier: "vtable")
!755 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::pattern::StrSearcherImpl", baseType: !756, size: 32, align: 32)
!756 = !DICompositeType(tag: DW_TAG_structure_type, name: "StrSearcherImpl", scope: !325, file: !15, size: 384, align: 64, elements: !757, identifier: "f1529eea58dc2ea5c40a294609d3862")
!757 = !{!758}
!758 = !DICompositeType(tag: DW_TAG_variant_part, scope: !325, file: !15, size: 384, align: 64, elements: !759, identifier: "f1529eea58dc2ea5c40a294609d3862", discriminator: !784)
!759 = !{!760, !770}
!760 = !DIDerivedType(tag: DW_TAG_member, name: "Empty", scope: !758, file: !15, baseType: !761, size: 384, align: 64, extraData: i64 0)
!761 = !DICompositeType(tag: DW_TAG_structure_type, name: "Empty", scope: !756, file: !15, size: 384, align: 64, elements: !762, identifier: "f1529eea58dc2ea5c40a294609d3862::Empty")
!762 = !{!763}
!763 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !761, file: !15, baseType: !764, size: 96, align: 32, offset: 32)
!764 = !DICompositeType(tag: DW_TAG_structure_type, name: "EmptyNeedle", scope: !325, file: !15, size: 96, align: 32, elements: !765, identifier: "fd44929d422be99a819762e180d4d7c1")
!765 = !{!766, !767, !768, !769}
!766 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !764, file: !15, baseType: !22, size: 32, align: 32)
!767 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !764, file: !15, baseType: !22, size: 32, align: 32, offset: 32)
!768 = !DIDerivedType(tag: DW_TAG_member, name: "is_match_fw", scope: !764, file: !15, baseType: !35, size: 8, align: 8, offset: 64)
!769 = !DIDerivedType(tag: DW_TAG_member, name: "is_match_bw", scope: !764, file: !15, baseType: !35, size: 8, align: 8, offset: 72)
!770 = !DIDerivedType(tag: DW_TAG_member, name: "TwoWay", scope: !758, file: !15, baseType: !771, size: 384, align: 64, extraData: i64 1)
!771 = !DICompositeType(tag: DW_TAG_structure_type, name: "TwoWay", scope: !756, file: !15, size: 384, align: 64, elements: !772, identifier: "f1529eea58dc2ea5c40a294609d3862::TwoWay")
!772 = !{!773}
!773 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !771, file: !15, baseType: !774, size: 320, align: 64, offset: 64)
!774 = !DICompositeType(tag: DW_TAG_structure_type, name: "TwoWaySearcher", scope: !325, file: !15, size: 320, align: 64, elements: !775, identifier: "e25676f9951e839d61593dd6b9c08846")
!775 = !{!776, !777, !778, !779, !780, !781, !782, !783}
!776 = !DIDerivedType(tag: DW_TAG_member, name: "crit_pos", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 64)
!777 = !DIDerivedType(tag: DW_TAG_member, name: "crit_pos_back", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 96)
!778 = !DIDerivedType(tag: DW_TAG_member, name: "period", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 128)
!779 = !DIDerivedType(tag: DW_TAG_member, name: "byteset", scope: !774, file: !15, baseType: !265, size: 64, align: 64)
!780 = !DIDerivedType(tag: DW_TAG_member, name: "position", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 160)
!781 = !DIDerivedType(tag: DW_TAG_member, name: "end", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 192)
!782 = !DIDerivedType(tag: DW_TAG_member, name: "memory", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 224)
!783 = !DIDerivedType(tag: DW_TAG_member, name: "memory_back", scope: !774, file: !15, baseType: !22, size: 32, align: 32, offset: 256)
!784 = !DIDerivedType(tag: DW_TAG_member, scope: !325, file: !15, baseType: !75, size: 32, align: 32, flags: DIFlagArtificial)
!785 = !DIGlobalVariableExpression(var: !786, expr: !DIExpression())
!786 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !787, isLocal: true, isDefinition: true)
!787 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !788, identifier: "vtable")
!788 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::pattern::TwoWaySearcher", baseType: !774, size: 32, align: 32)
!789 = !DIGlobalVariableExpression(var: !790, expr: !DIExpression())
!790 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !791, isLocal: true, isDefinition: true)
!791 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !792, identifier: "vtable")
!792 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::pattern::EmptyNeedle", baseType: !764, size: 32, align: 32)
!793 = !DIGlobalVariableExpression(var: !794, expr: !DIExpression())
!794 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !795, isLocal: true, isDefinition: true)
!795 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !796, identifier: "vtable")
!796 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::option::Option<u8>", baseType: !797, size: 32, align: 32)
!797 = !DICompositeType(tag: DW_TAG_structure_type, name: "Option<u8>", scope: !94, file: !15, size: 16, align: 8, elements: !798, identifier: "1aa2a604117e75f8cd211359830ef8ad")
!798 = !{!799}
!799 = !DICompositeType(tag: DW_TAG_variant_part, scope: !94, file: !15, size: 16, align: 8, elements: !800, identifier: "1aa2a604117e75f8cd211359830ef8ad", discriminator: !807)
!800 = !{!801, !803}
!801 = !DIDerivedType(tag: DW_TAG_member, name: "None", scope: !799, file: !15, baseType: !802, size: 16, align: 8, extraData: i64 0)
!802 = !DICompositeType(tag: DW_TAG_structure_type, name: "None", scope: !797, file: !15, size: 16, align: 8, elements: !38, identifier: "1aa2a604117e75f8cd211359830ef8ad::None")
!803 = !DIDerivedType(tag: DW_TAG_member, name: "Some", scope: !799, file: !15, baseType: !804, size: 16, align: 8, extraData: i64 1)
!804 = !DICompositeType(tag: DW_TAG_structure_type, name: "Some", scope: !797, file: !15, size: 16, align: 8, elements: !805, identifier: "1aa2a604117e75f8cd211359830ef8ad::Some")
!805 = !{!806}
!806 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !804, file: !15, baseType: !44, size: 8, align: 8, offset: 8)
!807 = !DIDerivedType(tag: DW_TAG_member, scope: !94, file: !15, baseType: !44, size: 8, align: 8, flags: DIFlagArtificial)
!808 = !DIGlobalVariableExpression(var: !809, expr: !DIExpression())
!809 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !810, isLocal: true, isDefinition: true)
!810 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !811, identifier: "vtable")
!811 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::Chars", baseType: !368, size: 32, align: 32)
!812 = !DIGlobalVariableExpression(var: !813, expr: !DIExpression())
!813 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !814, isLocal: true, isDefinition: true)
!814 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !815, identifier: "vtable")
!815 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::iter::Cloned<core::slice::Iter<u8>>", baseType: !816, size: 32, align: 32)
!816 = !DICompositeType(tag: DW_TAG_structure_type, name: "Cloned<core::slice::Iter<u8>>", scope: !295, file: !15, size: 64, align: 32, elements: !817, identifier: "bebadad333575f43de1f4e510eaed94c")
!817 = !{!818}
!818 = !DIDerivedType(tag: DW_TAG_member, name: "it", scope: !816, file: !15, baseType: !371, size: 64, align: 32)
!819 = !DIGlobalVariableExpression(var: !820, expr: !DIExpression())
!820 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !821, isLocal: true, isDefinition: true)
!821 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !350, identifier: "vtable")
!822 = !DIGlobalVariableExpression(var: !823, expr: !DIExpression())
!823 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !824, isLocal: true, isDefinition: true)
!824 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !319, identifier: "vtable")
!825 = !DIGlobalVariableExpression(var: !826, expr: !DIExpression())
!826 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !827, isLocal: true, isDefinition: true)
!827 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !828, identifier: "vtable")
!828 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::iter::Map<core::str::SplitTerminator<char>, core::str::LinesAnyMap>", baseType: !829, size: 32, align: 32)
!829 = !DICompositeType(tag: DW_TAG_structure_type, name: "Map<core::str::SplitTerminator<char>, core::str::LinesAnyMap>", scope: !295, file: !15, size: 320, align: 32, elements: !830, identifier: "83ed8fc1c55eb84dfb3daf599bcfef42")
!830 = !{!831, !832}
!831 = !DIDerivedType(tag: DW_TAG_member, name: "iter", scope: !829, file: !15, baseType: !316, size: 320, align: 32)
!832 = !DIDerivedType(tag: DW_TAG_member, name: "f", scope: !829, file: !15, baseType: !833, align: 8)
!833 = !DICompositeType(tag: DW_TAG_structure_type, name: "LinesAnyMap", scope: !309, file: !15, align: 8, elements: !38, identifier: "63568bfff7f4e4f6978e56238a666b62")
!834 = !DIGlobalVariableExpression(var: !835, expr: !DIExpression())
!835 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !836, isLocal: true, isDefinition: true)
!836 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !837, identifier: "vtable")
!837 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::str::Lines", baseType: !838, size: 32, align: 32)
!838 = !DICompositeType(tag: DW_TAG_structure_type, name: "Lines", scope: !309, file: !15, size: 320, align: 32, elements: !839, identifier: "fbfa73676284e1aa774218a45dd64175")
!839 = !{!840}
!840 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !838, file: !15, baseType: !829, size: 320, align: 32)
!841 = !DIGlobalVariableExpression(var: !842, expr: !DIExpression())
!842 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !843, isLocal: true, isDefinition: true)
!843 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !844, identifier: "vtable")
!844 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::iter::Filter<core::str::Split<core::str::IsWhitespace>, core::str::IsNotEmpty>", baseType: !845, size: 32, align: 32)
!845 = !DICompositeType(tag: DW_TAG_structure_type, name: "Filter<core::str::Split<core::str::IsWhitespace>, core::str::IsNotEmpty>", scope: !295, file: !15, size: 256, align: 32, elements: !846, identifier: "c8ffda816b668581fded3d3a9b41de80")
!846 = !{!847, !848}
!847 = !DIDerivedType(tag: DW_TAG_member, name: "iter", scope: !845, file: !15, baseType: !347, size: 256, align: 32)
!848 = !DIDerivedType(tag: DW_TAG_member, name: "predicate", scope: !845, file: !15, baseType: !312, align: 8)
!849 = !DIGlobalVariableExpression(var: !850, expr: !DIExpression())
!850 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !851, isLocal: true, isDefinition: true)
!851 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !852, identifier: "vtable")
!852 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::iter::Map<core::iter::Filter<core::slice::Split<u8, core::str::IsAsciiWhitespace>, core::str::IsNotEmpty>, core::str::UnsafeBytesToStr>", baseType: !853, size: 32, align: 32)
!853 = !DICompositeType(tag: DW_TAG_structure_type, name: "Map<core::iter::Filter<core::slice::Split<u8, core::str::IsAsciiWhitespace>, core::str::IsNotEmpty>, core::str::UnsafeBytesToStr>", scope: !295, file: !15, size: 96, align: 32, elements: !854, identifier: "c7fdf8157f4f9debcb5692f9c946eebb")
!854 = !{!855, !856}
!855 = !DIDerivedType(tag: DW_TAG_member, name: "iter", scope: !853, file: !15, baseType: !294, size: 96, align: 32)
!856 = !DIDerivedType(tag: DW_TAG_member, name: "f", scope: !853, file: !15, baseType: !857, align: 8)
!857 = !DICompositeType(tag: DW_TAG_structure_type, name: "UnsafeBytesToStr", scope: !309, file: !15, align: 8, elements: !38, identifier: "657ab7b4e830993572a3db0d4b1097ec")
!858 = !DIGlobalVariableExpression(var: !859, expr: !DIExpression())
!859 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !860, isLocal: true, isDefinition: true)
!860 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !861, identifier: "vtable")
!861 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::hash::sip::Hasher<core::hash::sip::Sip13Rounds>", baseType: !862, size: 32, align: 32)
!862 = !DICompositeType(tag: DW_TAG_structure_type, name: "Hasher<core::hash::sip::Sip13Rounds>", scope: !863, file: !15, size: 512, align: 64, elements: !865, identifier: "553f095bdcdbb40635d2a015ba710533")
!863 = !DINamespace(name: "sip", scope: !864)
!864 = !DINamespace(name: "hash", scope: !43)
!865 = !{!866, !867, !868, !869, !876, !877, !878}
!866 = !DIDerivedType(tag: DW_TAG_member, name: "k0", scope: !862, file: !15, baseType: !265, size: 64, align: 64)
!867 = !DIDerivedType(tag: DW_TAG_member, name: "k1", scope: !862, file: !15, baseType: !265, size: 64, align: 64, offset: 64)
!868 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !862, file: !15, baseType: !22, size: 32, align: 32, offset: 448)
!869 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !862, file: !15, baseType: !870, size: 256, align: 64, offset: 128)
!870 = !DICompositeType(tag: DW_TAG_structure_type, name: "State", scope: !863, file: !15, size: 256, align: 64, elements: !871, identifier: "7b2a43173703f26f79b1ed86364e006e")
!871 = !{!872, !873, !874, !875}
!872 = !DIDerivedType(tag: DW_TAG_member, name: "v0", scope: !870, file: !15, baseType: !265, size: 64, align: 64)
!873 = !DIDerivedType(tag: DW_TAG_member, name: "v2", scope: !870, file: !15, baseType: !265, size: 64, align: 64, offset: 64)
!874 = !DIDerivedType(tag: DW_TAG_member, name: "v1", scope: !870, file: !15, baseType: !265, size: 64, align: 64, offset: 128)
!875 = !DIDerivedType(tag: DW_TAG_member, name: "v3", scope: !870, file: !15, baseType: !265, size: 64, align: 64, offset: 192)
!876 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !862, file: !15, baseType: !265, size: 64, align: 64, offset: 384)
!877 = !DIDerivedType(tag: DW_TAG_member, name: "ntail", scope: !862, file: !15, baseType: !22, size: 32, align: 32, offset: 480)
!878 = !DIDerivedType(tag: DW_TAG_member, name: "_marker", scope: !862, file: !15, baseType: !879, align: 8)
!879 = !DICompositeType(tag: DW_TAG_structure_type, name: "PhantomData<core::hash::sip::Sip13Rounds>", scope: !377, file: !15, align: 8, elements: !38, identifier: "89cb10c8d129139286178e41bcf89557")
!880 = !DIGlobalVariableExpression(var: !881, expr: !DIExpression())
!881 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !882, isLocal: true, isDefinition: true)
!882 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !883, identifier: "vtable")
!883 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::hash::sip::Hasher<core::hash::sip::Sip24Rounds>", baseType: !884, size: 32, align: 32)
!884 = !DICompositeType(tag: DW_TAG_structure_type, name: "Hasher<core::hash::sip::Sip24Rounds>", scope: !863, file: !15, size: 512, align: 64, elements: !885, identifier: "969b513c30ad4d8dc69e3e22bb3699d")
!885 = !{!886, !887, !888, !889, !890, !891, !892}
!886 = !DIDerivedType(tag: DW_TAG_member, name: "k0", scope: !884, file: !15, baseType: !265, size: 64, align: 64)
!887 = !DIDerivedType(tag: DW_TAG_member, name: "k1", scope: !884, file: !15, baseType: !265, size: 64, align: 64, offset: 64)
!888 = !DIDerivedType(tag: DW_TAG_member, name: "length", scope: !884, file: !15, baseType: !22, size: 32, align: 32, offset: 448)
!889 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !884, file: !15, baseType: !870, size: 256, align: 64, offset: 128)
!890 = !DIDerivedType(tag: DW_TAG_member, name: "tail", scope: !884, file: !15, baseType: !265, size: 64, align: 64, offset: 384)
!891 = !DIDerivedType(tag: DW_TAG_member, name: "ntail", scope: !884, file: !15, baseType: !22, size: 32, align: 32, offset: 480)
!892 = !DIDerivedType(tag: DW_TAG_member, name: "_marker", scope: !884, file: !15, baseType: !893, align: 8)
!893 = !DICompositeType(tag: DW_TAG_structure_type, name: "PhantomData<core::hash::sip::Sip24Rounds>", scope: !377, file: !15, align: 8, elements: !38, identifier: "374fdfa08585b84dacd752a8c045a937")
!894 = !DIGlobalVariableExpression(var: !895, expr: !DIExpression())
!895 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !896, isLocal: true, isDefinition: true)
!896 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !897, identifier: "vtable")
!897 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::hash::sip::SipHasher24", baseType: !898, size: 32, align: 32)
!898 = !DICompositeType(tag: DW_TAG_structure_type, name: "SipHasher24", scope: !863, file: !15, size: 512, align: 64, elements: !899, identifier: "2786dcf188485c67291b3408bbea888")
!899 = !{!900}
!900 = !DIDerivedType(tag: DW_TAG_member, name: "hasher", scope: !898, file: !15, baseType: !884, size: 512, align: 64)
!901 = !DIGlobalVariableExpression(var: !902, expr: !DIExpression())
!902 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !903, isLocal: true, isDefinition: true)
!903 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !904, identifier: "vtable")
!904 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::hash::sip::State", baseType: !870, size: 32, align: 32)
!905 = !DIGlobalVariableExpression(var: !906, expr: !DIExpression())
!906 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !907, isLocal: true, isDefinition: true)
!907 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !908, identifier: "vtable")
!908 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::marker::PhantomData<core::hash::sip::Sip24Rounds>", baseType: !893, size: 32, align: 32)
!909 = !DIGlobalVariableExpression(var: !910, expr: !DIExpression())
!910 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !911, isLocal: true, isDefinition: true)
!911 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !912, identifier: "vtable")
!912 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::marker::PhantomData<core::hash::sip::Sip13Rounds>", baseType: !879, size: 32, align: 32)
!913 = !DIGlobalVariableExpression(var: !914, expr: !DIExpression())
!914 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !915, isLocal: true, isDefinition: true)
!915 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !916, identifier: "vtable")
!916 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::ptr::NonNull<u8>", baseType: !917, size: 32, align: 32)
!917 = !DICompositeType(tag: DW_TAG_structure_type, name: "NonNull<u8>", scope: !918, file: !15, size: 32, align: 32, elements: !919, identifier: "bf2460b4d944af428787c07832d494c4")
!918 = !DINamespace(name: "ptr", scope: !43)
!919 = !{!920}
!920 = !DIDerivedType(tag: DW_TAG_member, name: "pointer", scope: !917, file: !15, baseType: !921, size: 32, align: 32)
!921 = !DICompositeType(tag: DW_TAG_structure_type, name: "NonZero<*const u8>", scope: !922, file: !15, size: 32, align: 32, elements: !923, identifier: "91adb6a4307ad1da11bb74d4e854bbe1")
!922 = !DINamespace(name: "nonzero", scope: !43)
!923 = !{!924}
!924 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !921, file: !15, baseType: !305, size: 32, align: 32)
!925 = !DIGlobalVariableExpression(var: !926, expr: !DIExpression())
!926 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !927, isLocal: true, isDefinition: true)
!927 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !928, identifier: "vtable")
!928 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&core::num::NonZeroUsize", baseType: !929, size: 32, align: 32)
!929 = !DICompositeType(tag: DW_TAG_structure_type, name: "NonZeroUsize", scope: !188, file: !15, size: 32, align: 32, elements: !930, identifier: "9d94580dc02ae14b4e52289de387ca5e")
!930 = !{!931}
!931 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !929, file: !15, baseType: !932, size: 32, align: 32)
!932 = !DICompositeType(tag: DW_TAG_structure_type, name: "NonZero<usize>", scope: !922, file: !15, size: 32, align: 32, elements: !933, identifier: "3c0e8494fc500e1d125366117e0a2b21")
!933 = !{!934}
!934 = !DIDerivedType(tag: DW_TAG_member, name: "__0", scope: !932, file: !15, baseType: !22, size: 32, align: 32)
!935 = !DIGlobalVariableExpression(var: !936, expr: !DIExpression())
!936 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !937, isLocal: true, isDefinition: true)
!937 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !938, identifier: "vtable")
!938 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&i8", baseType: !939, size: 32, align: 32)
!939 = !DIBasicType(name: "i8", size: 8, encoding: DW_ATE_signed)
!940 = !DIGlobalVariableExpression(var: !941, expr: !DIExpression())
!941 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !942, isLocal: true, isDefinition: true)
!942 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !943, identifier: "vtable")
!943 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&i32", baseType: !944, size: 32, align: 32)
!944 = !DIBasicType(name: "i32", size: 32, encoding: DW_ATE_signed)
!945 = !DIGlobalVariableExpression(var: !946, expr: !DIExpression())
!946 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !947, isLocal: true, isDefinition: true)
!947 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !948, identifier: "vtable")
!948 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&f32", baseType: !949, size: 32, align: 32)
!949 = !DIBasicType(name: "f32", size: 32, encoding: DW_ATE_float)
!950 = !DIGlobalVariableExpression(var: !951, expr: !DIExpression())
!951 = distinct !DIGlobalVariable(name: "vtable", scope: null, file: !15, type: !952, isLocal: true, isDefinition: true)
!952 = !DICompositeType(tag: DW_TAG_structure_type, name: "vtable", file: !15, align: 32, flags: DIFlagArtificial, elements: !38, vtableHolder: !953, identifier: "vtable")
!953 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&f64", baseType: !954, size: 32, align: 32)
!954 = !DIBasicType(name: "f64", size: 64, encoding: DW_ATE_float)
!955 = !{i32 2, !"Debug Info Version", i32 3}
!956 = distinct !DISubprogram(name: "n30206176436048k", linkageName: "main", scope: !957, file: !37, line: 10, type: !8, isLocal: false, isDefinition: true, scopeLine: 10, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true, unit: !36, templateParams: !38, retainedNodes: !38)
!957 = !DINamespace(name: "minimal", scope: null)
!958 = !DILocation(line: 76, column: 12, scope: !959, inlinedAt: !963)
!959 = distinct !DILexicalBlock(scope: !961, file: !960, line: 71, column: 14)
!960 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-0.5.8/src/asm.rs", directory: "")
!961 = distinct !DISubprogram(name: "nop", linkageName: "_ZN8cortex_m3asm3nop17h01ef7c9ce9855b9aE", scope: !962, file: !960, line: 65, type: !19, isLocal: true, isDefinition: true, scopeLine: 65, flags: DIFlagPrototyped, isOptimized: true, unit: !36, templateParams: !38, retainedNodes: !38)
!962 = !DINamespace(name: "asm", scope: !33)
!963 = distinct !DILocation(line: 12, column: 4, scope: !956)
!964 = !DILocation(line: 12, column: 4, scope: !956)
!965 = !DILocation(line: 14, column: 4, scope: !956)
!966 = distinct !DISubprogram(name: "Reset", linkageName: "Reset", scope: !2, file: !3, line: 475, type: !8, isLocal: false, isDefinition: true, scopeLine: 475, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true, unit: !39, templateParams: !38, retainedNodes: !38)
!967 = !DILocation(line: 496, column: 4, scope: !966)
!968 = !DILocalVariable(name: "sbss", arg: 1, scope: !969, file: !977, line: 1, type: !974)
!969 = distinct !DISubprogram(name: "zero_bss<u32>", linkageName: "_ZN2r08zero_bss17h994f67ab99faf6e0E", scope: !971, file: !970, line: 167, type: !972, isLocal: true, isDefinition: true, scopeLine: 167, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !978, retainedNodes: !975)
!970 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/r0-0.2.2/src/lib.rs", directory: "")
!971 = !DINamespace(name: "r0", scope: null)
!972 = !DISubroutineType(types: !973)
!973 = !{null, !974, !974}
!974 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*mut u32", baseType: !75, size: 32, align: 32)
!975 = !{!968, !976}
!976 = !DILocalVariable(name: "ebss", arg: 2, scope: !969, file: !977, line: 1, type: !974)
!977 = !DIFile(filename: "/home/japaric/.cargo/registry/src/github.com-1ecc6299db9ec823/cortex-m-rt-0.6.5/src/lib.rs", directory: "")
!978 = !{!979}
!979 = !DITemplateTypeParameter(name: "T", type: !75)
!980 = !DILocation(line: 1, scope: !969, inlinedAt: !981)
!981 = distinct !DILocation(line: 499, column: 4, scope: !966)
!982 = !DILocation(line: 171, column: 4, scope: !969, inlinedAt: !981)
!983 = !DILocation(line: 946, column: 4, scope: !984, inlinedAt: !991)
!984 = distinct !DISubprogram(name: "write_volatile<u32>", linkageName: "_ZN4core3ptr14write_volatile17hd39e966d74d446bbE", scope: !918, file: !985, line: 945, type: !986, isLocal: true, isDefinition: true, scopeLine: 945, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !978, retainedNodes: !988)
!985 = !DIFile(filename: "/rustc/b68fc18c45350e1cdcd83cecf0f12e294e55af56/src/libcore/ptr.rs", directory: "")
!986 = !DISubroutineType(types: !987)
!987 = !{null, !974, !75}
!988 = !{!989, !990}
!989 = !DILocalVariable(name: "dst", arg: 1, scope: !984, file: !977, line: 1, type: !974)
!990 = !DILocalVariable(name: "src", arg: 2, scope: !984, file: !977, line: 1, type: !75)
!991 = distinct !DILocation(line: 173, column: 8, scope: !969, inlinedAt: !981)
!992 = !DILocation(line: 1, scope: !984, inlinedAt: !991)
!993 = !DILocalVariable(name: "self", arg: 1, scope: !994, file: !977, line: 1, type: !974)
!994 = distinct !DISubprogram(name: "offset<u32>", linkageName: "_ZN4core3ptr31_$LT$impl$u20$$BP$mut$u20$T$GT$6offset17h718996e8ae9e97d2E", scope: !995, file: !985, line: 1696, type: !996, isLocal: true, isDefinition: true, scopeLine: 1696, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !978, retainedNodes: !999)
!995 = !DINamespace(name: "{{impl}}", scope: !918)
!996 = !DISubroutineType(types: !997)
!997 = !{!974, !974, !998}
!998 = !DIBasicType(name: "isize", size: 32, encoding: DW_ATE_signed)
!999 = !{!993, !1000}
!1000 = !DILocalVariable(name: "count", arg: 2, scope: !994, file: !977, line: 1, type: !998)
!1001 = !DILocation(line: 1, scope: !994, inlinedAt: !1002)
!1002 = distinct !DILocation(line: 174, column: 15, scope: !969, inlinedAt: !981)
!1003 = !DILocation(line: 1697, column: 8, scope: !994, inlinedAt: !1002)
!1004 = !DILocation(line: 171, column: 10, scope: !969, inlinedAt: !981)
!1005 = !DILocalVariable(name: "sdata", arg: 1, scope: !1006, file: !977, line: 1, type: !974)
!1006 = distinct !DISubprogram(name: "init_data<u32>", linkageName: "_ZN2r09init_data17h9ddcc776cebe9529E", scope: !971, file: !970, line: 125, type: !1007, isLocal: true, isDefinition: true, scopeLine: 125, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !978, retainedNodes: !1010)
!1007 = !DISubroutineType(types: !1008)
!1008 = !{null, !974, !974, !1009}
!1009 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "*const u32", baseType: !75, size: 32, align: 32)
!1010 = !{!1005, !1011, !1012}
!1011 = !DILocalVariable(name: "edata", arg: 2, scope: !1006, file: !977, line: 1, type: !974)
!1012 = !DILocalVariable(name: "sidata", arg: 3, scope: !1006, file: !977, line: 1, type: !1009)
!1013 = !DILocation(line: 1, scope: !1006, inlinedAt: !1014)
!1014 = distinct !DILocation(line: 500, column: 4, scope: !966)
!1015 = !DILocation(line: 132, column: 4, scope: !1006, inlinedAt: !1014)
!1016 = !DILocalVariable(name: "dst", arg: 1, scope: !1017, file: !977, line: 1, type: !974)
!1017 = distinct !DISubprogram(name: "write<u32>", linkageName: "_ZN4core3ptr5write17h36acd23278597f8dE", scope: !918, file: !985, line: 735, type: !986, isLocal: true, isDefinition: true, scopeLine: 735, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !978, retainedNodes: !1018)
!1018 = !{!1016, !1019}
!1019 = !DILocalVariable(name: "src", arg: 2, scope: !1017, file: !977, line: 1, type: !75)
!1020 = !DILocation(line: 1, scope: !1017, inlinedAt: !1021)
!1021 = distinct !DILocation(line: 133, column: 8, scope: !1006, inlinedAt: !1014)
!1022 = !DILocation(line: 736, column: 41, scope: !1017, inlinedAt: !1021)
!1023 = !DILocation(line: 1, scope: !994, inlinedAt: !1024)
!1024 = distinct !DILocation(line: 134, column: 16, scope: !1006, inlinedAt: !1014)
!1025 = !DILocalVariable(name: "self", arg: 1, scope: !1026, file: !977, line: 1, type: !1009)
!1026 = distinct !DISubprogram(name: "offset<u32>", linkageName: "_ZN4core3ptr33_$LT$impl$u20$$BP$const$u20$T$GT$6offset17hbc5b9c25a89f9421E", scope: !995, file: !985, line: 1076, type: !1027, isLocal: true, isDefinition: true, scopeLine: 1076, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !978, retainedNodes: !1029)
!1027 = !DISubroutineType(types: !1028)
!1028 = !{!1009, !1009, !998}
!1029 = !{!1025, !1030}
!1030 = !DILocalVariable(name: "count", arg: 2, scope: !1026, file: !977, line: 1, type: !998)
!1031 = !DILocation(line: 1, scope: !1026, inlinedAt: !1032)
!1032 = distinct !DILocation(line: 135, column: 17, scope: !1006, inlinedAt: !1014)
!1033 = !DILocation(line: 1697, column: 8, scope: !994, inlinedAt: !1024)
!1034 = !DILocation(line: 1077, column: 8, scope: !1026, inlinedAt: !1032)
!1035 = !DILocation(line: 132, column: 10, scope: !1006, inlinedAt: !1014)
!1036 = !DILocation(line: 504, column: 14, scope: !966)
!1037 = distinct !DISubprogram(name: "UserHardFault_", linkageName: "UserHardFault_", scope: !2, file: !3, line: 536, type: !1038, isLocal: false, isDefinition: true, scopeLine: 536, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true, unit: !39, templateParams: !38, retainedNodes: !1051)
!1038 = !DISubroutineType(types: !1039)
!1039 = !{!10, !1040}
!1040 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "&cortex_m_rt::ExceptionFrame", baseType: !1041, size: 32, align: 32)
!1041 = !DICompositeType(tag: DW_TAG_structure_type, name: "ExceptionFrame", scope: !2, file: !15, size: 256, align: 32, elements: !1042, identifier: "ad04d1678c85c3ecb8ccd71f45fd7ee8")
!1042 = !{!1043, !1044, !1045, !1046, !1047, !1048, !1049, !1050}
!1043 = !DIDerivedType(tag: DW_TAG_member, name: "r0", scope: !1041, file: !15, baseType: !75, size: 32, align: 32)
!1044 = !DIDerivedType(tag: DW_TAG_member, name: "r1", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 32)
!1045 = !DIDerivedType(tag: DW_TAG_member, name: "r2", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 64)
!1046 = !DIDerivedType(tag: DW_TAG_member, name: "r3", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 96)
!1047 = !DIDerivedType(tag: DW_TAG_member, name: "r12", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 128)
!1048 = !DIDerivedType(tag: DW_TAG_member, name: "lr", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 160)
!1049 = !DIDerivedType(tag: DW_TAG_member, name: "pc", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 192)
!1050 = !DIDerivedType(tag: DW_TAG_member, name: "xpsr", scope: !1041, file: !15, baseType: !75, size: 32, align: 32, offset: 224)
!1051 = !{!1052}
!1052 = !DILocalVariable(name: "ef", arg: 1, scope: !1037, file: !3, line: 1, type: !1040)
!1053 = !DILocation(line: 1, scope: !1037)
!1054 = !DILocation(line: 537, column: 4, scope: !1037)
!1055 = distinct !DISubprogram(name: "DefaultHandler_", linkageName: "DefaultHandler_", scope: !2, file: !3, line: 546, type: !8, isLocal: false, isDefinition: true, scopeLine: 546, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true, unit: !39, templateParams: !38, retainedNodes: !38)
!1056 = !DILocation(line: 547, column: 4, scope: !1055)
!1057 = distinct !DISubprogram(name: "DefaultPreInit", linkageName: "DefaultPreInit", scope: !2, file: !3, line: 556, type: !19, isLocal: false, isDefinition: true, scopeLine: 556, flags: DIFlagPrototyped, isOptimized: true, unit: !39, templateParams: !38, retainedNodes: !38)
!1058 = !DILocation(line: 556, column: 44, scope: !1057)
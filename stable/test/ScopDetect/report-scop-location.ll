; RUN: opt %loadPolly -polly-detect-unprofitable -polly-detect -polly-report -disable-output < %s  2>&1 | FileCheck %s
target datalayout = "e-i64:64-f80:128-s:64-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define void @foo(float* %A) #0 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  br label %for.body, !dbg !11

for.body:                                         ; preds = %entry.split, %for.body
  %indvar = phi i64 [ 0, %entry.split ], [ %indvar.next, %for.body ]
  %i.01 = trunc i64 %indvar to i32, !dbg !13
  %arrayidx = getelementptr float, float* %A, i64 %indvar, !dbg !13
  %conv = sitofp i32 %i.01 to float, !dbg !13
  store float %conv, float* %arrayidx, align 4, !dbg !13
  %indvar.next = add i64 %indvar, 1, !dbg !11
  %exitcond = icmp ne i64 %indvar.next, 100, !dbg !11
  br i1 %exitcond, label %for.body, label %for.end, !dbg !11

for.end:                                          ; preds = %for.body
  ret void, !dbg !14
}

; CHECK: note: Polly detected an optimizable loop region (scop) in function 'foo'
; CHECK: test.c:2: Start of scop
; CHECK: test.c:3: End of scop

; Function Attrs: nounwind uwtable
define void @bar(float* %A) #0 {
entry:
  br label %entry.split

entry.split:                                      ; preds = %entry
  br label %for.body, !dbg !15

for.body:                                         ; preds = %entry.split, %for.body
  %indvar = phi i64 [ 0, %entry.split ], [ %indvar.next, %for.body ]
  %i.01 = trunc i64 %indvar to i32, !dbg !17
  %arrayidx = getelementptr float, float* %A, i64 %indvar, !dbg !17
  %conv = sitofp i32 %i.01 to float, !dbg !17
  store float %conv, float* %arrayidx, align 4, !dbg !17
  %indvar.next = add i64 %indvar, 1, !dbg !15
  %exitcond = icmp ne i64 %indvar.next, 100, !dbg !15
  br i1 %exitcond, label %for.body, label %for.end, !dbg !15

for.end:                                          ; preds = %for.body
  ret void, !dbg !18
}

; CHECK: note: Polly detected an optimizable loop region (scop) in function 'bar'
; CHECK: test.c:9: Start of scop
; CHECK: test.c:13: End of scop

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9}
!llvm.ident = !{!10}

!0 = !MDCompileUnit(language: DW_LANG_C99, producer: "clang version 3.5 ", isOptimized: false, emissionKind: 0, file: !1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "test.c", directory: "/home/grosser/Projects/polly/git/tools/polly")
!2 = !{}
!3 = !{!4, !7}
!4 = !MDSubprogram(name: "foo", line: 1, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 1, file: !1, scope: !5, type: !6, function: void (float*)* @foo, variables: !2)
!5 = !MDFile(filename: "test.c", directory: "/home/grosser/Projects/polly/git/tools/polly")
!6 = !MDSubroutineType(types: !{null})
!7 = !MDSubprogram(name: "bar", line: 6, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 6, file: !1, scope: !5, type: !6, function: void (float*)* @bar, variables: !2)
!8 = !{i32 2, !"Dwarf Version", i32 4}
!9 = !{i32 1, !"Debug Info Version", i32 3}
!10 = !{!"clang version 3.5 "}
!11 = !MDLocation(line: 2, scope: !12)
!12 = distinct !MDLexicalBlock(line: 2, column: 0, file: !1, scope: !4)
!13 = !MDLocation(line: 3, scope: !12)
!14 = !MDLocation(line: 4, scope: !4)
!15 = !MDLocation(line: 9, scope: !16)
!16 = distinct !MDLexicalBlock(line: 9, column: 0, file: !1, scope: !7)
!17 = !MDLocation(line: 13, scope: !16)
!18 = !MDLocation(line: 14, scope: !7)


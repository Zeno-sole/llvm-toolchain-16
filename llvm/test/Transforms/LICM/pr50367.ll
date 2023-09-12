; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='loop-mssa(licm)' < %s | FileCheck %s
@e = external dso_local global ptr, align 8

define void @main() {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    br i1 false, label [[LOOP2_LATCH:%.*]], label [[LOOP_LATCH:%.*]]
; CHECK:       loop2.latch:
; CHECK-NEXT:    br label [[LOOP2]]
; CHECK:       loop.latch:
; CHECK-NEXT:    br label [[LOOP1]]
;
entry:
  br label %loop1

loop1:
  br label %loop2

loop2:
  br i1 undef, label %loop2.latch, label %loop.latch

loop2.latch:
  store i32 0, ptr null, align 4
  br label %loop2

loop.latch:
  store ptr null, ptr @e, align 8, !tbaa !0
  %ptr = load ptr, ptr @e, align 8, !tbaa !0
  store i32 0, ptr %ptr, align 4, !tbaa !4
  br label %loop1
}

!0 = !{!1, !1, i64 0}
!1 = !{!"any pointer", !2, i64 0}
!2 = !{!"omnipotent char", !3, i64 0}
!3 = !{!"Simple C/C++ TBAA"}
!4 = !{!5, !5, i64 0}
!5 = !{!"int", !2, i64 0}
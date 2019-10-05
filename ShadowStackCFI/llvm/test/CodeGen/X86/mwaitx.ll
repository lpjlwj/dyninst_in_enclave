; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux -mattr=+mwaitx | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-win32 -mattr=+mwaitx | FileCheck %s -check-prefix=WIN64
; RUN: llc < %s -mtriple=x86_64-linux -mcpu=bdver4 | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-win32 -mcpu=bdver4 | FileCheck %s -check-prefix=WIN64

define void @foo(i8* %P, i32 %E, i32 %H) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    monitorx
; CHECK-NEXT:    retq
;
; WIN64-LABEL: foo:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    movq %rcx, %rax
; WIN64-NEXT:    movl %edx, %ecx
; WIN64-NEXT:    movl %r8d, %edx
; WIN64-NEXT:    monitorx
; WIN64-NEXT:    retq
entry:
  tail call void @llvm.x86.monitorx(i8* %P, i32 %E, i32 %H)
  ret void
}

declare void @llvm.x86.monitorx(i8*, i32, i32) nounwind

define void @bar(i32 %E, i32 %H, i32 %C) nounwind {
; CHECK-LABEL: bar:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    movl %edx, %ebx
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    movl %edi, %ecx
; CHECK-NEXT:    mwaitx
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; WIN64-LABEL: bar:
; WIN64:       # %bb.0: # %entry
; WIN64-NEXT:    pushq %rbx
; WIN64-NEXT:    movl %r8d, %ebx
; WIN64-NEXT:    movl %edx, %eax
; WIN64-NEXT:    mwaitx
; WIN64-NEXT:    popq %rbx
; WIN64-NEXT:    retq
entry:
  tail call void @llvm.x86.mwaitx(i32 %E, i32 %H, i32 %C)
  ret void
}

declare void @llvm.x86.mwaitx(i32, i32, i32) nounwind

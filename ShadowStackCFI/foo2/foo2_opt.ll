; ModuleID = '<stdin>'
source_filename = "foo2"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [29 x i8] c"----------1 in fun----------\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"----------1----------\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"----------2----------\00", align 1
@.str.3 = private unnamed_addr constant [22 x i8] c"----------3----------\00", align 1
@.str.4 = private unnamed_addr constant [22 x i8] c"----------4----------\00", align 1
@.str.5 = private unnamed_addr constant [9 x i8] c"success!\00", align 1

; Function Attrs: noinline nounwind optnone
define dso_local void @CFICheck(i64 %target) #0 {
entry:
  %target.addr = alloca i64, align 8
  %CFICheckAddressPtr = alloca i64*, align 8
  %CFICheckAddressNum = alloca i32, align 4
  %low = alloca i32, align 4
  %high = alloca i32, align 4
  %mid = alloca i32, align 4
  store i64 %target, i64* %target.addr, align 8
  store i64* inttoptr (i64 2305843009213693951 to i64*), i64** %CFICheckAddressPtr, align 8
  store i32 536870911, i32* %CFICheckAddressNum, align 4
  store i32 0, i32* %low, align 4
  %0 = load i32, i32* %CFICheckAddressNum, align 4
  %sub = sub nsw i32 %0, 1
  store i32 %sub, i32* %high, align 4
  br label %while.cond

while.cond:                                       ; preds = %if.end13, %entry
  %1 = load i32, i32* %low, align 4
  %2 = load i32, i32* %high, align 4
  %cmp = icmp sle i32 %1, %2
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %3 = load i32, i32* %low, align 4
  %4 = load i32, i32* %high, align 4
  %5 = load i32, i32* %low, align 4
  %sub1 = sub nsw i32 %4, %5
  %div = sdiv i32 %sub1, 2
  %add = add nsw i32 %3, %div
  store i32 %add, i32* %mid, align 4
  %6 = load i32, i32* %mid, align 4
  %7 = load i32, i32* %high, align 4
  %cmp2 = icmp sge i32 %6, %7
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  br label %while.end

if.end:                                           ; preds = %while.body
  %8 = load i64*, i64** %CFICheckAddressPtr, align 8
  %9 = load i32, i32* %mid, align 4
  %idxprom = sext i32 %9 to i64
  %arrayidx = getelementptr inbounds i64, i64* %8, i64 %idxprom
  %10 = load i64, i64* %arrayidx, align 8
  %11 = load i64, i64* %target.addr, align 8
  %cmp3 = icmp eq i64 %10, %11
  br i1 %cmp3, label %if.then4, label %if.else

if.then4:                                         ; preds = %if.end
  ret void

if.else:                                          ; preds = %if.end
  %12 = load i64*, i64** %CFICheckAddressPtr, align 8
  %13 = load i32, i32* %mid, align 4
  %idxprom5 = sext i32 %13 to i64
  %arrayidx6 = getelementptr inbounds i64, i64* %12, i64 %idxprom5
  %14 = load i64, i64* %arrayidx6, align 8
  %15 = load i64, i64* %target.addr, align 8
  %cmp7 = icmp sgt i64 %14, %15
  br i1 %cmp7, label %if.then8, label %if.else10

if.then8:                                         ; preds = %if.else
  %16 = load i32, i32* %mid, align 4
  %sub9 = sub nsw i32 %16, 1
  store i32 %sub9, i32* %high, align 4
  br label %if.end12

if.else10:                                        ; preds = %if.else
  %17 = load i32, i32* %mid, align 4
  %add11 = add nsw i32 %17, 1
  store i32 %add11, i32* %low, align 4
  br label %if.end12

if.end12:                                         ; preds = %if.else10, %if.then8
  br label %if.end13

if.end13:                                         ; preds = %if.end12
  br label %while.cond

while.end:                                        ; preds = %if.then, %while.cond
  call void @exit(i32 -1) #3
  unreachable
}

; Function Attrs: noreturn
declare dso_local void @exit(i32) #1

; Function Attrs: noinline nounwind optnone
define dso_local i8* @my_itoa(i64 %val, i8* %buf, i32 %radix) #0 {
entry:
  %val.addr = alloca i64, align 8
  %buf.addr = alloca i8*, align 8
  %radix.addr = alloca i32, align 4
  %p = alloca i8*, align 8
  %firstdig = alloca i8*, align 8
  %temp = alloca i8, align 1
  %digval = alloca i32, align 4
  store i64 %val, i64* %val.addr, align 8
  store i8* %buf, i8** %buf.addr, align 8
  store i32 %radix, i32* %radix.addr, align 4
  %0 = load i8*, i8** %buf.addr, align 8
  store i8* %0, i8** %p, align 8
  %1 = load i8*, i8** %p, align 8
  store i8* %1, i8** %firstdig, align 8
  br label %do.body

do.body:                                          ; preds = %do.cond, %entry
  %2 = load i64, i64* %val.addr, align 8
  %3 = load i32, i32* %radix.addr, align 4
  %conv = zext i32 %3 to i64
  %rem = urem i64 %2, %conv
  %conv1 = trunc i64 %rem to i32
  store i32 %conv1, i32* %digval, align 4
  %4 = load i32, i32* %radix.addr, align 4
  %conv2 = zext i32 %4 to i64
  %5 = load i64, i64* %val.addr, align 8
  %div = udiv i64 %5, %conv2
  store i64 %div, i64* %val.addr, align 8
  %6 = load i32, i32* %digval, align 4
  %cmp = icmp ugt i32 %6, 9
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %do.body
  %7 = load i32, i32* %digval, align 4
  %sub = sub i32 %7, 10
  %add = add i32 %sub, 97
  %conv4 = trunc i32 %add to i8
  %8 = load i8*, i8** %p, align 8
  %incdec.ptr = getelementptr inbounds i8, i8* %8, i32 1
  store i8* %incdec.ptr, i8** %p, align 8
  store i8 %conv4, i8* %8, align 1
  br label %if.end

if.else:                                          ; preds = %do.body
  %9 = load i32, i32* %digval, align 4
  %add5 = add i32 %9, 48
  %conv6 = trunc i32 %add5 to i8
  %10 = load i8*, i8** %p, align 8
  %incdec.ptr7 = getelementptr inbounds i8, i8* %10, i32 1
  store i8* %incdec.ptr7, i8** %p, align 8
  store i8 %conv6, i8* %10, align 1
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  br label %do.cond

do.cond:                                          ; preds = %if.end
  %11 = load i64, i64* %val.addr, align 8
  %cmp8 = icmp ugt i64 %11, 0
  br i1 %cmp8, label %do.body, label %do.end

do.end:                                           ; preds = %do.cond
  %12 = load i8*, i8** %p, align 8
  %incdec.ptr10 = getelementptr inbounds i8, i8* %12, i32 -1
  store i8* %incdec.ptr10, i8** %p, align 8
  store i8 32, i8* %12, align 1
  br label %do.body11

do.body11:                                        ; preds = %do.cond14, %do.end
  %13 = load i8*, i8** %p, align 8
  %14 = load i8, i8* %13, align 1
  store i8 %14, i8* %temp, align 1
  %15 = load i8*, i8** %firstdig, align 8
  %16 = load i8, i8* %15, align 1
  %17 = load i8*, i8** %p, align 8
  store i8 %16, i8* %17, align 1
  %18 = load i8, i8* %temp, align 1
  %19 = load i8*, i8** %firstdig, align 8
  store i8 %18, i8* %19, align 1
  %20 = load i8*, i8** %p, align 8
  %incdec.ptr12 = getelementptr inbounds i8, i8* %20, i32 -1
  store i8* %incdec.ptr12, i8** %p, align 8
  %21 = load i8*, i8** %firstdig, align 8
  %incdec.ptr13 = getelementptr inbounds i8, i8* %21, i32 1
  store i8* %incdec.ptr13, i8** %firstdig, align 8
  br label %do.cond14

do.cond14:                                        ; preds = %do.body11
  %22 = load i8*, i8** %firstdig, align 8
  %23 = load i8*, i8** %p, align 8
  %cmp15 = icmp ult i8* %22, %23
  br i1 %cmp15, label %do.body11, label %do.end17

do.end17:                                         ; preds = %do.cond14
  %24 = load i8*, i8** %buf.addr, align 8
  ret i8* %24
}

; Function Attrs: noinline nounwind optnone
define dso_local i32 @fun() #0 {
entry:
  %call = call i32 @puts(i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str, i64 0, i64 0))
  ret i32 1
}

declare dso_local i32 @puts(i8*) #2

; Function Attrs: noinline nounwind optnone
define dso_local void @enclave_main() #0 {
entry:
  %fp = alloca i32 ()*, align 8
  %b = alloca i32, align 4
  %i_b = alloca [8 x i8], align 1
  %ii_b = alloca i8*, align 8
  store i32 ()* @fun, i32 ()** %fp, align 8
  %call = call i32 @puts(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0))
  %0 = load i32 ()*, i32 ()** %fp, align 8
  call void @CFICheck(i64 1229782938247303441)
  %call1 = call i32 %0()
  store i32 %call1, i32* %b, align 4
  %call2 = call i32 @puts(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.2, i64 0, i64 0))
  %1 = bitcast [8 x i8]* %i_b to i8*
  store i8* %1, i8** %ii_b, align 8
  %call3 = call i32 @puts(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.3, i64 0, i64 0))
  %2 = load i32, i32* %b, align 4
  %conv = sext i32 %2 to i64
  %3 = load i8*, i8** %ii_b, align 8
  %call4 = call i8* @my_itoa(i64 %conv, i8* %3, i32 10)
  store i8* %call4, i8** %ii_b, align 8
  %call5 = call i32 @puts(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @.str.4, i64 0, i64 0))
  %4 = load i8*, i8** %ii_b, align 8
  %call6 = call i32 @puts(i8* %4)
  %call7 = call i32 @puts(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.5, i64 0, i64 0))
  call void @exit(i32 0) #4
  unreachable
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { noreturn "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn }
attributes #4 = { noreturn nounwind }

!llvm.ident = !{!0, !1}
!llvm.module.flags = !{!2}

!0 = !{!"clang version 9.0.0 "}
!1 = !{!"clang version 9.0.0 (https://github.com/StanPlatinum/llvm-project.git 2355ea5e1501a28533d63027bf034ce84307357d)"}
!2 = !{i32 1, !"wchar_size", i32 4}

#SGX_Shield_PATH = /root/SGX-Shield
Our_AS_Path = /home/lys/Program/llvm-mc
#Our_AS_Path = /home/liuweijie/llvm-assembler

CC4AS = $(Our_AS_Path)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign

#LLVM_PATH = /home/liuweijie/llvm-project

#LLVM_PATH = /home/weijliu/llvm-project
LLVM_PATH = /home/lys/Program/llvm-9.0.0
LLVM_BIN_PATH = $(LLVM_PATH)/build/bin
CFIHello_So_PATH = $(LLVM_PATH)/build/lib/LLVMCFIHello.so

#CC = $(LLVM_PATH)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-jump-tables
CC = $(LLVM_PATH)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign

TARGET_NAME = nw1
#TARGET_NAME = simple_malloc
#TARGET_NAME = malloc_and_sort
#TARGET_NAME = foo2

BASE_CFLAGS = -Wall -pedantic -Wno-unused-function -std=gnu11

MUSL_LIBC_DIR = ./musl-libc
MUSL_LIBC = $(MUSL_LIBC_DIR)/lib/libc.a
SGX_CFLAGS = $(BASE_CFLAGS) -I$(MUSL_LIBC_DIR)/include -fno-stack-protector -fvisibility=hidden

OCALL_OBJS_DIR = lib/
OCALL_LIB_MK = lib/ocall.mk
include $(OCALL_LIB_MK)

STACK_OBJ = lib/stack.o
DEBUG_OBJ = lib/my_itoa.o

ASM_OBJS = $(STACK_OBJ) $(DEBUG_OBJ) lib/start.o lib/ocall.o lib/rop_gadget.o

#ASM_OBJS = lib/stack.o lib/start.o lib/ocall.o lib/rop_gadget.o lib/CFICheck.o lib/my_itoa.o

all: $(MUSL_LIBC) $(TARGET_NAME).bin
	mv $(TARGET_NAME).bin ../program
	cp $(TARGET_NAME).txt ../entryLabel.txt
#	cp $(TARGET_NAME)/$(TARGET_NAME).txt ../entryLabel.txt

$(STACK_OBJ): lib/stack.c
	$(CC4AS) -c $< -o $@
#	$(CC) -c $< -o $@

$(DEBUG_OBJ): lib/my_itoa.c
	$(CC4AS) -c $< -o $@

$(MUSL_LIBC):
	(cd musl-libc; ./configure)
	make -C musl-libc lib/libc.a

$(TARGET_NAME).bin: objs/libc_targetprogram.a tools/linker malloc.o $(OCALL_OBJS) $(ASM_OBJS) CFICheck.o foo1.o
	cp foo1.o objs/
	cp CFICheck.o objs/
	cp malloc.o objs/
	cp lib/*.o objs
	ls objs/*.o > list
	cat list | ./tools/linker $(TARGET_NAME).bin
	@echo "Build successfully!"

lib/%.o: lib/%.s
	$(CC4AS) -c -o $@ $<

tools/linker: tools/linkage_editor.cpp
	$(CXX) -o $@ $^

objs/libc_targetprogram.a: enclave_main.o $(MUSL_LIBC)
	cp $^ objs/
	$(MAKE) -C objs

malloc.o: malloc/malloc.c malloc/dlmalloc.inc
	$(CC4AS) -c $(SGX_CFLAGS) -o $@ $<

#$(TARGET_NAME).s: $(TARGET_NAME).c
#	python3 ./CFIShell.py $(LLVM_BIN_PATH) $(CFIHello_So_PATH) $(TARGET_NAME).c ./CFICheck.c n
#	cp $(TARGET_NAME)/$(TARGET_NAME)_opt.s $@

#enclave_main.o: $(TARGET_NAME).s enclave.h CFICheck.h
#	$(CC4AS) -c $< -o $@

$(TARGET_NAME).s: $(TARGET_NAME).c enclave.h
	$(CC) -S -I. $< -o $@

enclave_main.o: $(TARGET_NAME).s
	$(CC) -c $< -o $@

foo1.o: foo1.c
	$(CC) -c $< -o $@

CFICheck.o: CFICheck.c
	$(CC) -c $< -o $@

clean:
	rm -f *.ll *.s *.txt *.o objs/*.o objs/*.lo objs/*.a \
		list lib/*.o lib/*.txt
	rm -rf $(TARGET_NAME)

clean-all:
	rm -f *.ll *.s *.txt *.o *.a objs/*.o objs/*.lo objs/*.a list \
		tools/linker lib/*.o lib/*.txt
	rm -rf $(TARGET_NAME)
	$(MAKE) -C musl-libc clean


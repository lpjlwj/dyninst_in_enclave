LLVM_PATH = /home/liuweijie/proofGen
Our_AS_Path = /home/liuweijie/llvm-mc
SGX_SRC_PATH = /home/liuweijie/linux-sgx
SGX_SRC_PATH = /home/liuweijie/linux-sgx

SGX_COM_INC = $(SGX_SRC_PATH)/common/inc

CC4AS = $(Our_AS_Path)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign

#LLVM_PATH = /home/weijliu/proofGen4store
#LLVM_PATH = /home/weijliu/proofGen4memwt
#Weijie: 
#Note that the llvm version on my thinkpad is 9.0.0, with TSX instrumentation

LLVM_BIN_PATH = $(LLVM_PATH)/build/bin
CFIHello_So_PATH = $(LLVM_PATH)/build/lib/LLVMCFIHello.so

CC = $(LLVM_PATH)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign
CC4CFICheck = $(LLVM_PATH)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign -Xclang -load -Xclang $(CFIHello_So_PATH)
CC4TSX = $(LLVM_PATH)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign -Xclang -load -Xclang $(CFIHello_So_PATH)
CC4HR = $(LLVM_PATH)/build/bin/clang -fPIC -fno-asynchronous-unwind-tables -fno-addrsig -mstackrealign -Xclang -load -Xclang $(CFIHello_So_PATH)

#TARGET_NAME = fasta
#TARGET_NAME = nw
#TARGET_NAME = foo2
#TARGET_NAME = bm_malloc_and_sort
#TARGET_NAME = bm_malloc_magic
#TARGET_NAME = bm_clock
#TARGET_NAME = bm_malloc_memalign_magic
#TARGET_NAME = bm_memcpy
#TARGET_NAME = bm_memchr
#TARGET_NAME = bm_sprintf
#TARGET_NAME = bm_sort_and_binsearch

TARGET_NAME = bm_hello
#TARGET_NAME = misc

#TARGET_NAME = file_io_test
#TARGET_NAME = credit_score

SSL_SERVER = ssl_server

BASE_CFLAGS = -Wall -pedantic -Wno-unused-function -std=gnu11

NOLIBC_FLAG = -nodefaultlibs -nostdlib

MUSL_LIBC_DIR = ./musl-libc
MUSL_LIBC = $(MUSL_LIBC_DIR)/lib/libc.a
SGX_CFLAGS = $(BASE_CFLAGS) -I$(MUSL_LIBC_DIR)/include -fno-stack-protector -fvisibility=hidden

OCALL_OBJS_DIR = lib/
OCALL_LIB_MK = lib/ocall.mk
include $(OCALL_LIB_MK)

STACK_OBJ = lib/stack.o

ASM_OBJS = $(STACK_OBJ) $(DEBUG_OBJ) lib/start.o lib/ocall.o lib/rop_gadget.o

LIBGCC = libgcc/ashldi3.o libgcc/ashrdi3.o libgcc/__divide_error.o  \
		 libgcc/__divdi3.o libgcc/__divti3.o libgcc/__lshrdi3.o     \
		 libgcc/multi3.o libgcc/__negti2.o libgcc/__udivdi3.o       \
		 libgcc/__udivmoddi4.o libgcc/__udivmodti4.o                \
		 libgcc/__udivti3.o libgcc/__umoddi3.o libgcc/__umodti3.o


all: $(MUSL_LIBC) $(TARGET_NAME).bin 
	mv $(TARGET_NAME).bin ../program
	cp $(TARGET_NAME).txt ../entryLabel.txt

$(STACK_OBJ): lib/stack.c
	$(CC4AS) -c $< -o $@

#Weijie: using sprintf for debugging instead
#$(DEBUG_OBJ): lib/my_itoa.c
#	$(CC4AS) -c $< -o $@

#Weijie: to build nbench, firstly, do 'make' in the nbench dir, ignore the linking error, then do the following
LIBNBENCH = nbench/nbench.a
$(LIBNBENCH):
	$(MAKE) -C nbench nbench.a

nben: $(TARGET_NAME).bin $(LIBNBENCH)
	cp nbench/*.o objs
	ls objs/*.o > list
	cat list | ./tools/linker nben
	mv nben ../
	rm $(TARGET_NAME).bin

$(MUSL_LIBC):
	(cd musl-libc; ./configure)
	make -C musl-libc lib/libc.a

SSL_FLAGS = -D_FILE_OFFSET_BITS=64 -I./mbedtls/include -I./musl-libc/include

LIBSSL = mbedtls/libmbedtls.a mbedtls/libmbedcrypto.a mbedtls/libmbedx509.a

$(LIBSSL):
	$(MAKE) -C mbedtls all

$(SSL_SERVER): objs/libc_sslserver.a tools/linker malloc.o $(OCALL_OBJS) $(ASM_OBJS) $(LIBGCC)
	cp lib/*.o objs
	cp libgcc/*.o objs

https: $(SSL_SERVER) $(MUSL_LIBC) $(LIBSSL) CFICheck.o
	cp CFICheck.o objs/
#	cp transactionBegin.o objs/
#	cp telib_t.o objs/
	cp mbedtls/*.o objs
	ls objs/*.o > list
	cat list | ./tools/linker https
	mv https ../program
#	cat entryLabel4ssl.txt $(SSL_SERVER).txt > entryLabel
#	sort entryLabel| uniq > entryLabel.txt
#	mv entryLabel.txt ..
	mv $(SSL_SERVER).txt ../entryLabel.txt
	@echo "Build successfully!"

#$(TARGET_NAME).bin: objs/libc_targetprogram.a tools/linker $(OCALL_OBJS) $(ASM_OBJS) CFICheck.o
$(TARGET_NAME).bin: objs/libc_targetprogram.a tools/linker $(OCALL_OBJS) $(ASM_OBJS) CFICheck.o transactionBegin.o transactionEndBegin.o telib_t.o
	cp CFICheck.o objs/
	cp transactionBegin.o objs/
	cp transactionEndBegin.o objs/
	#cp telib_t.o objs/
	cp malloc.o objs/
	cp lib/*.o objs
	ls objs/*.o > list
	cat list | ./tools/linker $(TARGET_NAME).bin
#	cat transactionBegin.txt $(TARGET_NAME).txt >> entryLabel
#	sort entryLabel| uniq > entryLabel.txt
	@echo "Build successfully!"

lib/%.o: lib/%.s
	$(CC4AS) -c -o $@ $<

tools/linker: tools/linkage_editor.cpp
	$(CXX) -o $@ $^

objs/libc_sslserver.a: $(SSL_SERVER).o malloc.o $(MUSL_LIBC)
	cp $^ objs/
	$(MAKE) -C objs libc_sslserver.a

objs/libc_targetprogram.a: enclave_main.o malloc.o $(MUSL_LIBC)
	cp $^ objs/
	$(MAKE) -C objs libc_targetprogram.a
	
malloc.o: malloc/malloc.c malloc/dlmalloc.inc
	$(CC4AS) -c $(SGX_CFLAGS) -o $@ $<

#$(TARGET_NAME).s: $(TARGET_NAME).c
#	python3 ./CFIShell.py $(LLVM_BIN_PATH) $(CFIHello_So_PATH) $(TARGET_NAME).c ./CFICheck.c n
#	cp $(TARGET_NAME)/$(TARGET_NAME)_opt.s $@

#enclave_main.o: $(TARGET_NAME).s enclave.h CFICheck.h
#	$(CC4AS) -c $< -o $@

# Use Xclang
$(TARGET_NAME).s: $(TARGET_NAME).c enclave.h CFICheck.h
	#$(CC4HR) -S -I. $< -o $@
	$(CC4TSX) -S -I. $< -o $@
	#$(CC4CFICheck) -S -I. $< -o $@
enclave_main.o: $(TARGET_NAME).s
	$(CC) -c $< -o $@

$(SSL_SERVER).o: $(SSL_SERVER).c enclave.h
	$(CC4TSX) -S $(SSL_FLAGS) -o $(SSL_SERVER).s $<
	#$(CC4CFICheck) -S $(SSL_FLAGS) -o $(SSL_SERVER).s $<
	$(CC) -c $(SSL_SERVER).s -o $@

CFICheck.o: CFICheck.c
	$(CC4CFICheck) -c $< -o $@

transactionBegin.o: transactionBegin.c rtm.h
	$(CC4AS) -c $< -o $@
	#$(CC4TSX) -c $< -o $@


transactionEndBegin.o: transactionEndBegin.c rtm.h
	$(CC4AS) -c $< -o $@
	#$(CC4TSX) -c $< -o $@


telib_t.o: telib_t.c
	$(CC4AS) -I$(SGX_COM_INC) -c $< -o $@

#simplelib_t.o: simplelib_t.c
#	$(CC4AS) -c $< -o $@

clean:
	rm -f *.ll *.s *.txt *.o objs/*.o objs/*.lo objs/*.a \
		list lib/*.o lib/*.txt
	rm -rf $(TARGET_NAME)

clean-all:
	rm -f *.ll *.s *.txt *.o *.a objs/*.o objs/*.lo objs/*.a list \
		tools/linker lib/*.o lib/*.txt
	rm -rf $(TARGET_NAME)
	$(MAKE) -C musl-libc clean
	$(MAKE) -C nbench clean
	$(MAKE) -C mbedtls clean


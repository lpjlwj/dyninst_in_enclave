#include <stdio.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>

#include "Enclave.h"
#include "Enclave_t.h"

/* My private Enclave function */
void PrintDebugInfo(const char *fmt, ...)
{
	char buf[BUFSIZ] = {'\0'};
	va_list ap;
	va_start(ap, fmt);
	vsnprintf(buf, BUFSIZ, fmt, ap);
	va_end(ap);
	ocall_print_string(buf);
}

//Weijie: debug
#if 0
/* My public Enclave functions */
void PrintDebugInfoOutside(void)
{
	ocall_print_string("PDIO test\n");
}

void PrintDebugInfoOutside2(void)
{
	ocall_print_string("PDIO test in ud->disasm ...\n");
}

void PrintDebugInfoOutside3(void)
{
	ocall_print_string("PDIO test in elf_begin ...\n");
}
#endif

#include "libelf.h"
#include "libelf_extra_types.h"

#include "capstone_x86.h"

/* Weijie: if the return value is 1, then it means that this insn[j] is writting memory */
static int find_memory_write(csh ud, cs_mode, cs_insn *ins)
{
	cs_x86 *x86;
	int i, exist = 0;

	if (ins->detail == NULL)	return -2;
	//Weijie: returning -2 means this insn[j] is kind of "data" instruction

	x86 = &(ins->detail->x86);
	if (x86->op_count == 0)		return -1;
	//Weijie: returning -1 means this insn[j] has no oprand
	
	// traverse all operands
	for (i = 0; i < x86->op_count; i++) {
		cs_x86_op *op = &(x86->operands[i]);
		//Weijie: returning 0 means this insn[j] has no memory writting
		//Weijie: returning 1 means this insn[j] has memory writting
		if ((int)op->type == X86_OP_MEM && (op->access & CS_AC_WRITE)){
			exist++;
			return 1;
		}
	}
	return exist;
}

/* Weijie: used be an ecall of whole cs_open/disasm/close */
int cs_disasm_entry(unsigned char* buf_test, Elf64_Xword textSize, Elf64_Addr textAddr) {
	//PrintDebugInfo("Weijie: new enclave starts here.\n");
	csh handle;
	cs_insn *insn;
	size_t count;

	//Xiaozhu & Weijie: test
	/*
	unsigned char buf_test[] =
	{
		0x74, 0x1d,
		0xc4, 0xe3, 0xe9, 0x6a, 0x09, 0x00,
		0xc4, 0xa3, 0x71, 0x6d, 0x04, 0x0e, 0x00,
		0xc4, 0xc3, 0xc1, 0x7b, 0x44, 0xc7, 0xf8, 0x10,
		0xc4, 0xe3, 0xe9, 0x6f, 0xc9, 0x00,
		0xc4, 0xe3, 0x51, 0x6b, 0x08, 0x10,
		0xc4, 0xe3, 0x49, 0x79, 0x05, 0x20, 0x7e, 0x33, 0x00, 0x10,
		0x8f, 0xe8, 0x58, 0x9e, 0xd0, 0x30,
		0x8f, 0xe8, 0x48, 0xce, 0xca, 0x03,
		0x8f, 0xe8, 0x68, 0xa2, 0xc5, 0x40,
		0x8f, 0xe9, 0x70, 0x9a, 0xcc,
		0x8f, 0xe8, 0xd0, 0xa3, 0x05, 0x18, 0x33, 0x2e, 0x00, 0x60,
		0xc4, 0xe3, 0x79, 0x0b, 0xc0, 0x0a,

		0x62, 0xf1, 0xed, 0x48, 0xfb, 0xd6,
		0x62, 0xb1, 0x3d, 0x48, 0x72, 0x34, 0x8e, 0x03,
		0x62, 0xe2, 0x7e, 0x48, 0x3a, 0xcb,
		0x62, 0xf2, 0x6d, 0x4a, 0x64, 0xc1,
		0xc4, 0xe3, 0x79, 0x0b, 0xc8, 0x02,
		0x62, 0xb1, 0xfd, 0x08, 0x2e, 0xc5,
		0x66, 0x0f, 0x3a, 0x0a, 0xc0, 0x02,
		0x62, 0xd2, 0xf5, 0x78, 0xb8, 0xd1,
		0xf2, 0x44, 0x0f, 0x10, 0xb4, 0x24, 0x98, 0x00, 0x00, 0x00,
		0x00
	};
	*/

	if (cs_open(CS_ARCH_X86, CS_MODE_64, &handle)) {
		PrintDebugInfo("ERROR: Failed to initialize engine!\n");
		return -1;
	}

	//PrintDebugInfo("-----disassembling-----\n");
	//count = cs_disasm(handle, buf_test, sizeof(buf_test)-1, textAddr, 0, &insn);
	count = cs_disasm(handle, buf_test, textSize, textAddr, 0, &insn);
	PrintDebugInfo("-----printing-----\n");
	if (count) {
		size_t j;
		for (j = 0; j < count; j++) {
			PrintDebugInfo("0x%"PRIx64":\t%s\t\t%s\n", insn[j].address, insn[j].mnemonic, insn[j].op_str);
		}
		cs_free(insn, count);
	} else
		PrintDebugInfo("ERROR: Failed to disassemble given code!\n");
	cs_close(&handle);

	return 0;
}


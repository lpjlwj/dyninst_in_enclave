#!/usr/bin/python

ocalls = [
    'clock',
    'time',
    'localtime',
    'gmtime',
    'mktime',
    'gettimeofday',
    'puts',
    'push_gadget',
    'open',
    'close',
    'read',
    'write',
    'lseek',
    'socket',
    'bind',
    'connect',
    'listen',
    'accept',
    'fstat',
    'send',
    'recv',
    'sendto',
    'recvfrom',
    'gethostname',
    'getaddrinfo',
    'getenv',
    'getsockname',
    'getsockopt',
    'getservbyname',
    'getprotobynumber',
    'setsockopt',
    'htons',
    'htonl',
    'ntohs',
    'ntohl',
    'signal',
    'shutdown',
]

align = 5
msg = 'this file is generated by lib/gen_ocall_stub.py script\n'

makefile = open('ocall.mk', 'w')
makefile.write('# ' + msg)
makefile.write('OCALL_OBJS = \\\n')
ocalltab = open('ocall_table.cpp', 'w')
ocalltab.write('// ' + msg)
ocalltab.write('static void *ocall_table[' + str(len(ocalls)) + '] = {\n')
i = 0
for o in ocalls:
    makefile.write('\t$(OCALL_OBJS_DIR)' + o + '.o \\\n')
    ocalltab.write('    (void *) sgx_' + o + ',\n')
    asm = open(o + '.s', 'w')
    asm.write('# ' + msg)
    asm.write('.text\n')
    asm.write('.global ' + o + '\n')
    asm.write('.type %s, @function\n' % o)
    asm.write('.p2align %d\n' % align)
    asm.write(o + ':\n')
    asm.write('    mov $' + str(i) + ', %r15\n')
    asm.write('    jmp sgx_ocall\n')
    asm.close()
    i = i + 1

ocalltab.write('};\n\n')
do_sgx_ocall = \
'// TODO: check if it breaks the calling ABI\n\
void do_sgx_ocall() {\n\
    __asm__ __volatile__ (\n\
        "mov (%0, %%r15, 8), %%r15\\n"\n\
        "call *%%r15\\n"\n\
    ::"r" (ocall_table));\n\
}\n'
ocalltab.write(do_sgx_ocall)
ocalltab.close()

makefile.close()

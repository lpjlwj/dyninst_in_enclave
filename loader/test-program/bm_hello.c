/* a very simple test program */

//#include <stdio.h>
//#include <stdlib.h>
//#include "enclave.h"

int global_test = 0;

void enclave_main()
{
	int j = 0;
	//puts("hello");
	for (int i = 0; i < 10; i++)	j++;
	//enclave_exit();
}

int main(void){
	enclave_main();
}

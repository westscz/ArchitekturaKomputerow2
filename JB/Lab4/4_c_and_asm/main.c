#include <stdio.h>
/* http://www.codeproject.com/Articles/15971/Using-Inline-Assembly-in-C-C */

int main(){

	printf("Wywolanie ASM bezpośrednio w C\n");
	int first = 32, second = 64, result;
	printf("%d + %d = ",first, second);

	asm (	"movl %1, %%eax;"			// Albo __asm__
		"movl %2, %%ebx;"
		"add %%ebx, %%eax;"
		"movl %%eax, %0;"
         	: "=r" ( result )        		// wyjście 0
         	: "r" ( first ), "r" ( second )         // wejscie 1 2
         	: "%eax"				// niszczenie rejestrów 
     	);
	printf("%d\n",result);


}

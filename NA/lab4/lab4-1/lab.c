#include <stdio.h>

int main() {

	int first, second, sum;
	
	printf("Enter two integers: ");
	scanf("%d%d", &first, &second);
	
	//Add two numbers in asm
	__asm__("addl %%ebx, %%eax;" : "=a" (sum) : "a"(first), "b"(second));
	

	printf( "%d + %d = %d\n", first, second, sum );
}

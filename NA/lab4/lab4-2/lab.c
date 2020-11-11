#include <stdio.h>

extern int multiply(int a, int b);

int main(){
	int result = multiply(5,6);
	printf("Result is %d\n", result);
}

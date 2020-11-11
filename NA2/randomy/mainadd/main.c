#include <stdio.h>
extern long long add (long long A, long long B);
int main()
{
	long long C = add (15LLU, 30LLU);
	printf ("%llu", C);
	return 0;
}

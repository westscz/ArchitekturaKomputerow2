#include <stdio.h>
extern long long* sqr (long long* A, int len);
int main()
{
	long long A [] = {1, 10, 100, 1000};
	long long* result = sqr(A,4);
	int i;
	for( i=0; i<4; i++)
		printf ("%llu\n", result[i]);
	return 0;
}

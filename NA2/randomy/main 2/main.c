#include <stdio.h>
extern long long add (long long* A, int len);
int main()
{
	long long A [] = {1, 10, 100, 1000};
	printf ("%llu\n", add(A,4));
	return 0;
}

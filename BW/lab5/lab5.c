#include <stdio.h>
#include "rdtsc.c"
float calka (float xp,float xk,int iloscKrokow);

int main(int argx,char *argv[])
{
	float xp=0.001;
	float xk=1000;
	int iloscKrokow=10000000;
	long long int tp,tk;
	tp=rdtsc();
	float cal=calka(xp,xk,iloscKrokow);
	tk=rdtsc();
	tk-=tp;
	printf("Calka od %.3f do %.3f ilosc krokow %d wynosi: %f \ncykle: %lld\n",xp,xk,iloscKrokow,cal,tk);
	return 0;
}

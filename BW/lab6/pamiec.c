#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "rdtsc.c"
	const int wielkoscTablic=268435456;
	int tab1[268435456];
	int tab2[268435456];
	int main()
	{
	srand(time(NULL));
	long long int tp,tk;
	for(int i=0;i<32456;i++)
	{
	tab1[i]=tab1[i]+1;
	}
	for (int i=0;i<5000;i++)
	{
	tp=rdtsc();
	tab2[i]+=1;
	tk=rdtsc();
	tk-=tp;
	
	if(tk>1000)
	{
	printf("komorka : %p , czas: %lld \n",&tab2[i],tk);
	}
	}
	int iloscProb=10000000;
	long long int czasOdczytu=0;
	long long int czasZapisu=0;
	for (int i=0;i<iloscProb;i++)
	{
		int numerId=rand()%wielkoscTablic;
		tp=rdtsc();		
		tab2[numerId];
		tk=rdtsc();
		tk-=tp;
		czasOdczytu+=tk;
	}
	for (int i=0;i<iloscProb;i++)
	{
		int numerId=rand()%wielkoscTablic;
		tp=rdtsc();		
		tab2[numerId]+=1;
		tk=rdtsc();
		tk-=tp;
		czasZapisu+=tk;
	}

	double sredniCzas=czasOdczytu;
	sredniCzas/=iloscProb;
	double sredniCzasZap=czasZapisu;
	sredniCzasZap/=iloscProb;
	printf("sredni czas odczytu: %f\n sredni czas zapisu: %f\n",sredniCzas,sredniCzasZap); 
	return 0;
	}

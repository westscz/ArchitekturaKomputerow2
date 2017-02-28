/*
    Ogolem - mierzenie czasu w taktach procesora. 

    KONIECZNE DO OGARNIECIA: jak przeliczyc ilosc taktow na sekundy?
    (moze pytanie dla niektorych okaze sie smiesznie latwe jednak
    miny ludzi na laborkach przekonaly mnie ze to jednak bardzo wazne
    pytanie)
*/
#include<stdio.h>
extern unsigned long long urdtsc(char);

int main(void) {
	printf("%llu \n",urdtsc(0));
	return 0;
}

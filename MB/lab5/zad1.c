/*
    Zabawa z cache. Nie na kazdym komputerze pojdzie.
    Dokumentacja tutaj konieczna coby obronic swoj kod
    ktory nie pokazuje "wlasciwych" wynikow.
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define ELEMENTY 4096
extern unsigned long long urdtsc(char);

int main(void) {
	int macierz[512*64*2];
	register int i, j, k;
	unsigned long long time = 0;
	int temp = 0;


	for(k=0; k<10; k++) {
		
		time = urdtsc(1);
		temp = macierz[0];
		time = urdtsc(1) - time;
		printf("---ponowne mov: %llu \n", time);
		time = urdtsc(1);
		temp = macierz[512/4*64];
		time = urdtsc(1) - time;
		printf("3072 mov: %llu \n", time);
	}

	return temp;
}


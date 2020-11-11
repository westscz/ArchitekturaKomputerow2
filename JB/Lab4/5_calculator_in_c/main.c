#include <stdio.h>
#include<string.h>
#include<stdlib.h>

extern int calc( char *op);

//TODO zmienić string w calculatorze na forme 123+456 bez spacji


int main(){
//	char op [12];
//	scanf("%s",op);
	char op[]="123 + 456\n";
	int wynik;

	wynik = calc(op);
	printf("Wynik dodawania = %d\n", wynik );
}

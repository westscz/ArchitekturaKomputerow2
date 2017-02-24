#include <stdio.h>

extern int silnia(int num);

int main(){
	int wartosc;
	scanf("%d", &wartosc);
	int wynik = silnia(wartosc);
	printf("Silnia z %d = %d\n",wartosc, wynik);
}

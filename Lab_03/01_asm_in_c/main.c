#include <stdio.h>

extern int add(int first, int second);

int main(){
	int wynik = add(8,8);
	printf("Wynik dodawania = %d\n", wynik);
}

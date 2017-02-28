/*
    Zabawa z FPU i zmienianiem zaokraglen itd. 

    http://zak.ict.pwr.wroc.pl/materials/architektura/laboratorium%20AK2/Dokumentacja/Intel%20Penium%20IV/IA-32%20Intel%20Architecture%20Software%20Developers%20Manual%20vol.%201%20-%20Basic%20Architecture.pdf
    strona 193 koniecznie!
*/

#include<stdio.h>
extern float fx(float);
extern float gx(float);
extern void zarzadzaj(int);

int main(void) {
/**
precyzje
0b--00 pojedyncza
0b--01 reserved?
0b--10 podwójna
0b--11 rozszerzona

zaokraglenia 
0b00-- do najblizszej
0b01-- do mniejszej
0b10-- do wiekszej
0b11-- do zera
*/

float liczba = 0.02;

	printf("zaokraglenia do najblizszej\n");
	zarzadzaj(0b0000);
	printf("float %f \n",fx(liczba));
	printf("float %f \n",gx(liczba));
	zarzadzaj(0b0010);
	printf("double %f \n",fx(liczba));
	printf("double %f \n",gx(liczba));
	zarzadzaj(0b0011);
	printf("ext %f \n",fx(liczba));
	printf("ext %f \n",gx(liczba));

	printf("\nzaokraglenia do mniejszej\n");
	zarzadzaj(0b0100);
	printf("float %f \n",fx(liczba));
	printf("float %f \n",gx(liczba));
	zarzadzaj(0b0110);
	printf("double %f \n",fx(liczba));
	printf("double %f \n",gx(liczba));
	zarzadzaj(0b0111);
	printf("ext %f \n",fx(liczba));
	printf("ext %f \n",gx(liczba));

	printf("\nzaokraglenia do wiekszej\n");
	zarzadzaj(0b1000);
	printf("float %f \n",fx(liczba));
	printf("float %f \n",gx(liczba));
	zarzadzaj(0b1010);
	printf("double %f \n",fx(liczba));
	printf("double %f \n",gx(liczba));
	zarzadzaj(0b1011);
	printf("ext %f \n",fx(liczba));
	printf("ext %f \n",gx(liczba));

	printf("\nzaokraglenia do zera\n");
	zarzadzaj(0b1100);
	printf("float %f \n",fx(liczba));
	printf("float %f \n",gx(liczba));
	zarzadzaj(0b1110);
	printf("double %f \n",fx(liczba));
	printf("double %f \n",gx(liczba));
	zarzadzaj(0b1111);
	printf("ext %f \n",fx(liczba));
	printf("ext %f \n",gx(liczba));
	return 0;
}

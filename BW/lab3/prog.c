/*Napisać funkcję w asemblerze dodającą 2 liczby wielokrotnej precyzji (np. 1024-bajtowe). 
Wywołać tę funkcję z poziomu programu w języku C, zademonstrować jej poprawność w trybie krokowym w debugerze.*/

#include "stdio.h"
#include "rdtsc.c"
extern char dodawanieBezPetli(char l1,char l2,char przeniesienie,char *wynik);
extern void dodawanieZPetla(char* l1, char* l2, char* wynik);
int main()
{
	int rozmiarTablic=1024;
	char l1[rozmiarTablic];
	char l2[rozmiarTablic];
	printf("Wprowadz pierwsza liczbe:");
	scanf("%1024s",l1);
	printf("Wprowadz druga liczbe:");
	scanf("%1024s",l2);
	
	int ileL1=0;
	int ileL2=0;
	while(l1[++ileL1]);
	while(l2[++ileL2]);
	int max;
	if(ileL1>ileL2)
		max=ileL1;
	else
		max=ileL2;
	for(int i=1;i<=ileL1;i++)
		l1[rozmiarTablic-i]=l1[ileL1-i];
		
	for(int i=0;i<rozmiarTablic-ileL1;i++)
		l1[i]='0';
	
	for(int i=1;i<=ileL2;i++)
		l2[rozmiarTablic-i]=l2[ileL2-i];
	
	for(int i=0;i<rozmiarTablic-ileL2;i++)
		l2[i]='0';
	
	char wynik[rozmiarTablic+1];
	
	for(int i=0;i<rozmiarTablic;i++)
	{
		l1[i]-='0';
		l2[i]-='0';
	}
	long long int iloscTaktowPoczatkowa=rdtsc();
	dodawanieZPetla(l1,l2,wynik);
	long long int iloscTaktowKoncowa=rdtsc();
	long long int iloscTaktowPrzyDodawaniuZPetla=iloscTaktowKoncowa-iloscTaktowPoczatkowa;
	for(int i=0;i<rozmiarTablic+1;i++)
	{
		wynik[i]+='0';
	}
	for(int i=0;i<=max;i++)
	{
		wynik[i]=wynik[rozmiarTablic-max+i];
	}
	wynik[max+1]=0;
	printf("wynik dodawania z petla: %s , ilosc cykli: %lld \n",wynik,iloscTaktowPrzyDodawaniuZPetla);
	char przeniesienie=0;
	char wynikBezPetli[rozmiarTablic+1];
	iloscTaktowPoczatkowa=rdtsc();
	for(int i=rozmiarTablic-1;i>=0;i--)
	{
		przeniesienie=dodawanieBezPetli(l1[i],l2[i],przeniesienie,&wynikBezPetli[i+1]);
	}
	wynikBezPetli[0]=przeniesienie;
	iloscTaktowKoncowa=rdtsc();
	long long int iloscTaktowPrzyDodawaniuBezPetli=iloscTaktowKoncowa-iloscTaktowPoczatkowa;
	for(int i=0;i<rozmiarTablic+1;i++)
	{
		wynikBezPetli[i]+='0';
	}
	for(int i=0;i<=max;i++)
	{
		wynikBezPetli[i]=wynikBezPetli[rozmiarTablic-max+i];
	}
	wynikBezPetli[max+1]=0;
	printf("wynik dodawania bez petli: %s , ilosc cykli: %lld \n",wynikBezPetli,iloscTaktowPrzyDodawaniuBezPetli);
	
}

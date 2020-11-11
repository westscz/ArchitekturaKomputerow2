#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
void enter();
void menu(float from, float to,unsigned long long iterations);

float integrate(double from, double to, unsigned int iterations);

int main(int argc, char * argv[]){
	int i=0, end = 0, ok = 0;
	char choice;
	float data[3] = {0.001, 1000.0, 0.0};
	unsigned long long int stepNumber=1000,time1,time2,timeResult=0;
	while(!end){
		system("clear");
		menu(data[0],data[1],stepNumber);
		scanf("%s", &choice);

		switch(choice){
		case 'p':
			printf("Zmieniasz poczatek przedzialu:\n >");
			scanf("%f", &data[0]);
			break;
		case 'k':
			printf("Zmieniasz koniec przedzialu:\n >");
			scanf("%f", &data[1]);
			break;
		case 'i':
			while(!ok){
				printf("Zmieniasz ilosc przedzialow:\n >");
				scanf("%lld", &stepNumber);
				if(stepNumber % 4){
					printf(" ! Podaj liczbe podzielna przez 4.\n");
				} else ok = 1;
			}
			ok = 0;
			break;
		case 'c': 
			time1 = rdtsc();
			data[2] = integrate(data[0],data[1],stepNumber);
			time2 = rdtsc();
			timeResult = time2 - time1;
			printf("***RESULT*** %lf\n", data[2]);
			printf("***RESULT*** %lld\n",timeResult);
			//enter();
			end = 1;
			break;
		case 'q': 
			end = 1;
			break;
		default:
			printf("(!!!) Zla opcja.\n");
			enter();
			break;
		}
	}
return 0;
}


void enter(){
	printf("\n...nacisnij ENTER by kontynuowac...\n");
	getchar();
	while( getchar() != '\n');	
}

void menu(float from, float to, unsigned long long iterations){
	printf("\n--------------------------------------\n");
	printf("===> Calkowanie od:\t %lf\n", from);
	printf("===> Calkowanie do:\t %lf\n", to);
	printf("===> Iteracje:\t\t %lld\n", iterations);
	printf("--------------------------------------");
	printf("\nMENU\n");
	printf("   p - Zmien poczatek przedzialu\n");
	printf("   k - Zmien koniec przedzialu\n");
	printf("   i - Zmien ilosc przedzialow calkowania\n");
	printf("   c - Calkuj\n");
	printf("   q - KONIEC\n");
	printf("> ");
}


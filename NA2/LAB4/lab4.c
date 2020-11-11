#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void enter();
void fpu_help();
void change_help();
void operation_help();
void menu(double a, double b, double c, double from, double to, double x, 
	unsigned long long iterations, unsigned long long timeResult, unsigned short int controlWord);


void set_fpu(int number);
unsigned short get_fpu();

double fpu_add(double a, double b, unsigned char *result);
double fpu_sub(double a, double b);
double fpu_mul(double a, double b);
double fpu_div(double a, double b);
double integrate(double from, double to,unsigned int stepNumber);

unsigned char * binToHex(unsigned char * bin, int binSize);

int main(int argc, char * argv[]){
	unsigned short int controlWord;
	int i=0, end = 0, fpuChoice;
	char choice, operChoice, change;
	double dbls[3] = { 1.0, 1.0, 0.0 };
	double integr[3] = {0.000001, 1000.0, 0.0};
	unsigned char *result = (unsigned char*)malloc(10 * sizeof(char));
	char * hex;
	unsigned long long stepNumber=10, time1,time2,timeResult=0;
	controlWord = get_fpu();

	while(!end){
		system("clear");
		menu(dbls[0],dbls[1], dbls[2],integr[0],integr[1],integr[2],stepNumber,timeResult,controlWord);
		scanf("%s", &choice);

		switch(choice){
		case 'z':
			change_help();
			scanf("%s",&change);
			switch(change){ 
			case '1':
				printf("\nZmieniasz pierwsza liczbe:\n >");
				scanf("%lf", &dbls[0]);
				break;
			case '2':
				printf("Zmieniasz druga liczbe:\n >");
				scanf("%lf", &dbls[1]);
				break;
			case 'a':
				printf("Zmieniasz dolna granice calkowania:\n >");
				scanf("%lf", &integr[0]);
				break;
			case 'b':
					printf("Zmieniasz gorna granice calkowania:\n >");
				scanf("%lf", &integr[1]);
				break;
			case 'i':
				printf("Zmieniasz wartosc iteracji calkowania:\n >");
				scanf("%lld", &stepNumber);
				break;
			case 'q':
				break;
			default:
				printf("(!!!)Zla opcja!\n");
				enter();
				break;	
			}	
			break;

		case 'u': 
			fpu_help();
			scanf("%d", &fpuChoice);
			if (fpuChoice <1 || fpuChoice>8) {
				if (!fpuChoice) printf("(!!!) Zla opcja!\n");
				enter();
				break;
			}
			set_fpu(fpuChoice);
			break;

		case 'w':
			operation_help();
			scanf("%s", &operChoice);
			switch (operChoice) {
			case '+':
				dbls[2] = fpu_add(dbls[0], dbls[1],result);
				hex = binToHex(result,10);
				printf("\n***RESULT*** IEEE = 0x");
				for(i=6;i<=20;i++)printf("%c",hex[i]);
				printf("\n***RESULT*** %lf + %lf = %lf\n", dbls[0], dbls[1], dbls[2]);
				enter();
				break;
			case '-':
				dbls[2] = fpu_sub(dbls[0], dbls[1]);
				printf("***RESULT*** %lf - %lf = %lf\n", dbls[0], dbls[1], dbls[2]);
				enter();
				break;
			case '*':
				dbls[2] = fpu_mul(dbls[0], dbls[1]);
				printf("***RESULT*** %lf * %lf = %lf\n", dbls[0], dbls[1], dbls[2]);
				enter();
				break;
			case '/':
				dbls[2] = fpu_div(dbls[0], dbls[1]);
				printf("***RESULT*** %lf / %lf = %lf\n", dbls[0], dbls[1], dbls[2]);
				enter();
				break;
			case 'q': break;
			default:
				printf("(!!!) Zla opcja.\n");
				enter();
				break;
			}
			break;
		case 'c': 
			time1 = rdtsc();
			integr[2] = integrate(integr[0], integr[1], stepNumber);
			time2 = rdtsc();
			timeResult = time2 - time1;
			printf("***RESULT*** %lf\n", integr[2]);
			printf("***RESULT*** %lld\n",timeResult);
			enter();
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
}

unsigned char * binToHex(unsigned char * bin, int binSize){
	unsigned char * result = (unsigned char*)malloc(binSize*2);
	int i =0;
	char hex[] = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};	
	int low,high;

	for(i=0;i<binSize;i++){
		high = (bin[i]&(0xf0))>>4;
		low = bin[i]&15;

		result[(binSize-i)*2] = hex[high];
		result[(binSize-i)*2+1] = hex[low];
	}
	return result;
}

void enter(){
	printf("\n...nacisnij ENTER by kontynuowac...\n");
	getchar();
	while( getchar() != '\n');	
}

void menu(double a, double b, double c, double from, double to, double x, unsigned long long iterations, unsigned long long timeResult, unsigned short int controlWord){
	printf("\n--------------------------------------\n");
	printf("===> Pierwsza liczba:\t %lf\n", a);
	printf("===> Druga liczba:\t %lf\n", b);
	printf("===> Stary wynik:\t %lf\n\n", c);
	printf("===> Calkowanie od:\t %lf\n", from);
	printf("===> Calkowanie do:\t %lf\n", to);
	printf("===> Iteracje:\t\t %lld\n", iterations);
	printf("===> Stare calkowanie:\t %lf\n", x);
	printf("===> Stary czas calk:\t %lld\n\n",timeResult);
	controlWord = get_fpu();
	printf("===> FPU CW: %04hx\n", controlWord);
	printf("--------------------------------------");
	printf("\nMENU\n");
	printf("   z - Zmien wartosci\n");
	printf("   u - Ustaw precyzje i zaokraglenie\n");
	printf("   w - Wykonaj dzialanie\n");
	printf("   c - Calkuj\n");
	printf("   q - KONIEC\n");
	printf("> ");
}

void fpu_help(){
	printf("\nMenu precyzji i zaokraglania\n");
	printf("   1 - single down\n");
	printf("   2 - single up\n");
	printf("   3 - single nearest\n");
	printf("   4 - single zero\n");
	printf("   5 - double down\n");
	printf("   6 - double up\n");
	printf("   7 - double nearest\n");
	printf("   8 - double zero\n");
	printf("   q - WROC\n");
	printf("Co wybierasz?\n ");
	printf("> ");
}

void change_help(){
	printf("\nMenu zmian wartosci\n");
	printf("   1 - zmien pierwsza liczbe\n");
	printf("   2 - zmien druga liczbe\n");
	printf("   a - zmien dolny przedzial calkowania\n");
	printf("   b - zmien gorny przedzial calkowania\n");
	printf("   i - zmien ilosc iteracji calkowania\n");
	printf("   q - WROC\n");
	printf("Co wybierasz?\n ");
	printf("> ");
}

void operation_help(){
	printf("\nMenu dzialania\n");
	printf("   + - dodawanie\n");
	printf("   - - odejmowanie\n");
	printf("   * - mnozenie\n");
	printf("   / - dzielenie\n");
	printf("   q - WROC\n");
	printf("Co wybierasz?\n");
	printf("> ");

}

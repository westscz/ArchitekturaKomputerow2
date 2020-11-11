
/**
    Liczenie caleczki na czas z funkcji sinus.

    Pierwszy sposob pokazuje sposob z wykorzystaniem wylacznie c.
    Drugi sposob korzysta ze wsparcia ASMa z MMX i FPU.
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
extern unsigned long long urdtsc(char);
extern float szybciej(float, float);

int main(void) {
	float A = 3.0f;
	float B = 5.0f;
	float przesuniecie = 0.2f;
	float x = A;
	float wynik = 0;
	unsigned long long time = 0;
	unsigned long long time2 = 0;

	
	time = urdtsc(1);
	for (; x <= B; x += przesuniecie) {
		wynik += fabs(sinf(x)) * przesuniecie;
	}
	time = urdtsc(1) - time;
	printf("wynik w c: %f \n",wynik);
	printf("czas w c: %llu \n\n",time);

	printf("przekazuje a: %f \n",A);
	wynik = 0;
	x = A;
	time2 = urdtsc(1);
	for (; x <= B; x += przesuniecie) {
		if (x + przesuniecie + przesuniecie > B) {
			wynik += fabs(sinf(x)) * przesuniecie;
		} else {
			wynik += szybciej(x, przesuniecie);
			x += przesuniecie;
		}
	}
	time2 = urdtsc(1) - time2;

	printf("wynik ze wsparciem: %f \n",wynik);
	printf("czas ze wsparciem: %llu \n\n",time2);

	float proc = ((float)time2)/((float)time);
	printf("procent: %f \n\n",proc);
	return 0;
}


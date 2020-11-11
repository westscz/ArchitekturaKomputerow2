#include <stdio.h>
#include <stdlib.h>
int tab[1<<28], tabIdx[1<<28];

long long RDTSC;
inline void rdtsc(){
	asm("push %rax;push %rdx;	RDTSC;	movl %eax,RDTSC;	movl %edx, RDTSC+4;	pop %rdx;	pop %rax");
}

void generateRandTab(int *tabR, int n);

int main(int argc, char * argv[]){

	long long int size, i, x, n;
	unsigned long long start, stop;
	FILE *f1, *f2, *f3, *f4;

	f1 = fopen("zapis","w");
	f2 = fopen("odczyt","w");
	f3 = fopen("zapisLosowy","w");
	f4 = fopen("odczytLosowy","w");


	for(size = (1 << 2); size < (1 << 28); size <<= 1){

		for(i=0; i<size; i++) tabIdx[i] = i;

		rdtsc();
		start = RDTSC;
			for(i=0; i<size; ++i) tab[i] += 3;
		rdtsc();
		stop = RDTSC;
		fprintf(f1,"%lld ",size);
		fprintf(f1,"%llu\n",(stop-start)/size);

		
		start = RDTSC;
		for(i=0; i<size; ++i) x = tab[i];
		rdtsc();
		stop = RDTSC;
		fprintf(f2,"%lld ",size);
		fprintf(f2,"%llu\n",(stop-start)/size);

		generateRandTab(tabIdx, size);
		
		rdtsc();
		start = RDTSC;
			for(i=0; i<size; ++i) tab[tabIdx[i]] += 3;
		rdtsc();
		stop = RDTSC;
		fprintf(f3,"%lld ",size);
		fprintf(f3,"%llu\n",(stop-start)/size);

		rdtsc();
		start= RDTSC;
			for(i=0; i<size; ++i) x = tab[tabIdx[i]];
		rdtsc();
		stop = RDTSC;
		fprintf(f4,"%lld ",size);
		fprintf(f4,"%llu\n",(stop-start)/size);
	}

fclose(f1);
fclose(f2);
fclose(f3);
fclose(f4);

}

void generateRandTab(int *tabR,int n) {
	int i=0, j=0, tmp = 0;
	for(i=0; i<n; ++i){
	 j = rand() % n;
	 tmp = tabR[j];
	 tabR[j] = tabR[i];
	 tabR[i] = tmp;
}}

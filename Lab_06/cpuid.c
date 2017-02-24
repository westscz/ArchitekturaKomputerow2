#include <stdio.h>
#include <cpuid.h>

extern unsigned long _rdtsc();
extern void _adding();
int main()
{

	int a,b,c,d,lvl,i;

	lvl = 1;
	__get_cpuid(lvl,&a,&b,&c,&d);
	printf("Floating-point unit on-Chip: %d\n", d & 0x1);
	printf("Intel Architecture MMX technology supported: %d\n", d>>23 & 0x1);
	printf("Streaming SIMD Extensions supported: %d\n", d>>25 & 0x1);
	printf("Streaming SIMD 2 Extensions supported: %d\n", d>>26 & 0x1);
	printf("CLFLUSH line size: %d\n", b>>8 & 0xF);
	
	lvl = 2;
	__get_cpuid(lvl,&a,&b,&c,&d);
	for(i = 0;i<4;i++){
		printf("%x ",(a>>(i*8))&0xFF);
	}
	
	printf("\n");	
	int tab[16];
	int tablica[4096];
	int tablica2[5000];
	int tablica3[1024];
	int tablica4[4097];
	int tablica5[10000];
	int tablica6[4100];
	unsigned long start, stop;
	int loop=100000;
	//printf("%d\n",sizeof(int));	

	for(i=0;i<loop;i++){
		tab[i%16];
	}	
	stop = _rdtsc();
	printf("Time for 16 bytes:	%lu\n",stop-start);

	start = _rdtsc();
	for(i=0;i<loop;i++){
		tablica3[i%1024];
	}	
	stop = _rdtsc();
	printf("Time for 1024 bytes:	%lu\n",stop-start);

	start = _rdtsc();
	for(i=0;i<loop;i++){
		tablica[i%4096];}	
	stop = _rdtsc();
	printf("Time for 4096 bytes:	%lu\n",stop-start);


	start = _rdtsc();
	for(i=0;i<loop;i++){
		tablica4[i%4097];
	}	
	stop = _rdtsc();
	printf("Time for 4097 bytes:	%lu\n",stop-start);


	start = _rdtsc();
	for(i=0;i<loop;i++){
		tablica6[i%4100];
	}	
	stop = _rdtsc();
	printf("Time for 4100 bytes:	%lu\n",stop-start);

	start = _rdtsc();
	for(i=0;i<loop;i++){
		tablica2[i%5000];
	}	
	stop = _rdtsc();
	printf("Time for 5000 bytes:	%lu\n",stop-start);

	start = _rdtsc();
	for(i=0;i<loop;i++){
		tablica5[i%10000];
	}	
	stop = _rdtsc();
	printf("Time for 10000 bytes:	%lu\n",stop-start);

/*
	int tablica[1024];
	for(i=0;i<1024;i++){
		tablica[i]=_rdtsc()%64;
	}
*/

 return 0;
}

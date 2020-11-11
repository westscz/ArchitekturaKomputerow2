#include <stdio.h>
#include "rdtsc.c"
/* double, double -> double
 * function fpu_add adds 2 double FP numbers
 */
double fpu_add(double a, double b);

/* -> unsigned short (2B)
 * function get_fpu reads the FPU control word and returns it's value
 */
unsigned short get_fpu();
float calka(float od, float doktorego, int iloscKrokow);
/* 
 * 
 */
 void set_fpu(int);
int main(int argc, char * argv[])
{
    unsigned short int fpucw = 0x1234;
    double dbls[3] = {123.45, 0.123, 0.0};
    /* generate double constants */
    unsigned long dbl = 0x4000000000000000;
    double * wsk = &dbl;
    dbls[1] = *wsk;
   
    printf("unsigned long: %lx\n", dbl);
    printf("unsigned long: %lf\n", *wsk);

    dbls[2] = fpu_add(dbls[0], dbls[1]);
    printf("default: %lf + %lf = %lf\n", dbls[0], dbls[1], dbls[2]); 
    printf("FPU CW: %04hx\n", fpucw);
    /* add two numbers */
    dbls[2] = fpu_add(dbls[0], dbls[1]);
    printf("default: %lf + %lf = %lf\n", dbls[0], dbls[1], dbls[2]); 
    
    /* print FPU control word */
    fpucw = get_fpu();
    printf("FPU CW: %04hx\n", fpucw);
    set_fpu(0x0C00);
    
    fpucw = get_fpu();
    float od=0.001;
    float doktorego=1000.0;
    int ilosc=10000000; //maksymalna wartosc ktora moze byc wczytana do rejestru fpu
    long long int tp,tk;
    tp=rdtsc();
    float cal=calka(od,doktorego,ilosc);
    tk=rdtsc();
    tk-=tp;
    printf("calka od %f do %f o ilosc skokow: %i wynosi: %f , cykle: %lld\n",od,doktorego,ilosc,cal,tk);
    printf("FPU CW: %04hx\n", fpucw);

    return 0;
}

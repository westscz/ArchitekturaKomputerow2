#include "stdio.h"
#include "rdtsc.c"

int main()
{
  long long int tick1;
  long long int tick2;
  tick1=rdtsc();
  printf("%s","blablabla\n");
  tick2=rdtsc();
  tick2-=tick1;
  double ticks=tick2;
  ticks/=1199000000;
  printf("%s%f%s","Czas dzialania printf: ",ticks,"s\n");
  char napis[20];
  tick1=rdtsc();
  scanf("%19s",&napis);
  tick2=rdtsc();
  tick2-=tick1;
  ticks=tick2;
  ticks/=1199000000;
  printf("%s%f%s","Czas dzialania funckji scanf: ",ticks,"s\n");
  
}

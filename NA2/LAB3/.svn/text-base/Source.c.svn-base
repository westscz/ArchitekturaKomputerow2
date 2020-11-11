#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define ROZMIAR 4096

void add(unsigned char* bin1, unsigned char* bin2,  unsigned char* result, int bin1Size, int bin2Size, int resultSize);

unsigned char *hexToBin(char hex[], int *size);

void showResult(unsigned char *result, int resultSize);

int main(void) {
	char hex1[ROZMIAR], hex2[ROZMIAR];

	unsigned char *bin1, *bin2;
	int bin1Size, bin2Size, resultSize;

	scanf("%s", hex1);
    	scanf("%s", hex2);
	
	bin1 = hexToBin(hex1,&bin1Size);
	bin2 = hexToBin(hex2,&bin2Size);

	resultSize = (bin1Size>bin2Size)?bin1Size+1:bin2Size+1;
	unsigned char * result = (unsigned char*)malloc(resultSize);

	add(bin1,bin2,result,bin1Size,bin2Size,resultSize);

	showResult(result,resultSize);

	return 0;
}


unsigned char * hexToBin(char hex[], int *size) {
	int i, k = 0, dec = 0, length;

	for (length = 2; hex[length] != '\0'; ++length);	
	length = length - 2;
	unsigned char *tab = (unsigned char*)malloc(length/2+1);    

	for (i = 2; hex[i] != '\0'; ++i) {
		if 	(hex[i] >= '0' && hex[i] <= '9') dec += (hex[i] -'0');
		else if (hex[i] >= 'A' && hex[i] <= 'F') dec += (hex[i] -'A'+10);
		else if (hex[i] >= 'a' && hex[i] <= 'f') dec += (hex[i] -'a'+10);

		if(length%2 == i%2) dec *= 16;
		else { 
			tab[k++] = dec;
			dec = 0;
		}
	}

	*size = ((length%2) ? length/2+1 : length/2);
	return tab;
}

void showResult(unsigned char *result, int resultSize){
	int i, bit;
	printf("-->Wynik: 0b");
	for(i=0; i<resultSize; i++) for(bit = 7; bit >= 0; bit--){
  		printf("%d", ((result[i] & (1 << bit)) >> bit));
		if(bit == 4 || bit == 0)printf(" ");
	}	
	printf("\n");

}

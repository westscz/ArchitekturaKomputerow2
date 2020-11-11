#include <stdio.h>

extern int setPrecision(int precision);
extern int checkPrecision();

int clarifyPrecision(int precision){
	switch (precision){
		
		case 0:
			printf("Single precision\n");
			break;
		case 2:
			printf("Duouble precision\n");
			break;
		case 3: 
			printf("Extended double precision\n");
			break;
		default:
			printf("Wrong value in precision field!\n");
			break;
	
	}
}

int main(){
	int precision;
 	precision = checkPrecision();
	printf("Current precision is %d\n",precision);
	
	clarifyPrecision(precision);

	printf("Set new precision: \n");
	scanf("%d",&precision);
	setPrecision(precision);

	precision = checkPrecision();
	printf("New precision set to %d\n",precision);
	clarifyPrecision(precision);

	
}

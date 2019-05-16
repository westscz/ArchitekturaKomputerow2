#include <stdio.h>

extern int get_status_word();
extern int get_control_word();
int main(){
	int status = get_status_word();
	printf("Status= %d\n", status);
	status = get_control_word();
	return 0;
}

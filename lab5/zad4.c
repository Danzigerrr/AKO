#include <stdio.h>

extern void int_na_float(int*, float*);

int main()
{

	int inty[2] = { 5,8 };
	float floaty[2] = {0.0,0.0};
	int_na_float(inty, floaty);

	
	printf("%f   %f ", floaty[0], floaty[1]);
	
	
	return 0;
}


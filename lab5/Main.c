#include <stdio.h> 
extern float nowy_exp(float x);
int main()
{
	float n = 2.5;


	float wynik = nowy_exp(n);

	printf("n = %f", wynik);
	
	return 0;
}

#include <stdio.h> 
void konwersja_32_na_64_w_pamieci(float* ptr1, double* ptr2);

int main()
{
	float a = 2.0f;
	double b = 1.5f;
	konwersja_32_na_64_w_pamieci(&a, &b);

	return 0;
}


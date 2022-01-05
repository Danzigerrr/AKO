#include <stdio.h>
#include <stdlib.h> 

float dylatacja_czasu(unsigned int delta_t_zero, float predkosc);
void szybki_max(int t_1[], int t_2[], int t_wynik[], int n);

int main()
{


	float res = dylatacja_czasu(10, 10000.0f);

	printf("dylatacja= %f\n\n", res);


	int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
	int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
	int wynik[8];
	int n = 8;

	szybki_max(val1, val2, wynik, n); // -> wynik = {1, -1, 2, -1, 3, 1, 4, 3}

	printf("max= ");
	for (int i = 0; i < n; i++)
		printf("%d, ", wynik[i]);
	return 0;
}



#include <stdio.h> 
extern float srednia_harm(float* tablica, unsigned int n);
int main()
{
	unsigned int n = 3;
	float* tab = malloc(n * sizeof(float));
	
	tab[0] = 2.0;
	tab[1] = 3.0;
	tab[2] = 4.0;


	float wynik = srednia_harm(tab, n);

	printf("n = %f", wynik);
	
	return 0;
}

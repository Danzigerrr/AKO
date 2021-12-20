#include <stdio.h> 
float sr_kwadrat(float*, int n);

int main()
{
	int n = 3;
	float *tab = (float*) malloc(n * sizeof(float));
	
	for (int i = 0; i < n; i++)
		tab[i] = i+1;

	float wynik = sr_kwadrat(tab, n);

	printf("%f ", wynik);
	

	return 0;
}

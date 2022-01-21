#include <stdio.h> 
void pole_kola(float* pr);
int main()
{
	float k;
	printf("\nProszę podać promień: ");
	scanf_s("%f", &k);
	pole_kola(&k);
	printf("\nPole koła wynosi %f\n", k);
	return 0;
}


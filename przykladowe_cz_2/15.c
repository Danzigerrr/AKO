#include <stdio.h> 
float avg_wd(int n, void* tablica, void* wagi);

int main()
{
	
	int n = 4;

	float tablica[4] = {1.0, 2.0, 3.0, 4.0};


	float wagi[4] = { 5.0,6.0,7.0,8.0};

	float wynik = avg_wd(n, tablica, wagi);

	printf("%f", wynik);

	return 0;
}


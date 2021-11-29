#include <stdio.h> 
int szukaj_max(int a, int b, int c, int d);
int main()
{
	int x, y, z, v, wynik;
	printf("\nProszê podaæ trzy liczby ca³kowite ze znakiem: ");
	scanf_s("%d %d %d %d", &x, &y, &z, &v);
	wynik = szukaj_max(x, y, z, v);
	printf("\nSpoœród podanych liczb %d, %d, %d, %d liczba % d jest najwiêksza\n", x,y,z,v, wynik); 
		return 0;
}

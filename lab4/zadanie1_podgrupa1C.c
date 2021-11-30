#include <stdio.h> 
int suma(int n, int v0, int v1, int v2, int	v3, int v4, int v5, int v6);
int main()
{
	int n = 7;

	int v[7] =	{ 7,6,5,4,3,2,1 };
	int wartosc_suma;
	wartosc_suma = suma(n, v[0],v[1],v[2],v[3],v[4],v[5],v[6]);
	printf("\nSuma wynosi %d\n", wartosc_suma);
	return 0;
}
/*

int suma(int n, int v0, int v1 ,int v2, int	v3, int v4, int v5 , int v6);
int main()
{

	int n = 7;

	int liczby[7] =
	{ 7,6,5,4,3,2,1};
	int wartosc_suma;
	wartosc_suma = suma(n, liczby[0], liczby[1], liczby[2], 
		liczby[3], liczby[4], liczby[5], liczby[6]);
	printf("\n Suma elementów tablicy wynosi %d\n", wartosc_suma);

	return 0;
}

*/
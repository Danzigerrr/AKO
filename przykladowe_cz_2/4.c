
#include <stdio.h> 
int* szukaj_elem_min(int tablica[], int n);
int main()
{
	int *wsk;
	int pomiary[] = { 4,6,2,5,4,7,9 }; //musi byc 7 elementow

	wsk = szukaj_elem_min(pomiary, 7);
	printf("\Element minimalny = %d\n", *wsk);

	return 0;
}

#include <stdio.h> 

void przestaw(int tablica[], int rozmiar);
int main()
{
	int tab[8] = {6,5,4,3,9,6,1,5};
	int size = 8;
	
	przestaw(tab, size);

	for(int i=0;i<size;i++)
		printf(" %d", tab[i]);

	return 0;
}

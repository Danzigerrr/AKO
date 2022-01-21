#include <stdio.h> 
#include <windows.h> 
unsigned int liczba_procesow();

int main()
{
	int lp;

	lp = liczba_procesow();

	printf("%d", lp);

	return 0;
}


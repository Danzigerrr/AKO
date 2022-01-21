#include <stdio.h> 
#include <windows.h> 
unsigned int sortowanie(int* tabl, unsigned int n);

int main()
{
	int n = 5;
	int tabl[5] = {2,3,5,1,4};

	int max = sortowanie(tabl, n);

	printf("%d", max);

	return 0;
}


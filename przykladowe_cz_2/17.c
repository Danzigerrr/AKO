#include <stdio.h> 
#include <windows.h> 
unsigned __int64 sortowanie(unsigned __int64* tabl, unsigned int n);

int main()
{
	int n = 5;
	unsigned __int64 tabl[5] = {3,4,1,2,5};

	unsigned __int64 max = sortowanie(tabl, n);

	printf("%I64d", max);

	return 0;
}


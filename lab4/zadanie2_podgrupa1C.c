/* Poszukiwanie najwiêkszego elementu w tablicy liczb
ca³kowitych za pomoca funkcji (podprogramu)
szukaj64_max, ktora zostala zakodowana w asemblerze.
Wersja 64-bitowa
*/
#include <stdio.h>
extern __int64 suma(__int64 n, __int64 v0, __int64 v1 ,__int64 v2, __int64
	v3, __int64 v4, __int64 v5 , __int64 v6);
int main()
{

	__int64 n = 7;

	__int64 liczby[7] =
	{ 7,6,5,4,3,2,1};
	__int64 wartosc_suma;
	wartosc_suma = suma(n, liczby[0], liczby[1], liczby[2], 
		liczby[3], liczby[4], liczby[5], liczby[6]);
	printf("\n Suma elementów tablicy wynosi %I64d\n",
		wartosc_suma);

	return 0;
}

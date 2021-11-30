/* Poszukiwanie najwiêkszego elementu w tablicy liczb
ca³kowitych za pomoca funkcji (podprogramu)
szukaj64_max, ktora zostala zakodowana w asemblerze.
Wersja 64-bitowa
*/
#include <stdio.h>
extern __int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64
	v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);
int main()
{
	__int64 wyniki[7] =
	{ 7,6,5,4,3,2,1};
	__int64 wartosc_suma;
	wartosc_suma = suma_siedmiu_liczb(wyniki[0], wyniki[1],
		wyniki[2], wyniki[3], wyniki[4], wyniki[5], wyniki[6]);
	printf("\n Suma elementów tablicy wynosi %I64d\n",
		wartosc_suma);

	return 0;
}

#include <stdio.h>

void wyznacz_sumy_SSE(char*, char*, char*);

int main()
{

	char liczby_A[16] = { -128, -127, -126, -125, -124, -123, -122, -121, 120, 121, 122, 123, 124, 125, 126, 127 };
	char liczby_B[16] = { -3,   -3,   -3,   -3,   -3,   -3,   -3,   -3,   3,   3,   3,   3,   3,   3,   3,   3 };
	//oczekiwane wyniki   = { -131, -130, -129, -128, -127, -126, -125, -124, 123, 124, 125, 126, 127, 128, 129, 130};
	char wyniki[16];
	wyznacz_sumy_SSE(liczby_A, liczby_B, wyniki);

	for (int i = 0; i < 16; i++)
	{
		printf("%d", liczby_A[i]);
		if (i < 15) printf(", ");
		else printf("\n");
	}
	for (int i = 0; i < 16; i++)
	{
		printf("%d", liczby_B[i]);
		if (i < 15) printf(", ");
		else printf("\n");
	}
	for (int i = 0; i < 16; i++)
	{
		printf("%d", wyniki[i]);
		if (i < 15) printf(", ");
		else printf("\n");
	}
	printf("(Pozorne) bledy w obliczeniach wynikaja z wykonywania obliczen\
		\nzgodnie z regula tzw. arytmetki nasycenia:\
		\njeśli wynik przekroczy zakres (w tym wypadku liczby <-127,127>),\
		\nwpisywana jest najwieksza/najmniejsza liczba, dopusczona w danym formacie\n");

	return 0;
}



#include <stdio.h> 
char* komunikat(char* tekst);
int main()
{
	char tekst1[] = "siema";
	char *kopia = komunikat(tekst1);

	printf("%s\n", kopia);

	return 0;
}

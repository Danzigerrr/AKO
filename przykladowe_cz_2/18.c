#include <stdio.h> 
#include <windows.h> 
wchar_t* ASCII_na_UTF16(char* znaki, int n);

int main()
{
	int n = 5;
	char znaki[5] = {'a','c','z','e','f'};

	wchar_t* gotowe = ASCII_na_UTF16(znaki, n);

	printf("%c", gotowe[0]);

	return 0;
}

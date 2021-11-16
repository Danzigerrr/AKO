comment |
2. Opracować nową wersję podprogramu wczytującego liczbę dziesiątna, który wczyta liczbę ze znakiem i zachowa ją w rejestrze EAX w kodzie 
U2 Podprogram nazwać wczytaj_EAX_U2_ Przykład działania: 

konsola: 15 enter
Wypisze-> stan EAX: OOOOOOOFh 

konsola: +1 enter
Wypisze -> stan EAX: 00000001h 

konsola: -1 enter
Wypisze -> stan EAX: FFFFFFFFh 

Działanie obu podprogramów na raz można sprawdzić np. tak: 
Call wczytaj_eax_u2 ; wpisujemy 5 enter
sub eax, 10 
call wyswietl_EAX U2 ; w konsoli wyświetla się -5 

|

.686
.model flat
	extern _ExitProcess@4 : PROC
	extern __write : PROC ; (dwa znaki podkreślenia)
	extern __read : PROC ; (dwa znaki podkreślenia)
	public _main
; obszar danych programu
.data
	; deklaracja tablicy 12 - bajtowej do przechowywania
	; tworzonych cyfr
	znaki db 12 dup(? )
	dziesiec dd 10 ; mnożnik
	                      
; obszar instrukcji(rozkazów) programu
.code	
	wczytaj_EAX_U2 PROC
		;Zapisanie wartości rejestrów
		push EBX 
		push ECX 
		push EDX 
		push ESI 

		; max ilość znaków wczytywanej liczby
		push dword PTR 12
		push dword PTR OFFSET znaki ; adres obszaru pamięci
		push dword PTR 0; numer urządzenia (0 dla klawiatury)
		call __read ; odczytywanie znaków z klawiatury
		; (dwa znaki podkreślenia przed read)

		add esp, 12 ; usunięcie parametrów ze stosu
		; bieżąca wartość przekształcanej liczby przechowywana jest
		; w rejestrze EAX; przyjmujemy 0 jako wartość początkową
		mov eax, 0
		mov ebx, OFFSET znaki ; adres obszaru ze znakami

		;sprawdzanie czy pierszy znak to minus
		mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
			; ASCII
		inc ebx ; zwiększenie indeksu

		mov esi, 0 ;używanie esi jako flaga czy liczba jest ujemna
		cmp cl, 43 ; czy plus
			je pobieraj_znaki
		cmp cl, 45 ; czy minus
			jne to_liczba
		
		mov esi, 1

		pobieraj_znaki:
			mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
			; ASCII
			inc ebx ; zwiększenie indeksu

			to_liczba:
			cmp cl,10 ; sprawdzenie czy naciśnięto Enter
			je byl_enter ; skok, gdy naciśnięto Enter
			sub cl, 30H ; zamiana kodu ASCII na wartość cyfry
			movzx ecx, cl ; przechowanie wartości cyfry w
			; rejestrze ECX
			; mnożenie wcześniej obliczonej wartości razy 10
			mul dword PTR dziesiec
			add eax, ecx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na początek pętli

		byl_enter:
		cmp esi, 1 ;sparwdzamy czy ujemna
			jne przywroc
		;inaczej
			neg eax
		przywroc:
		;Przywróć wartości rejestrów
		pop ESI 
		pop EDX
		pop ECX
		pop EBX
		ret
	wczytaj_EAX_U2 ENDP

	wyswietl_EAX_U2 PROC
		pusha
		mov ecx, eax ;kopiowanie eax
		rol ecx, 1   ;sprawdzanie czy liczba ujemna
			jnc liczba_dodatnia
		neg eax
		mov ecx, 1 ;ecx teraz jako flaga czy liczba jest ujemna
		jmp dalej
		liczba_dodatnia:
			mov ecx, 0
		dalej:
		mov esi, 10; indeks w tablicy 'znaki'
		mov ebx, 10; dzielnik równy 10
		konwersja:
			mov edx, 0; zerowanie starszej części dzielnej
			div ebx; dzielenie przez 10, reszta w EDX,
			; iloraz w EAX
			add dl, 30H; zamiana reszty z dzielenia na kod
			; ASCII
			mov znaki[esi], dl; zapisanie cyfry w kodzie ASCII
			dec esi; zmniejszenie indeksu
			cmp eax, 0; sprawdzenie czy iloraz = 0
		jne konwersja; skok, gdy iloraz niezerowy
			; wypełnienie pozostałych bajtów spacjami i wpisanie
			; znaków nowego wiersza
		cmp ecx, 1 ; jeżeli ujemna
			je dodaj_minus
		; jak nie to daj +
			mov znaki[esi], 43
			dec esi
			jmp wypeln
		dodaj_minus:
			mov znaki[esi], 45 ;dodaj minus
			dec esi
		wypeln:
			or esi, esi
			jz wyswietl; skok, gdy ESI = 0
			mov byte PTR znaki[esi], 20H; kod spacji
			dec esi; zmniejszenie indeksu
		jmp wypeln

		wyswietl :
			mov byte PTR znaki[0], 10; kod nowego wiersza
			mov byte PTR znaki[11], 10; kod nowego wiersza
			; wyświetlenie cyfr na ekranie
			push dword PTR 12; liczba wyświetlanych znaków
			push dword PTR OFFSET znaki; adres wyśw.obszaru
			push dword PTR 1; numer urządzenia(ekran ma numer 1)
			call __write; wyświetlenie liczby na ekranie
			add esp, 12; usunięcie parametrów ze stosu
		popa
		ret
	wyswietl_EAX_U2 ENDP

	_main PROC

		call wczytaj_EAX_U2
		sub eax, 10
		call wyswietl_EAX_U2

		push 0
		call _ExitProcess@4
	_main ENDP
END

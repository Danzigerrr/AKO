comment |
2. Opracowa� now� wersj� podprogramu wczytuj�cego liczb� dziesi�tna, kt�ry wczyta liczb� ze znakiem i zachowa j� w rejestrze EAX w kodzie 
U2 Podprogram nazwa� wczytaj_EAX_U2_ Przyk�ad dzia�ania: 

konsola: 15 enter
Wypisze-> stan EAX: OOOOOOOFh 

konsola: +1 enter
Wypisze -> stan EAX: 00000001h 

konsola: -1 enter
Wypisze -> stan EAX: FFFFFFFFh 

Dzia�anie obu podprogram�w na raz mo�na sprawdzi� np. tak: 
Call wczytaj_eax_u2 ; wpisujemy 5 enter
sub eax, 10 
call wyswietl_EAX U2 ; w konsoli wy�wietla si� -5 

|

.686
.model flat
	extern _ExitProcess@4 : PROC
	extern __write : PROC ; (dwa znaki podkre�lenia)
	extern __read : PROC ; (dwa znaki podkre�lenia)
	public _main
; obszar danych programu
.data
	; deklaracja tablicy 12 - bajtowej do przechowywania
	; tworzonych cyfr
	znaki db 12 dup(? )
	dziesiec dd 10 ; mno�nik
	                      
; obszar instrukcji(rozkaz�w) programu
.code	
	wczytaj_EAX_U2 PROC
		;Zapisanie warto�ci rejestr�w
		push EBX 
		push ECX 
		push EDX 
		push ESI 

		; max ilo�� znak�w wczytywanej liczby
		push dword PTR 12
		push dword PTR OFFSET znaki ; adres obszaru pami�ci
		push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
		call __read ; odczytywanie znak�w z klawiatury
		; (dwa znaki podkre�lenia przed read)

		add esp, 12 ; usuni�cie parametr�w ze stosu
		; bie��ca warto�� przekszta�canej liczby przechowywana jest
		; w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
		mov eax, 0
		mov ebx, OFFSET znaki ; adres obszaru ze znakami

		;sprawdzanie czy pierszy znak to minus
		mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
			; ASCII
		inc ebx ; zwi�kszenie indeksu

		mov esi, 0 ;u�ywanie esi jako flaga czy liczba jest ujemna
		cmp cl, 43 ; czy plus
			je pobieraj_znaki
		cmp cl, 45 ; czy minus
			jne to_liczba
		
		mov esi, 1

		pobieraj_znaki:
			mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
			; ASCII
			inc ebx ; zwi�kszenie indeksu

			to_liczba:
			cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
			je byl_enter ; skok, gdy naci�ni�to Enter
			sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
			movzx ecx, cl ; przechowanie warto�ci cyfry w
			; rejestrze ECX
			; mno�enie wcze�niej obliczonej warto�ci razy 10
			mul dword PTR dziesiec
			add eax, ecx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na pocz�tek p�tli

		byl_enter:
		cmp esi, 1 ;sparwdzamy czy ujemna
			jne przywroc
		;inaczej
			neg eax
		przywroc:
		;Przywr�� warto�ci rejestr�w
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
		mov ebx, 10; dzielnik r�wny 10
		konwersja:
			mov edx, 0; zerowanie starszej cz�ci dzielnej
			div ebx; dzielenie przez 10, reszta w EDX,
			; iloraz w EAX
			add dl, 30H; zamiana reszty z dzielenia na kod
			; ASCII
			mov znaki[esi], dl; zapisanie cyfry w kodzie ASCII
			dec esi; zmniejszenie indeksu
			cmp eax, 0; sprawdzenie czy iloraz = 0
		jne konwersja; skok, gdy iloraz niezerowy
			; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
			; znak�w nowego wiersza
		cmp ecx, 1 ; je�eli ujemna
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
			; wy�wietlenie cyfr na ekranie
			push dword PTR 12; liczba wy�wietlanych znak�w
			push dword PTR OFFSET znaki; adres wy�w.obszaru
			push dword PTR 1; numer urz�dzenia(ekran ma numer 1)
			call __write; wy�wietlenie liczby na ekranie
			add esp, 12; usuni�cie parametr�w ze stosu
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
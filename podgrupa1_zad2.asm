comment |
2. Opracowaæ now¹ wersjê podprogramu wczytuj¹cego liczbê dziesi¹tna, który wczyta liczbê ze znakiem i zachowa j¹ w rejestrze EAX w kodzie 
U2 Podprogram nazwaæ wczytaj_EAX_U2_ Przyk³ad dzia³ania: 

konsola: 15 enter
Wypisze-> stan EAX: OOOOOOOFh 

konsola: +1 enter
Wypisze -> stan EAX: 00000001h 

konsola: -1 enter
Wypisze -> stan EAX: FFFFFFFFh 

Dzia³anie obu podprogramów na raz mo¿na sprawdziæ np. tak: 
Call wczytaj_eax_u2 ; wpisujemy 5 enter
sub eax, 10 
call wyswietl_EAX U2 ; w konsoli wyœwietla siê -5 

|

.686
.model flat
	extern _ExitProcess@4 : PROC
	extern __write : PROC ; (dwa znaki podkreœlenia)
	extern __read : PROC ; (dwa znaki podkreœlenia)
	public _main
; obszar danych programu
.data
	; deklaracja tablicy 12 - bajtowej do przechowywania
	; tworzonych cyfr
	znaki db 12 dup(? )
	dziesiec dd 10 ; mno¿nik
	                      
; obszar instrukcji(rozkazów) programu
.code	
	wczytaj_EAX_U2 PROC
		;Zapisanie wartoœci rejestrów
		push EBX 
		push ECX 
		push EDX 
		push ESI 

		; max iloœæ znaków wczytywanej liczby
		push dword PTR 12
		push dword PTR OFFSET znaki ; adres obszaru pamiêci
		push dword PTR 0; numer urz¹dzenia (0 dla klawiatury)
		call __read ; odczytywanie znaków z klawiatury
		; (dwa znaki podkreœlenia przed read)

		add esp, 12 ; usuniêcie parametrów ze stosu
		; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest
		; w rejestrze EAX; przyjmujemy 0 jako wartoœæ pocz¹tkow¹
		mov eax, 0
		mov ebx, OFFSET znaki ; adres obszaru ze znakami

		;sprawdzanie czy pierszy znak to minus
		mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
			; ASCII
		inc ebx ; zwiêkszenie indeksu

		mov esi, 0 ;u¿ywanie esi jako flaga czy liczba jest ujemna
		cmp cl, 43 ; czy plus
			je pobieraj_znaki
		cmp cl, 45 ; czy minus
			jne to_liczba
		
		mov esi, 1

		pobieraj_znaki:
			mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
			; ASCII
			inc ebx ; zwiêkszenie indeksu

			to_liczba:
			cmp cl,10 ; sprawdzenie czy naciœniêto Enter
			je byl_enter ; skok, gdy naciœniêto Enter
			sub cl, 30H ; zamiana kodu ASCII na wartoœæ cyfry
			movzx ecx, cl ; przechowanie wartoœci cyfry w
			; rejestrze ECX
			; mno¿enie wczeœniej obliczonej wartoœci razy 10
			mul dword PTR dziesiec
			add eax, ecx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na pocz¹tek pêtli

		byl_enter:
		cmp esi, 1 ;sparwdzamy czy ujemna
			jne przywroc
		;inaczej
			neg eax
		przywroc:
		;Przywróæ wartoœci rejestrów
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
			mov edx, 0; zerowanie starszej czêœci dzielnej
			div ebx; dzielenie przez 10, reszta w EDX,
			; iloraz w EAX
			add dl, 30H; zamiana reszty z dzielenia na kod
			; ASCII
			mov znaki[esi], dl; zapisanie cyfry w kodzie ASCII
			dec esi; zmniejszenie indeksu
			cmp eax, 0; sprawdzenie czy iloraz = 0
		jne konwersja; skok, gdy iloraz niezerowy
			; wype³nienie pozosta³ych bajtów spacjami i wpisanie
			; znaków nowego wiersza
		cmp ecx, 1 ; je¿eli ujemna
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
			; wyœwietlenie cyfr na ekranie
			push dword PTR 12; liczba wyœwietlanych znaków
			push dword PTR OFFSET znaki; adres wyœw.obszaru
			push dword PTR 1; numer urz¹dzenia(ekran ma numer 1)
			call __write; wyœwietlenie liczby na ekranie
			add esp, 12; usuniêcie parametrów ze stosu
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
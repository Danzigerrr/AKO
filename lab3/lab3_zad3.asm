													; wczytywanie i wy�wietlanie tekstu wielkimi literami
													; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
obszar db 12 dup (?) 
znaki db 12 dup (?)
dziesiec dd 10
.code


read_into_eax PROC
	 push dword PTR 12
	 push dword PTR OFFSET obszar ; adres obszaru pami�ci
	 push dword PTR 0; numer urz�dzenia (0 dla klawiatury)
	 call __read ; odczytywanie znak�w z klawiatury (dwa znaki podkre�lenia przed read)
	 add esp, 12 ; usuni�cie parametr�w ze stosu bie��ca warto�� przekszta�canej liczby przechowywana jest w rejestrze EAX; przyjmujemy 0 jako warto�� pocz�tkow�
	 mov eax, 0
	 mov ebx, OFFSET obszar ; adres obszaru ze znakami
pobieraj_znaki:
	 mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII
	 inc ebx ; zwi�kszenie indeksu
	 cmp cl,10 ; sprawdzenie czy naci�ni�to Enter
	 je byl_enter ; skok, gdy naci�ni�to Enter
	 sub cl, 30H ; zamiana kodu ASCII na warto�� cyfry
	 movzx ecx, cl ; przechowanie warto�ci cyfry w rejestrze ECX mno�enie wcze�niej obliczonej warto�ci razy 10
	 mul dword PTR dziesiec
	 add eax, ecx ; dodanie ostatnio odczytanej cyfry
	 jmp pobieraj_znaki ; skok na pocz�tek p�tli 
byl_enter:
	; warto�� binarna wprowadzonej liczby znajduje si� teraz w rejestrze EAX 
	ret
read_into_eax ENDP

oblicz_eax PROC
	pusha
		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10

		konwersja:
		mov edx, 0 ; zerowanie starszej cz�ci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX,
		; iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod
		; ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy

		; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
		; znak�w nowego wiersza
		wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

		wyswietl:
		mov byte PTR znaki [0], 0AH ; kod nowego wiersza
		mov byte PTR znaki [11], 0AH ; kod nowego wiersza
		; wy�wietlenie cyfr na ekranie
		push dword PTR 12 ; liczba wy�wietlanych znak�w
		push dword PTR OFFSET znaki ; adres wy�w. obszaru
		push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
		call __write ; wy�wietlenie liczby na ekranie
		add esp, 12 ; usuni�cie parametr�w ze stosu 
	popa
	ret
oblicz_eax ENDP

second_power_eax proc
	
	mov ebx, eax
	mov edx, 0
	mul ebx
ret
second_power_eax endp


_main PROC

	;mov eax, 1234 ;set number

	call read_into_eax

	call second_power_eax

	call oblicz_eax

	push 0
	call _ExitProcess@4	
_main ENDP
END 
.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC
public _main
.data
znaki db 12 dup (?)
.code

wyswietl_EAX PROC
	pusha
	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik r�wny 10
	konwersja:
	mov edx, 0 ; zerowanie starszej cz�ci dzielnej
	div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
	add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
	mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
	dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy

	;wstaw odpowiedni znak na poczatek liczby:
	cmp edi,1
	jnz dodatnia
	jz ujemna
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

	dodatnia:
		mov znaki [esi], 43; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
	jmp wypeln

	ujemna:
		mov znaki [esi], 45; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
	jmp wypeln

wyswietl_EAX ENDP

_main PROC

	; EAX - liczba do wy�wietlenia
	; EBX - liczb�, kt�r� trzeba doda� aby otrzyma� element ci�gu
	; ECX - licznik liczb
	mov eax, -15
	mov ebx, 1
	mov ecx, 0


	start:
	mov edi, 0 ;jesli liczba ujemna esi =1

	test eax,eax
	jnl nie_zmieniaj_bo_dodatnia
		push eax ;zachowaj orginal

		;oblicz liczbe przeciwn�
		not eax
		add eax,1

		;flaga na 1
		mov edi, 1

	nie_zmieniaj_bo_dodatnia:

		call wyswietl_EAX

		; ustalenie nastepnej liczby
		cmp edi,1
		jz wez_orginal

		ustal_kolejna_liczbe:
		add eax, ebx
		inc ebx

		inc ecx
		cmp ecx, 50

	jne start

push 0
call _ExitProcess@4

	wez_orginal:
		pop eax
	jmp ustal_kolejna_liczbe

_main ENDP
END
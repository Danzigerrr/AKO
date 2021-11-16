
comment |

1. Opracować nową wersję podprogramu dokonującego konwersji liczby binarnej zawartej w rejestrze EAX na postać dziesiętna przy założeniu, 
że liczba w rejestrze EAX jest liczba ze znakiem (w kodzie U2). Podprogram nazwać U2 Bezpośrednio przed liczbą wyświetlaną w 
konsoli ma się pojawić znak liczby dla liczb dodatnich, dla liczb ujemnych). Napisać także krótki program przykładowo,' ilustrujący sposób 
podprogramu dla przypadków liczb dodatnich i ujemnych. 

Fragment programu głównego testującego podprogram: 
mov EAX, 15 
callvwswietl_EAX _U2 ; ->wkonsoli powinno pojawić się:  +15

movEAX,-15 
callwyswietl_EAX_U2 ; ->wkonsoli powinno pojawić się: -15

Wskazówka: jeśli liczba jest ujemna, to zmienić znak liczby (rozkaz NEG), zapamiętać znak, dalej postępować tak, jak dla liczby dodatniej, na końcu 
wyświetlić zapamiętamy znak. 

|


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
	mov ebx, 10 ; dzielnik równy 10
	konwersja:
	mov edx, 0 ; zerowanie starszej części dzielnej
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
	; wypełnienie pozostałych bajtów spacjami i wpisanie
	; znaków nowego wiersza
	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln
		wyswietl:
		mov byte PTR znaki [0], 0AH ; kod nowego wiersza
		mov byte PTR znaki [11], 0AH ; kod nowego wiersza
		; wyświetlenie cyfr na ekranie
		push dword PTR 12 ; liczba wyświetlanych znaków
		push dword PTR OFFSET znaki ; adres wyśw. obszaru
		push dword PTR 1; numer urządzenia (ekran ma numer 1)
		call __write ; wyświetlenie liczby na ekranie
		add esp, 12 ; usunięcie parametrów ze stosu
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

	; EAX - liczba do wyświetlenia
	; EBX - liczbą, którą trzeba dodać aby otrzymać element ciągu
	; ECX - licznik liczb
	mov eax, -15
	mov ebx, 1
	mov ecx, 0


	start:
	mov edi, 0 ;jesli liczba ujemna esi =1

	test eax,eax
	jnl nie_zmieniaj_bo_dodatnia
		push eax ;zachowaj orginal

		;oblicz liczbe przeciwną
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

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
;https://www.quora.com/Is-there-a-name-for-this-mathematical-sequence-1-2-4-7-11-16-22-29-37-46-56
public _main
.data

	; deklaracja tablicy 12-bajtowej do przechowywania tworzonych cyfr
	znaki db 12 dup (0)

.code

wyswietl_eax proc
	pusha

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
wyswietl_eax endp



_main PROC
	mov eax,1 ;number actual
	mov edi,0 ;positon

	call wyswietl_eax

	;mov ecx,50 ;repetitions of loop 
	push eax
triangle_num:
	;generate next triangle number
	pop eax
	add eax,edi
	push eax
	inc edi

	mov esi, 10 ; indeks w tablicy 'znaki'
	mov ebx, 10 ; dzielnik równy 10

	mov edx, 0
	konwersja:
	;jesli jest 10,11,12... to dodaj do edx 10 zeby zrekompesnowac nadwyzeke, a potem odejmij od edx 
		mov edx, 0 ; zerowanie starszej części dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX

		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		
		dec esi ; zmniejszenie indeksu
	cmp eax, 0 ; sprawdzenie czy iloraz = 0
	jne konwersja ; skok, gdy iloraz niezerowy


	; wypełnienie pozostałych bajtów spacjami i wpisanie
	; znaków nowego wiersza
	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
	dec esi ; zmniejszenie indeksu
	jmp wypeln

	wyswietl:
	call wyswietl_eax
	
	;next loop run
	cmp edi, 50h
	jne triangle_num

	add esp,4

	push 0
	call _ExitProcess@4 ; zakończenie programu

_main ENDP

	
END

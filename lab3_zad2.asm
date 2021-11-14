;Konwersja dziesiêtno–dwójkowa -> wczytaj liczbê z klawiatury
;DEC to BIN conversion -> read number from the keyboard

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main
.data

	; deklaracja tablicy 12-bajtowej do przechowywania tworzonych cyfr
	znaki db 12 dup (0)
	obszar db 12 dup (?)
	dziesiec dd 10 ;mnoznik
.code

wyswietl_eax proc
	pusha
		;mov byte ptr obszar[0], 0Ah
		mov byte ptr obszar[11], 0Ah

		push dword ptr 12h			;znaki
		push dword ptr offset obszar ;offset
		push dword ptr 1h			;source out

		call __write

		add esp,12

	popa
	ret
wyswietl_eax endp

wczytaj_do_eax proc
;zachowaj rejestry
	push ebx
	push edx
	push ecx

	push dword ptr 12 ;ilosc znakow
	push dword ptr offset obszar
	push dword ptr 0 ;source out
	call __read

	add esp,12 ;zmiana esp na stan przed __read

	mov eax,0
	mov ebx, offset obszar

	pobieraj_znaki:
		mov cl, [ebx] ;pobiesz cyfre (ASCII)

		cmp cl,10 ; czy enter?
		je byl_enter

		inc ebx ;ebx++
		sub cl,30h
		movzx ecx,cl ;zapisz cyfre (juz nie ASCII) w ECX

		mul dword ptr dziesiec ;pomnó¿ aktualnie eax
		add eax, ecx ; dodaj liczbe jednosci
	jmp pobieraj_znaki

	byl_enter:
	pop ecx
	pop edx
	pop ebx

	ret
wczytaj_do_eax endp

_main PROC


	call wczytaj_do_eax
	
	call wyswietl_eax

	push 0
	call _ExitProcess@4
_main ENDP
END


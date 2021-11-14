;Konwersja dziesiêtno–dwójkowa -> wczytaj liczbê z klawiatury
;DEC to BIN conversion -> read number from the keyboard

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main
.data


.code

wyswietl_eax_hex proc
	pusha ;przechowaj rejsertry

	;rezerwuj miejsce na stosie dla liczby tymczasowej
	sub esp,12
	mov edi, esp

		mov    esi, 11 ; znaki[i]
		mov    ebx, 10 ; dzielnik równy 10, bo nie mo¿na div 10 ;-;

	cont:
		mov    edx, 0  ; czyœcimy przed dzieleniem
		div    ebx     ; dzielenie przez 10, iloraz w EAX, reszta w EDX (< 10)
		add    dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov    [edi][esi], dl ; znaki[i] = dl, gdzie dl zawiera ASCII cyfry
		dec    esi    ; i--
		cmp    eax, 0 ; iloraz = 0?
		jne    cont   ; jedziemy dalej...

	fill: ; Reszta to spacje:
		mov    byte PTR [edi][esi], 20H ; znaki[i] = ' '
		dec    esi  ; i--
		jnz    fill ; i > 0? -> fill

		mov    byte PTR [edi][esi], 0AH ; /n na koniec

		; Wyœwietl EAX...
		push   12                     ; length
		push   dword ptr edi ; * znaki
		push   dword ptr 1            ; stdout
		call   __write
		add    esp, 12

		add    esp, 12 ;tymczasowa zmienna usuwana
	popa
	ret
wyswietl_eax_hex endp


wczytaj_do_eax_hex proc
;zachowaj rejestry na stosie
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp

	;12 bajtow na stosie -> tymczasowe przchowanie liczby hex
	sub esp,12
	mov esi, esp ;zachowaj esp

	;wczytaj liczbe:
	push dword ptr 10
	push esi
	push dword ptr 0
	call __read
	add esp,12

	
	mov eax, 0 ;wyzerwuj, wynik

	pocz_konw:
		mov dl,[esi] ;pobierz bajt
		inc esi ;indeks
		cmp dl, 10 ;czy enter?
		je gotowe

	;czy cyfra?
		cmp dl, '0'
		jb pocz_konw ;ignorowanie znaku -> ani liczba, ani litera
		cmp dl,'9'
		ja sprawdzaj_dalej ;to jest litera
		sub dl,'0' ;zmiana ASCII na wartosc cyfry

	dopisz:
		shl eax, 4 ; przesuneicie logiczne w lewo o 4 bity
		or al, dl ;dopisanie utwordzonego kody 4-bitowego na 4 ostatnie bitu rejestru eax
		
	jmp pocz_konw ;skok

	;czy znak byl z zakresu A-F
	sprawdzaj_dalej:
		cmp dl,'A'
		jb pocz_konw ;ignoruj
		cmp dl,'F'
		ja sprawdzaj_dalej2

		sub dl, 'A'-10 ;kod binarny
		jmp dopisz

	;czy znak byl z zakresu a-f
	sprawdzaj_dalej2:
		cmp dl, 'a'
		jb pocz_konw ;ingoruj
		cmp dl,'f'
		ja pocz_konw ;ignoruj
		sub dl, 'a'-10
		jmp dopisz

		
	gotowe:
		add esp,12 ;zwonlij liczbe tymczasow¹

		pop ebp
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx

	ret
wczytaj_do_eax_hex endp
_main PROC

	call wczytaj_do_eax_hex

	call wyswietl_eax_hex

	push 0
	call _ExitProcess@4
_main ENDP
END


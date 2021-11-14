;

;this is the solution for the fifth exercise
;conversion from Latin2 into Windows 1250
;first check big letter, then check small letter

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data
	magazyn_source db 30 dup (?)
	magazyn_dest db 30 dup (?)
	koniec_magazyn_dest db ?

	liczba_znakow dd ?
	liczba_spacji dd ?

.code



_main PROC
	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znaków
	push OFFSET magazyn_source
	push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znaków z klawiatury
	add esp, 12 ; usuniecie parametrów ze stosu

	; funkcja read wpisuje do rejestru EAX liczbê wprowadzonych znaków
	mov liczba_znakow, eax
	sub liczba_znakow, 2
	mov esi, liczba_znakow ;od 0 do indeksu ostantniego znaku w tablicy wpisanej

	calc_spaces:

	mov dl, magazyn_source[esi]

	cmp dl, 20h 
	jne no_space
	inc liczba_spacji ;dodaj spacje

	no_space: ;next loop iteration

	dec esi
	jnz calc_spaces

	add liczba_spacji, 1; dodaj jedn¹ spacje

	mov esi, liczba_znakow ; prawa bariera
	mov edi, 0 ; magazyn_dest indeks pocz¹tkowy
	mov ecx, 0 ; dlugosc slowa

	take_next_word: ;powtorz tyle razy ile jest spacji

		take_next_letter:
		mov dl, magazyn_source[esi] ; pobranie kolejnego znaku

		checkIfSpace: ;' '
		cmp dl, 20h
		je found_space

		; sterowanie pêtl¹
		inc ecx ;dlugosc slowa
		dec esi ; dekrementacja indeksu
		cmp esi, 0FFFFFFFFH
		jne take_next_letter	
		je last_word
		
		found_space: 
		;mov ecx, esi;  -> save space index
		;add ebx, 1 ; index of the first letter of the second word --> wczesniej waskuzuje na spacje
		;sub ecx,2

		mov ebx, 0 ;iterator, zwieksza sie az do ecx(cale slowo)
		add ecx, 1 ;add one more char(spacebar is first)
		
		save_word:
		mov dl, magazyn_source[esi+ebx]  ; pobranie kolejnego znaku
	
		mov magazyn_dest[edi],dl

		dec ecx ; magazyn_source dekrementacja indeks
		inc edi ; magazyn_dest inkrementacja indeks
		inc ebx;

		; sterowanie pêtl¹
		cmp ecx, 0
		ja save_word	

	dec esi ; take new char

	dec liczba_spacji
	jnz take_next_word

	;write setnacne in reversed order
	mov ecx,(OFFSET koniec_magazyn_dest) - (OFFSET magazyn_dest) 
	push ecx
	push OFFSET magazyn_dest + 1 ;+ 1 bo omijamy pierwsza zbedna spacje (adres tekstu)
	push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
	call __write ; wyœwietlenie tekstu pocz¹tkowego
	add esp, 12 ; usuniecie parametrów ze stosu

	push 0
	call _ExitProcess@4 ; zakoñczenie programu


	last_word:
	mov esi,0; wyzeruj
	mov magazyn_dest[edi],20h
	inc edi
	cmp esi,0;
	jmp found_space


_main ENDP
END

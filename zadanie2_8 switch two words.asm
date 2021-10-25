;this is the solution for the fifth exercise
;conversion from Latin2 into Windows 1250
;first check big letter, then check small letter
;work only for: '�','�','�','�','�','�'

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Write name and surname'
	db ', then press enter', 10
	koniec_t db ?
	magazyn db 20 dup (?)
	magazyn2 db 20 dup (?)
	koniec_magazyn2 db ?

	liczba_znakow dd ?

	tytul db ' Switched words ',0


.code

_main PROC
	; liczba znak�w tekstu informacyjnego
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	call __write ; wy�wietlenie tekstu pocz�tkowego
	add esp, 12 ; usuniecie parametr�w ze stosu

	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znak�w
	push OFFSET magazyn
	push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znak�w z klawiatury
	add esp, 12 ; usuniecie parametr�w ze stosu
	
	; funkcja read wpisuje do rejestru EAX liczb� wprowadzonych znak�w
	mov liczba_znakow, eax

	; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	mov ecx, eax
	mov ebx, 0 ; magazyn indeks pocz�tkowy
	mov esi, 0 ; magazyn2 indeks pocz�tkowy

	ptl1: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	checkIfSpace: ;' '
	cmp dl, 20h
	je foundSpace

	inc ebx ; inkrementacja indeksu

	; sterowanie p�tl�
	dec ecx;
	jnz ptl1

	foundSpace: 
	mov edx, ebx ; save space index
	add ebx,1 ; index of the first letter of the second word
	sub ecx,2

	; write second word
	ptl2: mov dl, magazyn[ebx]  ; pobranie kolejnego znaku
	
	mov magazyn2[esi],dl

	inc ebx ; magazyn inkrementacja indeks
	inc esi ; magazyn2 inkrementacja indeks
	; sterowanie p�tl�
	dec ecx;
	jnz ptl2


	mov magazyn2[esi], 20h ;space between words
	inc esi ;go one char to right to place next sign

	; write first word
	sub edx, 1 ; go one char back, to have the last letter of the first word
	mov ecx, edx ; set iterator
	mov ebx, 0 ; start index

	ptl3: mov dl, magazyn[ebx]  ; pobranie kolejnego znaku
	
	cmp dl, 20h
	je endWriting

	mov magazyn2[esi],dl

	inc ebx ; magazyn inkrementacja indeks
	inc esi ; magazyn2 inkrementacja indeks
	; sterowanie p�tl�
	dec ecx;
	jnz ptl3



	

	endWriting:

	mov ecx,(OFFSET koniec_magazyn2) - (OFFSET magazyn2)
	push ecx
	push OFFSET magazyn2 ; adres tekstu
	push 1 ; nr urz�dzenia (tu: ekran - nr 1)
	call __write ; wy�wietlenie tekstu pocz�tkowego
	add esp, 12 ; usuniecie parametr�w ze stosu

		
	;utf 8 
	push 0 ; constant for MB_OK
	push offset tytul ;title
	push offset magazyn2 ;text
	push 0 ;Null
	call _MessageBoxA@16


	push 0
	call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END

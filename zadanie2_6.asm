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
public _main
.data
	tekst_pocz db 10, 'Prosz� napisa� jaki� tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

	tytul db ' tytul ',0

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

	; kody ASCII napisanego tekstu zosta�y wprowadzone do obszaru 'magazyn'
	
	; funkcja read wpisuje do rejestru EAX liczb� wprowadzonych znak�w
	mov liczba_znakow, eax


	; rejestr ECX pe�ni rol� licznika obieg�w p�tli
	mov ecx, eax
	mov ebx, 0 ; indeks pocz�tkowy


	ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	;change normal ascii letters
	cmp dl, 'a'
	jb dalej ; jump if below
	cmp dl, 'z'
	ja checkA1 ; jump if above to check special letters
	sub dl, 20H ; change to uppercase
	jmp dalej

	checkA1:;'�' 
	cmp dl, 0a4h ;check if it is '�' in latin 2
	jne checkA2
	mov dl, 165 ;convert into '�' in Windows 1250
	jmp dalej

	checkA2:
	cmp dl, 0a5h ;'�'
	jne checkC1
	mov dl, 185
	jmp dalej

	checkC1:
	cmp dl, 8fH ;'�'
	jne checkC2
	mov dl, 198
	jmp dalej

	checkC2:
	cmp dl, 86H ;'�'
	jne checkE1
	mov dl, 230
	jmp dalej

	checkE1:
	cmp dl, 168 ;'�'
	jne checkE2
	mov dl, 202
	jmp dalej

	checkE2:
	cmp dl, 169 ;'�'
	jne dalej
	mov dl, 234
	jmp dalej


	dalej:
	mov magazyn[ebx], dl ; odes�anie znaku do pami�ci
	inc ebx ; inkrementacja indeksu

	; sterowanie p�tl�
	;loop ptl
	dec ecx;
	jnz ptl


	push 0 ; constant for MB_OK
	push offset tytul ;title
	push offset magazyn ;text
	push 0 ;Null
	call _MessageBoxA@16

	push 0
	call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END

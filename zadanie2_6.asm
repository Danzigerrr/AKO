;this is the solution for the fifth exercise
;conversion from Latin2 into Windows 1250
;first check big letter, then check small letter
;work only for: '¥','¹','Æ','æ','Ê','ê'

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
extern _MessageBoxA@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

	tytul db ' tytul ',0

.code

_main PROC
	; liczba znaków tekstu informacyjnego
	mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
	push ecx
	push OFFSET tekst_pocz ; adres tekstu
	push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
	call __write ; wyœwietlenie tekstu pocz¹tkowego
	add esp, 12 ; usuniecie parametrów ze stosu

	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znaków
	push OFFSET magazyn
	push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znaków z klawiatury
	add esp, 12 ; usuniecie parametrów ze stosu

	; kody ASCII napisanego tekstu zosta³y wprowadzone do obszaru 'magazyn'
	
	; funkcja read wpisuje do rejestru EAX liczbê wprowadzonych znaków
	mov liczba_znakow, eax


	; rejestr ECX pe³ni rolê licznika obiegów pêtli
	mov ecx, eax
	mov ebx, 0 ; indeks pocz¹tkowy


	ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	;change normal ascii letters
	cmp dl, 'a'
	jb dalej ; jump if below
	cmp dl, 'z'
	ja checkA1 ; jump if above to check special letters
	sub dl, 20H ; change to uppercase
	jmp dalej

	checkA1:;'¥' 
	cmp dl, 0a4h ;check if it is '¥' in latin 2
	jne checkA2
	mov dl, 165 ;convert into '¥' in Windows 1250
	jmp dalej

	checkA2:
	cmp dl, 0a5h ;'¹'
	jne checkC1
	mov dl, 185
	jmp dalej

	checkC1:
	cmp dl, 8fH ;'Æ'
	jne checkC2
	mov dl, 198
	jmp dalej

	checkC2:
	cmp dl, 86H ;'æ'
	jne checkE1
	mov dl, 230
	jmp dalej

	checkE1:
	cmp dl, 168 ;'Ê'
	jne checkE2
	mov dl, 202
	jmp dalej

	checkE2:
	cmp dl, 169 ;'ê'
	jne dalej
	mov dl, 234
	jmp dalej


	dalej:
	mov magazyn[ebx], dl ; odes³anie znaku do pamiêci
	inc ebx ; inkrementacja indeksu

	; sterowanie pêtl¹
	;loop ptl
	dec ecx;
	jnz ptl


	push 0 ; constant for MB_OK
	push offset tytul ;title
	push offset magazyn ;text
	push 0 ;Null
	call _MessageBoxA@16

	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END

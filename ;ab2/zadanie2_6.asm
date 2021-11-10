;this is the solution for the fifth exercise
;conversion from Latin2 into Windows 1250
;first check big letter, then check small letter
;work only for: 'Ą','ą','Ć','ć','Ę','ę'

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
extern _MessageBoxA@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Proszę napisać jakiś tekst '
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
	push 1 ; nr urządzenia (tu: ekran - nr 1)
	call __write ; wyświetlenie tekstu początkowego
	add esp, 12 ; usuniecie parametrów ze stosu

	; czytanie wiersza z klawiatury
	push 80 ; maksymalna liczba znaków
	push OFFSET magazyn
	push 0 ; nr urządzenia (tu: klawiatura - nr 0)
	call __read ; czytanie znaków z klawiatury
	add esp, 12 ; usuniecie parametrów ze stosu

	; kody ASCII napisanego tekstu zostały wprowadzone do obszaru 'magazyn'
	
	; funkcja read wpisuje do rejestru EAX liczbę wprowadzonych znaków
	mov liczba_znakow, eax


	; rejestr ECX pełni rolę licznika obiegów pętli
	mov ecx, eax
	mov ebx, 0 ; indeks początkowy


	ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	;change normal ascii letters
	cmp dl, 'a'
	jb dalej ; jump if below
	cmp dl, 'z'
	ja checkA1 ; jump if above to check special letters
	sub dl, 20H ; change to uppercase
	jmp dalej

	checkA1:;'Ą' 
	cmp dl, 0a4h ;check if it is 'Ą' in latin 2
	jne checkA2
	mov dl, 165 ;convert into 'Ą' in Windows 1250
	jmp dalej

	checkA2:
	cmp dl, 0a5h ;'ą'
	jne checkC1
	mov dl, 185
	jmp dalej

	checkC1:
	cmp dl, 8fH ;'Ć'
	jne checkC2
	mov dl, 198
	jmp dalej

	checkC2:
	cmp dl, 86H ;'ć'
	jne checkE1
	mov dl, 230
	jmp dalej

	checkE1:
	cmp dl, 168 ;'Ę'
	jne checkE2
	mov dl, 202
	jmp dalej

	checkE2:
	cmp dl, 169 ;'ę'
	jne dalej
	mov dl, 234
	jmp dalej


	dalej:
	mov magazyn[ebx], dl ; odesłanie znaku do pamięci
	inc ebx ; inkrementacja indeksu

	; sterowanie pętlą
	;loop ptl
	dec ecx;
	jnz ptl


	push 0 ; constant for MB_OK
	push offset tytul ;title
	push offset magazyn ;text
	push 0 ;Null
	call _MessageBoxA@16

	push 0
	call _ExitProcess@4 ; zakończenie programu
_main ENDP
END

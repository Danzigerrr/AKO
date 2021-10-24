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
extern _MessageBoxW@16 : PROC
public _main
.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 10 dup (?)
	magazynUni dw 10 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

	tytul db ' tytul ',0

	tytulUni  dw 'U','T','F','-','1','6',0
	tekstUni  dw 't','e','k','s','t',0
	
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
	mov esi,0
	ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

	checkA: ;'¹'
	cmp dl, 0a5h
	jne checkC
	mov dx, 0105h
	jmp dalej

	checkC: ; 'æ'
	cmp dl, 86h
	jne dalej
	mov dx, 0107h
	jmp dalej



	dalej:
	mov magazynUni[esi], dx ; odes³anie znaku do pamiêci
	mov dx,0 ; zero the dx register to avoid mistakes (1 left on the second bit after previous number)
	add ebx, 1 ; inkrementacja indeksu
	add esi, 2

	; sterowanie pêtl¹
	;loop ptl
	dec ecx;
	jnz ptl

	comment	|
	;utf 8 
	push 0 ; constant for MB_OK
	push offset tytul ;title
	push offset magazyn ;text
	push 0 ;Null
	call _MessageBoxA@16
	|

	;utf 16 unicode
	push 0 ; constant for MB_OK
	push offset tytulUni  ;title
	push offset magazynUni  ;text
	push 0 ;Null
	call _MessageBoxW@16


	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END

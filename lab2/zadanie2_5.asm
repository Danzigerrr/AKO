; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
public _main
.data
	tekst_pocz db 10, 'Proszę napisać jakiś tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?


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
	ja checkA ; jump if above to check special letters
	sub dl, 20H ; change to uppercase
	jmp dalej

	checkA:
	cmp dl, 0a5h ;'ą'
	jne checkC
	mov dl, 164
	jmp dalej

	checkC:
	cmp dl, 86H ;'ć'
	jne checkE
	mov dl, 143
	jmp dalej

	checkE:
	cmp dl, 0a9H ;'ę'
	jne checkL
	mov dl, 168
	jmp dalej

	checkL:
	cmp dl, 88H ;'ł'
	jne checkN
	mov dl, 157
	jmp dalej

	checkN:
	cmp dl, 0e4H ;'ń'
	jne checkO
	mov dl, 227
	jmp dalej

	checkO:
	cmp dl, 0a2H ;'ó'
	jne checkS
	mov dl, 224
	jmp dalej

	checkS:
	cmp dl, 98H ;'ś'
	jne checkZ1
	mov dl, 151
	jmp dalej
	
	checkZ1:
	cmp dl, 0abH ;'ź'
	jne checkZ2
	mov dl, 141
	jmp dalej

	checkZ2:
	cmp dl, 0beH ;'ż'
	jne dalej
	mov dl, 189
	jmp dalej


	dalej:
	mov magazyn[ebx], dl ; odesłanie znaku do pamięci
	inc ebx ; inkrementacja indeksu

	; sterowanie pętlą
	;loop ptl
	dec ecx;
	jnz ptl



	; wyświetlenie przekształconego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wyświetlenie przekształconego tekstu
	add esp, 12 ; usuniecie parametrów ze stosu
	push 0
	call _ExitProcess@4 ; zakończenie programu
_main ENDP
END

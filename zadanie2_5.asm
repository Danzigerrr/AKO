; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main
.data
	tekst_pocz db 10, 'Proszê napisaæ jakiœ tekst '
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
	ja checkA ; jump if above to check special letters
	sub dl, 20H ; change to uppercase
	jmp dalej

	checkA:
	cmp dl, 0a5h ;'¹'
	jne checkC
	mov dl, 164
	jmp dalej

	checkC:
	cmp dl, 86H ;'æ'
	jne checkE
	mov dl, 143
	jmp dalej

	checkE:
	cmp dl, 0a9H ;'ê'
	jne checkL
	mov dl, 168
	jmp dalej

	checkL:
	cmp dl, 88H ;'³'
	jne checkN
	mov dl, 157
	jmp dalej

	checkN:
	cmp dl, 0e4H ;'ñ'
	jne checkO
	mov dl, 227
	jmp dalej

	checkO:
	cmp dl, 0a2H ;'ó'
	jne checkS
	mov dl, 224
	jmp dalej

	checkS:
	cmp dl, 98H ;'œ'
	jne checkZ1
	mov dl, 151
	jmp dalej
	
	checkZ1:
	cmp dl, 0abH ;'Ÿ'
	jne checkZ2
	mov dl, 141
	jmp dalej

	checkZ2:
	cmp dl, 0beH ;'¿'
	jne dalej
	mov dl, 189
	jmp dalej


	dalej:
	mov magazyn[ebx], dl ; odes³anie znaku do pamiêci
	inc ebx ; inkrementacja indeksu

	; sterowanie pêtl¹
	;loop ptl
	dec ecx;
	jnz ptl



	; wyœwietlenie przekszta³conego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wyœwietlenie przekszta³conego tekstu
	add esp, 12 ; usuniecie parametrów ze stosu
	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END

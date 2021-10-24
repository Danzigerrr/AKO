; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
public _main
.data
	tekst_pocz db 10, 'Prosz� napisa� jaki� tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?


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
	ja checkA ; jump if above to check special letters
	sub dl, 20H ; change to uppercase
	jmp dalej

	checkA:
	cmp dl, 0a5h ;'�'
	jne checkC
	mov dl, 164
	jmp dalej

	checkC:
	cmp dl, 86H ;'�'
	jne checkE
	mov dl, 143
	jmp dalej

	checkE:
	cmp dl, 0a9H ;'�'
	jne checkL
	mov dl, 168
	jmp dalej

	checkL:
	cmp dl, 88H ;'�'
	jne checkN
	mov dl, 157
	jmp dalej

	checkN:
	cmp dl, 0e4H ;'�'
	jne checkO
	mov dl, 227
	jmp dalej

	checkO:
	cmp dl, 0a2H ;'�'
	jne checkS
	mov dl, 224
	jmp dalej

	checkS:
	cmp dl, 98H ;'�'
	jne checkZ1
	mov dl, 151
	jmp dalej
	
	checkZ1:
	cmp dl, 0abH ;'�'
	jne checkZ2
	mov dl, 141
	jmp dalej

	checkZ2:
	cmp dl, 0beH ;'�'
	jne dalej
	mov dl, 189
	jmp dalej


	dalej:
	mov magazyn[ebx], dl ; odes�anie znaku do pami�ci
	inc ebx ; inkrementacja indeksu

	; sterowanie p�tl�
	;loop ptl
	dec ecx;
	jnz ptl



	; wy�wietlenie przekszta�conego tekstu
	push liczba_znakow
	push OFFSET magazyn
	push 1
	call __write ; wy�wietlenie przekszta�conego tekstu
	add esp, 12 ; usuniecie parametr�w ze stosu
	push 0
	call _ExitProcess@4 ; zako�czenie programu
_main ENDP
END

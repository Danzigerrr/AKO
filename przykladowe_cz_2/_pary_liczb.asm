.686
.model flat
public  _pary_liczb
extern _malloc : proc

.data

tablica db 180 dup(?)
wynik_64 dq 0
wynik_8 db 0
.code
_pary_liczb proc
push edx
	mov ecx, 180
	mov eax, 0
	lea edx, tablica
	wypelnij:
		mov [edx], al
		inc al
		inc edx
	loop wypelnij
pop edx

mov ecx, 4 ;czwarta para nas intersuje

;poczatek rozwiazania:

	push edx
	lea edx, tablica

	;indeks pray elementow zapisany w cl
	przewin:
		add edx, 9 ;8 bajtów + 1 bajt = 9 bajtów (9 bajtow to jedna para liczb)
	dec cl
	jnz przewin

	;pierwsza czesc liczby 64 bit
	mov ebx, [edx]
	mov dword ptr [wynik_64], ebx

	;druga czesc liczby 64 bit
	mov ebx, [edx+4]
	mov dword ptr [wynik_64+4], ebx

	;liczba 8 bit
	mov bl, [edx+8]
	mov byte ptr [wynik_8], bl

	pop edx


	ret

_pary_liczb endp
END

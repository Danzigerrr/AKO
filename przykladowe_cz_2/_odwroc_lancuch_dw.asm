.686
.model flat
public  _odwroc_lancuch_dw
extern _malloc : proc

.data
lancuch_znakow dw 'A', 'B', 'C', 0
.code
_odwroc_lancuch_dw proc

	lea esi, lancuch_znakow
;poczatek rozwiazania:

	push edx

	mov eax, esi ;kopia
	mov edx, 0
	mov ecx, 0

	;przenies na stos caly lancuch
	;ecx liczy dlugosc lancucha
	;esi wskazuje na przepisywany znak
	ptl:
		mov dx, [esi]
		cmp dx, 0
		je dalej
			push dx
		add esi, 2
		inc ecx
	jmp ptl

	dalej:
	mov esi, eax ;przywrocenie początkowej wartosci

	;przepisz ze stosu lancuch znakow
	;licznik petli to ecx
	ptl2:
		pop dx
		cmp dx, 0
		je dalej2
			mov [esi], dx
		add esi, 2
	loop ptl2

	dalej2:

	pop edx



	ret

_odwroc_lancuch_dw endp
END

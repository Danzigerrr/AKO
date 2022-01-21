.686
.model flat
public  _avg_wd
extern _malloc : proc

.data
n dd ?
srednia dd ?
.code
_avg_wd proc
	push ebp
	mov ebp ,esp

	mov ecx, [ebp+8] ;n
	mov n, ecx

	mov esi, [ebp+12] ;tablica
	mov edi, [ebp+16] ;wagi

	finit
	fldz
	licz_srednia:
		fld dword ptr [esi]
		fld dword ptr [edi]
		fmulp
		faddp

		add esi, 4
		add edi, 4
	loop licz_srednia

	;podziel przez n
	fidiv n

	fst srednia

	;wynik zwracany przez st0
	
	pop ebp
	ret

_avg_wd endp
END

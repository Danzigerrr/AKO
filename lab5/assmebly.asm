.686
.model flat

public _srednia_harm
.data
arrsize dd ?

.code

_srednia_harm PROC
;prolog
	push ebp
	mov ebp,esp

;stos: (standard C -> od prawej do lewej argumenty na stos)
;ebp+12 = n
;ebp+8  = adres tablicy
;ebp+4  = slad
;ebp

	push ecx
	push ebx

	mov ecx, [ebp + 12] ;n
	mov arrsize, ecx ;kopia n
	mov ebx, [ebp + 8];adres tablicy

	finit	
	fldz

	et:
		fld1
		fdiv dword ptr [ebx]
		faddp ST(1),ST(0)
		add ebx,4 ;next index
	loop et

	fild arrsize
	fdiv ST(0),ST(1)

	pop ebx
	pop ecx

	pop ebp
	ret

_srednia_harm ENDP

END


;maskowanie flagi ZM (dzielenie przez 0 nie powoduje wyjatku)
;fstcw   ctrlWord                ; get the control word
;and ctrlWord,1111111111111011b  ; unmask Divide by 0
;fldcw   ctrlWord                ; load it back into FPU

.686 
.XMM 
.model flat 
public _dylatacja_czasu 
public _szybki_max
.data 
pred_sw dq 300000000
.code 

_szybki_max PROC 
	;prolog
	push ebp
	mov ebp, esp

	push esi
	push edi
	

	add ebp, 8 ;przesuniecie ebp
	mov esi, [ebp] ; tab1
	mov edi, [ebp+4] ; tab2
	mov ebx, [ebp+8] ; wynik
	mov ecx, [ebp+12] ; n

	laduj_liczbe:
		movups xmm5, [esi] ;przepisz
		movups xmm6, [edi] ;przepisz
		PMAXSD xmm5, xmm6  ;porownaj  max signed dword
		movups [ebx], xmm5 ;zapisz wynik

		add esi, 16
		add edi, 16
		add ebx, 16
		sub ecx,4
		cmp ecx,0
	ja laduj_liczbe

	koniec: 

	pop edi
	pop esi
	pop ebp
	ret
_szybki_max ENDP 




_dylatacja_czasu PROC 
	push ebp 
	mov ebp, esp 

	push eax
	push esi
	push edi
	push ecx

	finit
	

	fld dword ptr [ebp+12] ;v
	fmul st(0), st(0) ;v^2

	fild pred_sw
	fmul st(0), st(0) ;c^2

	fdiv

	fld1 ;do odejmowania

	fxch st(1)
	fsub ;1 - v^2/c^2

	fsqrt ;pierwiastek

	fild dword ptr [ebp+8] ;delta_t

	fdiv st(0), st(1)



	pop ecx
	pop edi
	pop esi
	pop eax

	pop ebp 
	ret 



_dylatacja_czasu ENDP 
END

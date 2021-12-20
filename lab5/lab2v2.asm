.686
.model flat

public _nowy_exp
.data
roz dd ?
temp dd ?
res dd ?

.code

_nowy_exp PROC
;prolog
	push ebp
	mov ebp,esp

;stos: (standard C -> od prawej do lewej argumenty na stos)
;ebp+8  = n
;ebp+4  = slad
;ebp

	push ecx
	push ebx

	;mov roz, dword ptr [ebp + 8];n
	
	finit	
	fld1

	mov ecx, 18	;ilosc wyrazow z szeregu, gdzie x jest pondoszone do potegi >=2
				;(czyli dla ecx = 4 policzy 6 pierwszych wyrazow)
	mov eax, 2 ;silnia
	mov ebx, 2 ;potega
	mov edx, 1 ;przy dodawaniu na koproc
	kolejny:
	
		;silnia
		mov dword ptr roz, eax
		silnia:
			fild roz
			fmulp ST(1),ST(0)
			dec roz
		cmp roz, dword ptr 0
		jne silnia

		fld1 
		push ebx
		potega:
			fld dword ptr [ebp +8]
			fmulp 
		dec ebx
		jnz potega
		pop ebx

		;dzielenie
		fxch
		fdivp

	cmp edx, 1
	
	jne dodawaj
		inc edx
		fld1
		jmp przejscie
	dodawaj:
		faddp
		fld1
	;przejscie do kolejnego wyrazu
	przejscie:
	inc eax
	inc ebx
	loop kolejny


	;dodaj jeden do ST(0) (pierwszy wyraz)
	;jednyka juz jest na stosie
	faddp
	;dodaj drugi wyraz
	fld dword ptr [ebp + 8]
	faddp

	;popuj rejestry
	pop ebx
	pop ecx

	pop ebp
	ret

_nowy_exp ENDP

END


;maskowanie flagi ZM (dzielenie przez 0 nie powoduje wyjatku)
;fstcw   ctrlWord                ; get the control word
;and ctrlWord,1111111111111011b  ; unmask Divide by 0
;fldcw   ctrlWord                ; load it back into FPU
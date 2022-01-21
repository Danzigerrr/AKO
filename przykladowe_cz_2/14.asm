.686
.model flat
public  _pole_kola
extern _malloc : proc

.data
pr dd ?
pole dd ?

.code
_pole_kola proc
;prolog
	push ebp
	mov ebp, esp

;pobierz adres orginalnego argumentu
	mov ebx, [ebp+8] ;*a
	mov eax, [ebx] ;a

	mov pr, eax

	;oblicz pole kola
	finit
	fld pr
	fld pr
	fmulp 
	fldpi
	fmulp 

	;zapisz pole w pamieci
	fstp pole
	mov eax, pole
	;zapisz wynik pod adresem orginalnej zmiennej
	mov [ebx], eax
koniec:
	pop ebp
	ret
_pole_kola endp
END

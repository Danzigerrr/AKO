.686
.model flat

public _szukaj_max

.code

_szukaj_max PROC
;prolog
	push ebp
	mov ebp, esp

	mov eax, [ebp+8] ;x
	cmp eax, [ebp+12] ;y
	jge x_wieksza ;skok gdy x >= y

; x < y
	mov eax, [ebp + 12] ;y
	cmp eax, [ebp+16] ; z
	jge y_wieksza ;skok gdy  y >= z

; y < z
;wiêc max = z
wpisz_z:
	mov eax, [ebp+16] ; zapisz z

zakoncz:
	jmp porownaj_z_v
	koniec_v:
	pop ebp
	ret

x_wieksza:
	cmp eax, [ebp+16] ; x vs z
	jge zakoncz ;skok gdy  x >= z
	jmp wpisz_z

y_wieksza:
	mov eax, [ebp+12] ; y
	jmp zakoncz ;skok 


porownaj_z_v:
	cmp eax, [ebp+20] 
	jge koniec_v 
	mov eax, [ebp+20] ; zapisz v
	jmp koniec_v
_szukaj_max ENDP

END
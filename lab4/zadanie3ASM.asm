.686
.model flat

public _odejmij_jeden

.code

_odejmij_jeden PROC
;prolog
	push ebp
	mov ebp, esp

;zachowaj ebx
	push ebx 
	push ecx


;ebx ->adres adresu zmiennej
	mov ecx, [ebp +8]

;ebx ->adres zmiennej
	mov ebx, [ecx]

;inkrementacja
	mov eax, [ebx]	;wartosc zmiennej
	sub eax, 1		; inkrementacja o 1
	mov [ebx], eax	;zapisanie nowej wartosci zmiennej

;powy¿sze rozkazy mo¿na zast¹piæ rozkazem:
; inc dword PTR [ebx]

;powrot do progamu glownego
	pop ecx
	pop ebx
	pop ebp
	ret

_odejmij_jeden ENDP

END
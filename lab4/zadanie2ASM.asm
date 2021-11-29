.686
.model flat

public _liczba_przeciwna

.code

_liczba_przeciwna PROC
;prolog
	push ebp
	mov ebp, esp

;zachowaj ebx
	push ebx 

;ebx ->adres zmiennej
	mov ebx, [ebp +8]

;inkrementacja
	mov eax, [ebx]	;wartosc zmiennej
	not eax			; negacja wszystkich bitów
	add eax, 1		; inkrementacja o 1
	mov [ebx], eax	;zapisanie nowej wartosci zmiennej

;powy¿sze rozkazy mo¿na zast¹piæ rozkazem:
; inc dword PTR [ebx]

;powrot do progamu glownego
	pop ebx
	pop ebp
	ret

_liczba_przeciwna ENDP

END
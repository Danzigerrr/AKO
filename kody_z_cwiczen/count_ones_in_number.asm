; count number of bits "1" in a number
; the number is stored in eax


.686
.model flat
public _count_ones_in_number

.data

.code
;_count_ones_in_number
_count_ones_in_number	PROC

mov eax, 50FF0000h ;analzed number

push edx

mov ecx, 32
mov edx,0
kolejny_bit:

	rol eax, 1
	jnc dalej
	inc dl
	dalej:

loop kolejny_bit

mov cl,dl

pop edx

ret
_count_ones_in_number	ENDP

END

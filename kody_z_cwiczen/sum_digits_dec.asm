.686
.model flat
public _sum_digits_dec

.data

.code

_sum_digits_dec	PROC
mov eax, 128 ;analyzed number
mov esi, 10 ;dividng by
mov cl, 0 ;counter (sum of digits)
mov edx,0 ;prepare for diving

dziel:
	div esi ;divide EDX:EAX by ESI
	add cl,dl ;update counter
	mov edx,0 ;prepare edx for next loop
cmp eax,0
jne dziel

ret
_sum_digits_dec	ENDP

END

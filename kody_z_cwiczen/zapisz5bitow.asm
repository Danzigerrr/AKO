.686
.model flat
public  _zapisz5bitow
extern _malloc : proc

.data
number db 00000011b, 11000000b
start_bit dw ?
.code
_zapisz5bitow proc

	push ebp
	mov ebp, esp
	push ecx
	push edi

	mov edi, offset number ;address of starting bait
	mov cl, 5 ;number of starting bit
	mov al, 11111111b ;get 5 youngets bits from this number

	;begin
	mov dx, [edi]
	mov esi, 5 ;loop counter

	and cx, 000Fh
	next:
		rol al, 1
		jnc zero

			bts dx,cx
		jmp prepare_next
	zero:
			btr dx, cx

	prepare_next:
		inc cx
	dec esi
	jnz next


	rol al, 5 ;original
	mov [edi], DX

koniec:
	pop edi
	pop ecx
	pop ebp
	ret

_zapisz5bitow endp
END

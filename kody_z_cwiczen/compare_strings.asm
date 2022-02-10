;compare two strings
;result stored in AL
;AL=0 --> not equal
;AL=1 --> equal

.686
.model flat
public  _compare_strings

.data
string1 db 'hello'
len1 equ $-string1
string2 db 'world'
len2 equ $-string2
.code
_compare_strings proc
	push esp
	mov ebp,esp
	
	mov esi, offset string1
	mov edi, offset string2

	;select shorter
	cmp len1,len2
	jne not_equal ;if len1 != len2, then not equal for sure

	mov ecx, len1
	cld
	repe cmpsb
	jecxz equal ;jump when ecx is zero
	not_equal:	
		mov al,0
		jmp final
	equal:
		mov al,1

final:
	pop ebp
	ret

_compare_strings endp
END

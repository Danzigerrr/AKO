; EBX stores addres of number in BE format
; number is saved to EAX in LE format



.686
.model flat
public _BE_to_LE

.data

liczbaBE dd 12345678h
.code

_BE_to_LE	PROC
lea ebx, liczbaBE
push ecx
mov ecx, [ebx]

mov ax,cx
xchg al,ah
rol ecx,16
rol eax,16
mov ax,cx
xchg	al,ah

pop ecx



ret
_BE_to_LE	ENDP

END

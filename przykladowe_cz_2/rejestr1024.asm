.686
.model flat
public  _rejestr1024
extern _malloc : proc

.data
rejestr db 1, 126 dup(0),10100000b

.code
_rejestr1024 proc

	push ebp
	mov ebp, esp

	push edi

	mov edi, offset rejestr ;adres tablicy

	;sprwadz najstarszy bit
	;zapisz go do cf

	mov al, [edi+127]
	bt ax, 7

	;petla
	mov ecx, 128 ;licznik petli
	 ;w cf znajduje sie przeniesienie

	petla:
		rcl byte ptr [edi], 1
		inc edi
	loop petla



koniec:
	pop edi

	pop ebp
	ret

_rejestr1024 endp
END

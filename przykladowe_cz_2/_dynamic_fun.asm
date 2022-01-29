.686
.model flat
public  _wywolujaca_przykladowa
extern _malloc : proc

.data


.code

_dynamic_fun PROC
	mov esi, [esp]
	xor ebx, ebx
	mov bl, [esi]
	mov ebx, [esi + 4*ebx]
   ;call ebx		;wywolanie funkcji znajdujacej sie pod adresem okreslonym przez EBX

	;trzeba pomiąć 4 liczby zdefiniowane pod rozkazie call w funkcji wywołującej
	add esi, 13
	mov [esp], esi

	ret
_dynamic_fun ENDP


_wywolujaca_przykladowa proc

	call _dynamic_fun
	db 2
	dd 500
	dd 710
	dd 320

	ret

_wywolujaca_przykladowa endp
END

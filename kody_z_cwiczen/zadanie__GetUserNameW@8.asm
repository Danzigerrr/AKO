.686
.model flat
public _analiza_kodu1

extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameExW@12 : PROC
extern _GetUserNameW@8 : PROC
.data

.code

_analiza_kodu1 PROC
	sub esp, 128
	mov edi, esp
	sub esp, 4
	mov eax, 32 ;maksymalna liczba znaków
	mov [esp], eax

	push esp
	push edi
	call _GetUserNameW@8

	add esp, 132

ret
_analiza_kodu1 ENDP 


END

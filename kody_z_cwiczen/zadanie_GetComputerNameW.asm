.686
.model flat
public _zadanie_GetComputerNameW
extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameW@8 : PROC

.data

.code

_zadanie_GetComputerNameW PROC
	
	sub esp, 120
	mov esi, esp
	sub esp,4
	mov eax, 60 ;maksymalna liczba znaków
	mov [esi],eax

	push esp
	push esi
	call _GetComputerNameW@8

	add esp, 124

ret
_zadanie_GetComputerNameW ENDP 

END

.686
.model flat
public _GetComputerName2
extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameExW@12 : PROC

.data
obszar_A dd 256 dup(99)
obszar_B dd 256 dup(?)
.code

_GetComputerName2 PROC

	mov ebp, esp
	sub esp, 100
	mov esi, esp
	sub esp, 4
	mov eax, 50 ;zaladowanie maksymalnej liczby znakow
	mov [esi], eax

	push esp
	push esi
	push dword ptr 4
	call _GetComputerNameExW@12

	mov esp, ebp

ret
_GetComputerName2 ENDP 

END

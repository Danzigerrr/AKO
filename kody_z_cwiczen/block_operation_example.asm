.686
.model flat
public _block_operation_example
extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameW@8 : PROC

.data
prime_numbers db 2,3,5,7,11,13,17,19,23,29,31,37
array db 12 dup(?)
.code

_block_operation_example PROC
	mov ecx, 12 ;number of repetition
	cld ;set DF=0 (increasing)
	mov esi, offset prime_numbers
	mov edi, offset array
	rep movsb	


ret
_block_operation_example ENDP 

END

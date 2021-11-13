.686
.model flat
extern _ExitProcess@4 : PROC 
public _main

.data


array dw 1, 2,3,4,5

.code

_main PROC
	mov ebx, offset array ;save effective adress of array
	mov eax, 0 ;sum of elements will be stored here
	mov esi, 0 ;beggining index
	mov ecx, 5 ;number of loop repetition
sum:
	add ax, [ebx + 2*esi]
	add esi, 1
loop sum

COMMENT	|
loop sum = sub ecx,1	jnz sum
|



	push 0 ;exit code
	call _ExitProcess@4 

_main ENDP

END

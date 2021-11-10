;

;this is the solution for the fifth exercise
;conversion from Latin2 into Windows 1250
;first check big letter, then check small letter

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)

public _main
.data


	array dw 4,3,2,0

.code

summing:
	; prolog
	push ebp
	mov ebp,esp 
	
	sub esp,4 ;place reserved for dynammicaly stored varaible --> result

	mov eax,0 ; eax is the result
	add eax, [ebp + 8] ;first param
	add eax, [ebp + 12] ;secnod param
	add eax, [ebp + 16] ; third param

	mov [ebp - 4], eax ; store temp result as dynamic variable

	add esp,4 ; removing place for dynamic variable

	pop ebp
ret




_main PROC
	
	;push numbers to be summed
	push 2
	push 1
	push 3

	call summing

	add esp,12 ; beace 3 arguments, each has 4 bytes

	


	push 0
	call _ExitProcess@4 ; zakoñczenie programu
_main ENDP
END

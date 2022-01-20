.686
.model flat
public  _iteracja
extern _malloc : proc
.code
_iteracja proc

;prolog
	Push ebp
	Mov ebp, esp
	
	mov al, [ebp+8]
	sal al, 1

	jc zakoncz

	inc al
	push eax
	call _iteracja
	add esp, 4

	pop ebp
	ret
	

	zakoncz:
	rcr al, 1

	
	Pop ebp
	ret
_iteracja endp
END

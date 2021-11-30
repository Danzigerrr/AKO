.686
.model flat

public _przestaw

.code

_przestaw PROC
;prolog
	push ebp
	mov ebp, esp

;zachowaj ebx
	push ebx 
	push ecx
	push esi

;ebx ->adres tablicy
	mov ebx, [ebp+8]
;ecx ->ilosc elementow
	mov ecx, [ebp+12]
	dec ecx
	mov esi,ecx

	ptl1:
		ptl2:
			mov eax, [ebx] ;kolejny element
			cmp eax, [ebx+4]
			jle gotowe ;skok gdy nie ma przestawienia

			;swap
				mov edx, [ebx+4]
				mov [ebx], edx
				mov [ebx+4], eax

			gotowe:
				add ebx, 4 ;adres kolejnego elementu
		loop ptl2
		mov ebx,[ebp+8]
		mov ecx, [ebp+12]
		dec ecx
	dec esi
	jnz ptl1
	
;powrot do progamu glownego
	pop esi
	pop ecx
	pop ebx
	pop ebp
	ret

_przestaw ENDP

END
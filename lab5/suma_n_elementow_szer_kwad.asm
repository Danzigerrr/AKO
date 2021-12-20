.686 
.XMM 
.model flat 
public _suma_n_elementow_szer_kwad 
.data 
v dd ?
.code 
_suma_n_elementow_szer_kwad PROC 
	push ebp 
	mov ebp, esp 

	push eax
	push esi
	push edi
	push ecx

	mov esi, [ebp+8] ;n
	add esi,1

	mov eax, 1

	finit
	
	kolejna_liczba:
		;potegowanie do drugiej
		mov dword ptr v, eax
		fild v
		fild v
		fmul


		;dodawanie do wyniku
		cmp eax, dword ptr 1
		jne dalej
		fldz
		dalej:
		fadd

	inc eax
	cmp eax, esi
	jnz kolejna_liczba


	pop ecx
	pop edi
	pop esi
	pop eax

	pop ebp 
	ret 
_suma_n_elementow_szer_kwad ENDP 
END

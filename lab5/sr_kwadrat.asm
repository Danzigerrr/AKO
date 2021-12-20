.686 
.XMM 
.model flat 
public _sr_kwadrat 
.data 
n dd ?
.code 
_sr_kwadrat PROC 
	push ebp 
	mov ebp, esp 

	push eax
	push esi
	push edi
	push ecx

	mov eax, [ebp+8] ;tab
	mov ecx, [ebp+12] ;n
	mov n, ecx
	finit
	
	kolejna_liczba:
		;potegowanie do drugiej
		fld dword ptr [eax]
		fld dword ptr [eax]
		fmul


		;dodawanie do wyniku
		cmp ecx, dword ptr n
		jne dalej
		fldz
		dalej:
		fadd

		add eax, dword ptr 4
	loop kolejna_liczba

	fild n
;	fxch
	fdiv ;st1 = st1/st0, usuwa st0

	;pierwiastek
	fsqrt

	pop ecx
	pop edi
	pop esi
	pop eax

	pop ebp 
	ret 
_sr_kwadrat ENDP 
END

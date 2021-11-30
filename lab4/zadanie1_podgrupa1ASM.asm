.686
.model flat
public _suma 
.code 
_suma PROC 
	;prolog
	push ebp
	mov ebp, esp
	push ecx
	push esi
	push edi

	mov ecx, [ebp + 8] ;n
	mov esi, 12 ;pole adresowe w petli rozkazowej
	mov edi, 4 ;inkrementowanie

	xor eax,eax ;wynik

	dodawaj:
		add eax, [ebp+esi] ;x
		add esi, edi
	loop dodawaj

	koniec:
	pop edi
	pop esi
	pop ecx
	pop ebp
	ret
_suma ENDP
END

.686
.model flat
public  _liczba_nowy_format
extern _malloc : proc
.code
_liczba_nowy_format proc
;liczba w nowym formacie w rejestrze ebx

	push ecx

mov esi, 00000000h ; jedna analizowana liczba 
mov edi, 00000001h ; druga analizowana liczba 

	
	bt edi, 31
	jnc porownuj_dokladnie
	;edi > esi --> CF = 0
		CLC
		jmp koniec

	porownuj_dokladnie:

	shl edi, 1

	cmp edi, esi
	jg edi_wieksze

	esi_wieksze:
	STC
	jmp koniec

	edi_wieksze:
	CLC

koniec:
pop ecx
	ret
_liczba_nowy_format endp
END

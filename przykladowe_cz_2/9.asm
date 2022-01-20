.686
.model flat
public  _liczba_nowy_format
extern _malloc : proc
.code
_liczba_nowy_format proc
;liczba w nowym formacie w rejestrze ebx

mov edx, 000F000Fh ; analizowana liczba 

	bt edx, 7
	jc w_gore
	; zaokraglanie w dol:
		shr edx,7
		shl edx,7
	jmp koniec

	w_gore:
		mov eax, edx
		shl eax, 1 ;usun bit znaku
		shr eax, 8 ;usun czesc niecalkowtią
		add eax, 1 ;zaokraglanie w gore
		shl eax, 7 ;dodaj wyzerowaną część niecalkowitą

		;przepisywanie znaku na podstawie 31-ego bitu w edx
		btr eax, 31
		bt edx, 31
		jnc zostaje_dodatnia
		bts eax, 1
		zostaje_dodatnia:

		mov edx, eax ;przepisz gotową liczbę do edx

koniec:

	ret
_liczba_nowy_format endp
END

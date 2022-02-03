.686
.model flat
public _analiza_kodu1

extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameExW@12 : PROC

.data

.code

_analiza_kodu1 PROC
	Mov ecx, -1 ; ECX = FFFFFFFFh
	Mov cx, 22 ;ECX = FFFF0016h

	;skok wykona sie 2 razy
	skok:
		Sub cx, 11
		Je et2 ;skok gdy ECX = FFFF0000h
		Call skok	;umieszcza na stosie adres
					;pod ktorym zapisany jest
					;rozkaz "Mov ecx, [esp]"
					;ponieważ jest on kolejnym rozkazem
					;po rozkazie "call"

	et2: ;ECX = FFFF0000h
		Mov ecx, [esp] ;instrukcja pobiera własny adres ze stosu
		Neg ecx ; negacja artemtayczna -> wartość przeciwna
		Lea ecx, [ecx+et2+1] ;ECX = (-ECX) + ECX + 1 = 1

		;ECX = 1 (dec)

ret
_analiza_kodu1 ENDP 


END

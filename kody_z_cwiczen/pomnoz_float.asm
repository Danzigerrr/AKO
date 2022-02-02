.686
.model flat
public _pomnoz_float
extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameW@8 : PROC

.data

.code

_pomnoz_float PROC
	mov eax, 01000000101000000000000000000000b ;liczba 5 zapisana binranie w formacie float (32 bity)
	ror eax, 23 
	add eax, 5
	rol eax, 23

	;wynik--> eax = 5*32 = 160

ret
_pomnoz_float ENDP 

END


;konwenter liczb dec na float lub double:
;https://www.exploringbinary.com/floating-point-converter/

.686
.model flat
public _pomnoz_float
extern  _MessageBoxA@16 : PROC
extern  _GetComputerNameW@8 : PROC

.data

.code

_pomnoz_float PROC
	mov eax, 01000000101000000000000000000000b ;liczba 5 zapisana binranie w formacie float (32 bity)
	Mov ebx, eax
	Shl ebx, 1 ;usun bit znaku
	Shr ebx, 24 ;usun mantyse (23+1 = 24 bity)
	Add ebx, 5 ;dodaj 5, czyli zwiększ wykładnik o 5, czyli pomnóż całą liczbę o 32
	Shl ebx, 23 ;przywróć wykladnik na oryginalne miejsce
	And eax, 807FFFFFh ;usun aktualny wykladnik (maska zer na 8 bitów odpowiadajacych za wykaldnik)
	Or eax, ebx ;wstaw nowy wykladnik

	;wynik--> eax = 5*32 = 160

ret
_pomnoz_float ENDP 

END

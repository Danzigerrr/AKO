.686
.model flat
public  _liczba_nowy_format
extern _malloc : proc
.code
_liczba_nowy_format proc
;liczba w nowym formacie w rejestrze ebx

mov ebx, 000F000Fh ; 

	Mov ecx, 7
Usun_nie_calkowita_czesc:

	Shr ebx, 1	
Loop Usun_nie_calkowita_czesc
	
Porownaj_z_zerem:

	Mov eax,0
	Add eax, 0 ;ustaw CF na 0

	Cmp ebx, 0
	Je Koniec
	Bts eax, 31
	Rol eax, 1
	

	
Koniec:



	ret
_liczba_nowy_format endp
END

; Przykład wywoływania funkcji MessageBoxA i MessageBoxW 
.686 
.model flat 
extern _ExitProcess@4 : PROC 
extern _MessageBoxA@16 : PROC 
extern _MessageBoxW@16 : PROC 
public _main 
.data 
tytul_Unicode	dw 'T','e','k','s','t',' ','w',' ' 
				dw 'f','o','r','m','a','c','i','e',' ' 
				dw 'U','T','F','-','1','6', 0 

tekst_Unicode	dw 'K','a', 017CH ,'d','y',' ','z','n','a','k',' ' 
				dw 'z','a','j','m','u','j','e',' ' 
				dw '1','6',' ','b','i','t', 00F3H ,'w', 0 
tytul_Win1250	db 'Tekst w standardzie Windows 1250', 0 
tekst_Win1250	db 'Ka', 191
				db 'dy znak zajmuje 8 bit', 243
				db 'w', 0 

.code 
_main PROC 
push 0 ; stała MB_OK 
; adres obszaru zawierajšcego tytuł 
push OFFSET tytul_Win1250 
; adres obszaru zawierajšcego tekst 
push OFFSET tekst_Win1250 
push 0 ; NULL 
call _MessageBoxA@16 
push 0 ; stala MB_OK 
; adres obszaru zawierajšcego tytuł 
push OFFSET tytul_Unicode 
; adres obszaru zawierajšcego tekst 
push OFFSET tekst_Unicode 
push 0 ; NULL 
call _MessageBoxW@16 
push 0 ; kod powrotu programu 
call _ExitProcess@4 
_main ENDP 
END

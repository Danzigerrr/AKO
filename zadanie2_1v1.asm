; program przyk�adowy (wersja 32-bitowa)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
public _main
.data
tekst	db 10, 'Nazywam si', 168
		db '...' , 10
		db 'M' , 162
		db 'j pierwszy 32-bitowy program '
		db 'asemblerowy dzia', 136
		db 'a ju', 190
		db ' poprawnie!', 10

	

.code
_main PROC
mov ecx, 85 ; liczba znak�w wy�wietlanego tekstu
; wywo�anie funkcji �write� z biblioteki j�zyka C
push ecx ; liczba znak�w wy�wietlanego tekstu
push dword PTR OFFSET tekst ; po�o�enie obszaru
; ze znakami
push dword PTR 1 ; uchwyt urz�dzenia wyj�ciowego
call __write ; wy�wietlenie znak�w
; (dwa znaki podkre�lenia _ )
add esp, 12 ; usuni�cie parametr�w ze stosu
; zako�czenie wykonywania programu
push dword PTR 0 ; kod powrotu programu
call _ExitProcess@4
_main ENDP

END
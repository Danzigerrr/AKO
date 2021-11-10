; Przykład wywoływania funkcji MessageBoxA i MessageBoxW
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data

tytul dw 'Z','n','a','k','i', 0

tekst dw 'T','o',' '
			dw 'j','e','s','t',' '
			dw 'p','o','e','s',' '
			dw 0d83dh, 0dc15h
			dw ' ','i',' '
			dw 'k' , 'o' , 't' 
			dw 0d83dh, 0dc08h
			dw 0

.code
_main:
 push 0 ;MB_OK
 push OFFSET tytul
 push OFFSET tekst
 push 0; NULL
 call _MessageBoxW@16

 push 0 ; kod powrotu programu
 call _ExitProcess@4
END

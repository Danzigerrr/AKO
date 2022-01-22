.686
.model flat
public  _kodowanie_instrukcji
extern _malloc : proc

.data

.code
_kodowanie_instrukcji proc

		;Je dalej; 0111 0100 0000 1100 ; 74h, 0Ch
		db 74h, 09h
		;----

ppp:	and eax, 0FH ;1000 00 1 1      11  100 000   0000 1111    ; bd 83h, 0E0h, 0Fh
		;db 83h, 0E0h, 0Fh
		
		;----

		mov [edx+ebx], dl  ;100010 0 0     00 010 100    00 010 011   
		;db 88h, 14h, 13h

		;----
		inc edx ;01000 010 ;42h
		;db 42h
		;----
		
		loop ppp    
		;db 0E2h, 0F7h
			
		;----

dalej:



	ret

_kodowanie_instrukcji endp
END

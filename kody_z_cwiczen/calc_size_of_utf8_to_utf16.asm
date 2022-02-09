.686
.model flat

public _calc_size_of_utf8_to_utf16
extern  _ExitProcess@4 : proc

.data
bufor	db	50H, 6FH, 0C5H, 82H, 0C4H, 85H, 63H, 7AH, 65H, 6EH, 69H, 61H, 20H 
		db	0F0H, 9FH, 9AH, 82H   ; parowóz
		db	20H, 20H, 6BH, 6FH, 6CH, 65H, 6AH, 6FH, 77H, 6FH, 20H
		db	0E2H, 80H, 93H ; półpauza
		db	20H, 61H, 75H, 74H, 6FH, 62H, 75H, 73H, 6FH, 77H, 65H, 20H, 20H
		db	0F0H,  9FH,  9AH,  8CH ; autobus
		db 0

napis_w_utf16  dw 48  dup (0)
			   dw 0 ; koniec napisu 

napis   db 'Tytul',0
.code

_calc_size_of_utf8_to_utf16 PROC
	mov  ecx, 48    ; licznik elementów naszego bufora
	mov  esi,0		; indeks pierwszego bajtu w buforze
						 ; mov  ebx,OFFSET bufor
	mov edx,0 ;wynik

	petla:
			mov al,bufor[esi]   ; mov al,[esi +bufor]  lub mov al,[ebx]
			cmp al,7Fh
			jbe znak_1bajtowy_utf8
							;													
			cmp  al, 0DFh	;	
			jbe   znak_2bajtowy_utf8
			
			cmp  al, 0EFh	;													 
			jbe   znak_3bajtowy_utf8

		znak_1bajtowy_utf8:
			add esi, 1 ;znak w utf-8 ma 1 bajt
			add edx, 2 ;utf-16 --> 2 bajty
			jmp koniec
		znak_2bajtowy_utf8:
			add esi, 2 ;znak w utf-8 ma 2 bajty
			add edx, 2 ;utf-16 --> 2 bajty
			jmp koniec
		znak_3bajtowy_utf8:
			add esi, 3 ;znak w utf-8 ma 3 bajty
			add edx, 2 ;utf-16 --> 2 bajty
			jmp koniec

		koniec:
			sub ecx,1
			cmp ecx,0
	jne petla
	
	mov ecx, edx

	push  0			; kod powrotu
	call _ExitProcess@4

_calc_size_of_utf8_to_utf16 ENDP

END

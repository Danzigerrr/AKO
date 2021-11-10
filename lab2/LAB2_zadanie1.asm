; Przyk³ad wywo³ywania funkcji MessageBoxA i MessageBoxW 
.686 
.model flat 
extern _ExitProcess@4 : PROC 
extern _MessageBoxA@16 : PROC 
extern _MessageBoxW@16 : PROC 
public _main 
.data 
tytul	dw 'T','e','k','s','t',' ','w',' ' 
		dw 'f','o','r','m','a','c','i','e',' ' 
		dw 'U','T','F','-','1','6', 0 

tekst	dw 'c','o','w',':'
		dw 0D83Dh, 0DC2Bh
		dw ' ','c','a','t',':'
		dw 0d83dh, 0dc08h
		dw 0

COMMENT	|

conversion from Unicode to utf-16:

1. take sing from unicode: https://graphemica.com/characters/tags/animal for example U+1F404
2. do math: 1F404 - 10000 = 0F404
3. 0F404 = 0000 1111 01 00 0000 0100
4. place the proper beginnings offset utf 16 number at the front offset each 10 bits:
	1101 1000 0011 1101   1101 1100 0000 0100
	  D   8     3    D     D     C    0   4

	0D83DH, 0DC04H   --> cow emoji

|


.code 
_main PROC 

push 0 ; stala MB_OK 
; adres obszaru zawieraj¹cego tytu³ 
push OFFSET tytul
; adres obszaru zawieraj¹cego tekst 
push OFFSET tekst
push 0 ; NULL 
call _MessageBoxW@16 
push 0 ; kod powrotu programu 
call _ExitProcess@4 
_main ENDP 
END


COMMENT	|

conversion from Unicode to utf-16:

1. take sing from unicode: https://graphemica.com/characters/tags/animal for example U+1F42B
2. do math: 1F404 - 10000 = 0F42B
3. 0F42B = 0000 1111 0100 0010 1011
4. place the proper beginnings offset utf 16 number at the front offset each 10 bits:
	1101 1000 0011 1101   1101 1100 0010 1011
	  D   8     3    D     D     C    2   D
	  0D83D,0DC2
	0D83D,0DC2   --> cow emoji

|

.686 
.XMM 
.model flat 
public _dodawanie_SSE 
.data 
ALIGN 16 
tabl_A dd 1.0, 2.0, 3.0, 4.0 
tabl_B dd 2.0, 3.0, 4.0, 5.0 
;jedna mozliwosc:
liczba db 1 
liczba2 db 15 dup (0)
;druga mozliwosc to zostawic tą linie zakomentowaną:
; liczba db 1
tabl_C dd 3.0, 4.0, 5.0, 6.0 
.code 
_dodawanie_SSE PROC 
	push ebp 
	mov ebp, esp 
	mov eax, [ebp+8] 
	movaps xmm2, tabl_A
	; program zepsuje się w tym miejscu, ponieważ MOVAPS wymaga wyrównania adresów,
	; więc otrzymując 1 bajt więcej zepsuje się kolejność (co nie byłoby problemem dla MOVUPS)
	; 2 powyższe linie przejdą bez błędów, ponieważ dane pasują do schematu (16 bajtowe liczby / 128 bitowe)

	movaps xmm3, tabl_B 
	movaps xmm4, tabl_C 
	addps xmm2, xmm3 
	addps xmm2, xmm4 
	movups [eax], xmm2 
	pop ebp 
	ret 
_dodawanie_SSE ENDP 
END

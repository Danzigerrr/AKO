
public suma 
.code 
suma PROC 
	;prolog
	push rbp
	mov rbp, rsp

	push rcx ;n
	push rsi ;pole adresowe przy petli rozkazowej "kolejny"

	xor rax, rax ;wyzeruj

	cmp rcx, 0
	je koniec

	;jeden
	add rax, rdx
	dec rcx
	jz koniec

	;dwa
	add rax, r8
	dec rcx
	jz koniec

	;trzy
	add rax, r9
	dec rcx
	jz koniec

	mov rsi, 48
	kolejny:
		; +48 poniewaz: 
		; œlad zajmue 8 bajtow,
		; prolog zajmuje 8 bajtow,
		; i 32 bajty shadow space(u¿ywany przez
		; wywo³an¹ funckjê)
		add rax, [rbp + rsi] ;v5 

		add rsi, 8
	loop kolejny

	koniec:

	pop rsi
	pop rcx
	pop rbp
	ret
suma ENDP
END


public suma_siedmiu_liczb 
.code 
suma_siedmiu_liczb PROC 

	mov rax, rcx ; v1
	add rax, rdx ; v2
	add rax, r8 ;v3
	add rax, r9 ;v4

	; +40 poniewaz: �lad zajmue 8 bajtow
	; i 32 bajty shadow space(u�ywany przez
	; wywo�an� funckj�)
	add rax, [rsp + 40] ;v5 
	add rax, [rsp + 48] ;v6
	add rax, [rsp + 56] ;v7

	ret
suma_siedmiu_liczb ENDP
END

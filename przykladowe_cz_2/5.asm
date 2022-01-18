
.686
.model flat
public  _szyfruj
extern _malloc : proc
.code
_szyfruj proc

;prolog
	Push ebp
	Mov ebp, esp
;rejestry
	Push esi
	Push edi
	Push edx
	Push ecx
	push ebx
	
	mov edx, 52525252h ;pierwsza liczba losowa

	mov edi, ebp
	add edi, 8
	kolejny_element:
		mov al, 0
		bt edx, 30
		jnc dalej30
		mov al, 1

		dalej30:

		mov bl, 0
		bt edx, 31
		jnc dalej31
		mov bl, 1

		dalej31:

		xor al,bl ;suma modulo dwa 30 i 31 bitu

		shl edx, 1 ;przesun o jedno w lewo

		;na bit 0 wstaw sume modulo 2 30 i 31 bitu
		bts edx, 0 ;jest 1
		cmp al, 1
		je zostaw_1
			btr edx, 0 ;ustaw 0
		zostaw_1:
	
		
		;sprawdz czy element to nie jest 0 -> wtedy koniec petli
		mov bl, [edi]
		cmp bl, 0
		je Koniec

		;zaszyfruj element:
		xor bl, dl
		
		;zapisz zaszyfrowany element
		mov [edi], bl

		add edi, 1 ;do kolejnego znaku
	jmp kolejny_element
	
Koniec:
	pop ebx
	Pop ecx
	Pop edx
	Pop edi
	Pop esi
	Pop ebp
	ret
_szyfruj endp
END

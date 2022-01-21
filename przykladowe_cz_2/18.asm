.686
.model flat
public  _ASCII_na_UTF16
extern _malloc : proc

.data
index1 dd 0
index2 dd 0
n dd ?
.code
_ASCII_na_UTF16 proc
	push ebp
	mov ebp, esp
	mov ecx, [ebp+12] ;n
	
	inc ecx ;jedno miesjce na zero na koniec
	mov eax, 2 ;16 bitow zamiast 8
	mul ecx ;2*(n+1)
	push eax;rezeracja miesjca
	call _malloc
	add esp, 4

	mov edi, eax ;adres docelowej tablicy
	mov edx, eax ;kopia
	mov esi, [ebp+8] ;adres orginalnej tablicy
	mov ecx, [ebp+12] ;n

	konwersja:

		mov eax, [esi]

		mov [edi], eax

		mov eax, 0
		mov [edi+1], eax

		add esi, 1
		add edi, 2

	loop konwersja


	mov eax, edx

koniec:
	pop ebp
	ret

_ASCII_na_UTF16 endp
END

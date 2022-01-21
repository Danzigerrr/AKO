.686
.model flat
public  _sortowanie
extern _malloc : proc

.data
index1 dd 0
index2 dd 0
n dd ?
.code
_sortowanie proc
	push ebp
	mov ebp, esp

	mov ebx, [ebp+8] ;adres tablicy
	mov ecx, [ebp+12] ;n
	
	mov n, ecx

	dec ecx

	for1:
		push ecx
		mov ecx,index1
		mov eax, [ebx+8*ecx]
		mov edx, [ebx+8*ecx+4]
		pop ecx
		for2:
			push ecx
			mov ecx,index2
			mov esi, [ebx+8*ecx]
			mov edi, [ebx+8*ecx+4]
			pop ecx


			cmp edi, edx 
			ja bez_swapa

			cmp esi, eax 
			ja bez_swapa

				;swap:
				push ebp
				push ecx
					mov ecx, index1
					mov ebp, index2

					mov [ebx+8*ebp], eax
					mov [ebx+8*ebp+4], edx
					mov [ebx+8*ecx], esi
					mov [ebx+8*ecx+4], edi

					;wartosc pierwszejporownywnej liczby musi zostać taka sama!!!!!
					mov eax, [ebx+8*ecx]
					mov edx, [ebx+8*ecx+4]
				pop ecx
				pop ebp

			bez_swapa:

		;loop
		inc index2
		push ecx
		mov ecx, n
		cmp index2, ecx
		pop ecx
		jb for2

		;zerowanie index2
		push ecx
		mov ecx,0
		mov index2,ecx
		pop ecx

	;loop
	inc index1
	push ecx
	mov ecx, n
	cmp index1, ecx
	pop ecx
	jb for1
		
	;wynik przekazany jako liczba EDX:EAX

	mov eax, [ebx] ;mlodsza
	mov edx, [ebx+4] ;starsza
koniec:
	pop ebp
	ret

_sortowanie endp
END

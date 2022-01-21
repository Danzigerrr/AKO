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
	

;	for(int i=0;i<n;i++)
;	for(int j=0;j<n;j++){
;		if(tab[i] < tab[j])
;		swap();
;	}

	mov n, ecx

	dec ecx

	for1:
		push ecx
		mov ecx,index1
		mov eax, [ebx+4*ecx]
		pop ecx
		for2:
			push ecx
			mov ecx,index2
			mov esi, [ebx+4*ecx]
			pop ecx

			cmp esi, eax

			jge bez_swapa

				;swap:
				push edx
				push ecx
					mov ecx, index1
					mov edx, index2
					mov [ebx+4*edx], eax
					mov [ebx+4*ecx], esi
					mov eax, [ebx+4*ecx]
					mov esi, [ebx+4*ecx]
				pop ecx
				pop edx

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

	mov eax, [ebx]

koniec:
	pop ebp
	ret

_sortowanie endp
END

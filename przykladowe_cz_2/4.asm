.686
.model flat
public  _szukaj_elem_min
extern _malloc : proc
.code
_szukaj_elem_min proc

;prolog
	Push ebp
	Mov ebp, esp
;rejestry
	Push esi
	Push edi
	Push edx
	Push ecx
	
	mov esi, [ebp+8] ; tabl
	mov ecx, [ebp+12] ; n

;zakladamy, ze pierwszy element jest najmniejszy
	mov  eax, esi ; adres min

	szukaj:
		mov edx, [esi]
		mov edi, [eax]
		cmp edi, edx ;porownaj nową liczbę z min

		jb dalej ;jesli wieksza lub rowna to idz dalej

		mov eax,esi ;zapisz adres nowego min

		dalej:
		add esi, 4
	loop szukaj
	
Koniec:
	Pop ecx
	Pop edx
	Pop edi
	Pop esi
	Pop ebp
	ret
_szukaj_elem_min endp
END


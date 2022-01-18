.686
.model flat
public  _komunikat
extern _malloc : proc
.code

_komunikat proc

;prolog
	Push ebp
	Mov ebp, esp
	
;rejestry
	Push esi
	Push edi
	Push edx
	Push ecx
	
;policz ile znaków ma tekst
	Mov esi, [ebp+8]
	Mov eax, 0
	licz:
		Mov dl, [esi]
		;mov edi, [edi]
		Cmp dl, 0
			Je koniec_liczenia_znakow
		Add eax, 1
		add esi, 1
	Jmp licz
	
	koniec_liczenia_znakow:
	
	Mov ecx, eax ; przyda się przy przepisywaniu elementow w petli
	
	Add eax, 1 ;lancuch znakow konczy się zerem

	Add eax, 4 ; do 'Błąd' 4 bajtow
	
	Mov esi, eax

	Mov eax, 4
	Mov edx, 0
	Mul esi ;eax => eax*4
;rezerwacja miejsca
	Push eax
	push ecx
	Call _malloc
	pop ecx
	Add esp, 4
	
;adres nowej tablicy zapisany w eax

;przepisz tablice

	Mov esi, [ebp+8] ;source
	Mov edi, eax ;dest
	

	Kolejny:
		Mov dl, [esi]
		Mov [edi], dl
		Add esi, 1
		Add edi, 1
	
	Loop Kolejny
	
;dopisz lancuch 'Błąd'

	Mov dl, 'B'
	Mov [edi], dl
	Add edi, 1
	
	Mov dl, 'ł'
	Mov [edi], dl
	Add edi, 1
	
	Mov dl, 'ą'
	Mov [edi], dl
	Add edi, 1
	
	Mov dl, 'd'
	Mov [edi], dl
	Add edi, 1
	
;0 konczy lancuch znakow
	Mov edx, 0
	Mov [edi], dl
	
	
Koniec:

	Pop ecx
	Pop edx
	Pop edi
	Pop esi

	Pop ebp
	ret

_komunikat endp
END

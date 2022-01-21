.686
.model flat
public  _konwersja_32_na_64_w_pamieci
extern _malloc : proc

.data
liczba1 dd -2.0


.code
_konwersja_32_na_64_w_pamieci proc
	push ebp
	mov ebp, esp

	push ecx

	;esi - adres liczby float --> ebp+8
	;edi - adres liczby double --> ebp+12

	mov esi, [ebp+8]
	mov eax, esi
	mov eax, [eax] ;float

	mov edi, [ebp+12]
	mov ebx, edi
	mov edx, [ebx + 4] ;starsza double
	mov ebx, [ebx] ;mlodzsa double


	;pierwszy bit liczby to znak
znak:
	btr edx, 31 ;ustaw 0 (+)
	bt eax, 31
	jnc wykladnik
	bts edx, 31 ;ustaw 1 (-)

wykladnik:
	;8 pierwszych bitow wyklanika
	mov ecx, 8
	mov esi, 30
	ustaw_w:
		btr edx, esi
		bt eax, esi
		jnc dalej_w
			bts edx, esi
		dalej_w:
	dec esi
	loop ustaw_w


	;3 zera na koncu wykladnika
	mov ecx, 3

	ustaw_w_zera:
		btr edx, esi
		dec esi
	loop ustaw_w_zera

mantysa:
	;pierwsza czesc mantysy
	mov ecx, 19

	ustaw_m1:
		btr edx, ecx

	dec ecx
	cmp ecx, -1
	jne ustaw_m1


	;druga czes mantysy
	mov ecx, 3
	mov esi, 31
	ustaw_m2:
		btr ebx, esi
		bt ebx, esi
		jnc dalej_m2
			bts ebx, esi
		dalej_m2:
		dec esi
	loop ustaw_m2


	;ustawianie zer na koncu
	mov ecx, 29

	ustaw_m3:
		btr ebx, ecx
	loop ustaw_m3

	

koniec:
pop ecx
	ret
_konwersja_32_na_64_w_pamieci endp
END

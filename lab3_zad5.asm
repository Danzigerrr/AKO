
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
znaki db 12 dup (?) 


	dekoder db '0123456789ABCDEF'
.code



wczytaj_do_EAX PROC

	; Zapamietanie rejestrow ogolnego przeznaczenia, ale bez:
	; - EAX: zepsuloby to wynik dzialania podprogramu
	; - EBP: bo go nie modyfikujemy
	; - ESP: bo nie mo¿emy go ruszaæ w podprogramie, nigdy
	push ebx
	push ecx
	push edx
	push esi
	push edi

	push dword ptr 12           ; length
	push dword ptr offset znaki ; * znaki
	push dword ptr 0            ; stdin
	call __read
	add  esp, 12

	; zamiana cyfr w kodzie ASCII na liczbê binarn¹ 
	mov esi, 0 ; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest w rejestrze ESI - przyjmujemy 0 jako wartoœæ pocz¹tkow¹ 
	mov ebx, offset znaki ; adres obszaru ze znakami 

nowy: 
	mov   al, [ebx] ; Iterujemy po znaki[ebx]
	inc   ebx       ; ebx++
	cmp   al, 10    ; Enter?
	je    finish    ; Tak, koniec...
	sub   al, 30H   ; ASCII -> wartoœæ cyfry 
	movzx edi, al   ; Zapisujemy do EDI 
	mov   eax, 10
	mul   esi       ; EDI * 10 
	add   eax, edi  ; dodanie ostatnio odczytanej cyfry
	mov   esi, eax  ; dotychczas obliczona wartoœæ
	jmp   nowy      ; jedziemy dalej...
 
finish:
	mov eax, esi ; Zapisujemy wynik do EAX
	
	; Przywracamy rejestry
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx

	ret
wczytaj_do_EAX ENDP

wyswietl_EAX_hex PROC 
	; wyœwietlanie zawartoœci rejestru EAX w postaci liczby szesnastkowej 
	pusha ; przechowanie rejestrów 

	; rezerwacja 12 bajtów na stosie przeznaczonych
	;na tymczasowe przechowanie cyfr szesnastkowych wyœwietlanej liczby 
	sub esp, 12 
	mov edi, esp ; adres zarezerwowanego obszaru pamiêci
	
	; przygotowanie konwersji 
	mov ecx, 8 ; liczba obiegów pêtli konwersji 
	mov esi, 1 ; indeks pocz¹tkowy u¿ywany przy zapisie cyfr 
	
	; pêtla konwersji 
	ptl3hex:
		; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo 
		; w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28 
		; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0 
		rol eax, 4 

		; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy 
		; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym 
		mov ebx, eax ; kopiowanie EAX do EBX 
		and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX 
		mov dl, dekoder[ebx] ; pobranie cyfry z tablicy 

		dalej:
		; przes³anie cyfry do obszaru roboczego 
		mov [edi][esi], dl 

		inc esi ;inkrementacja modyfikatora 
	loop ptl3hex ; sterowanie pêtl¹ 

	mov al, 30h ;30h -> zero
	mov dl, 20h ;20h -> spacja
	mov ecx,8 ;licznik petli
	mov ebx,1 ;indeks najstarszego bitu

	usun_zera_niezanczace:
	cmp [edi][ebx], al ;porownanie cyfry do zera
	jne koniec_usun_zera_niezanczace

	mov byte ptr [edi][ebx], dl ;spacja
	inc ebx ;kolejny indkes
	loop usun_zera_niezanczace

	koniec_usun_zera_niezanczace:
	; wpisanie znaku nowego wiersza przed i po cyfrach 
	mov byte PTR [edi][0], 10 
	mov byte PTR [edi][9], 10

	; wyœwietlenie przygotowanych cyfr 
	push 10 ; 8 cyfr + 2 znaki nowego wiersza 
	push edi ; adres obszaru roboczego 
	push 1 ; nr urz¹dzenia (tu: ekran) 
	call __write ; wyœwietlenie 

	; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych 
	; przez 3 rozkazy push przed rozkazem call 
	; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu 
	add esp, 24 

	popa ; odtworzenie rejestrów
	ret ; powrót z podprogramu 


wyswietl_EAX_hex ENDP

zera_na_spacje PROC


	ret
zera_na_spacje ENDP

_main PROC

	call wczytaj_do_EAX

	call wyswietl_EAX_hex

	call zera_na_spacje


	push 0
	call _ExitProcess@4	
_main ENDP
END 


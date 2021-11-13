
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
	; - ESP: bo nie mo�emy go rusza� w podprogramie, nigdy
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

	; zamiana cyfr w kodzie ASCII na liczb� binarn� 
	mov esi, 0 ; bie��ca warto�� przekszta�canej liczby przechowywana jest w rejestrze ESI - przyjmujemy 0 jako warto�� pocz�tkow� 
	mov ebx, offset znaki ; adres obszaru ze znakami 

nowy: 
	mov   al, [ebx] ; Iterujemy po znaki[ebx]
	inc   ebx       ; ebx++
	cmp   al, 10    ; Enter?
	je    finish    ; Tak, koniec...
	sub   al, 30H   ; ASCII -> warto�� cyfry 
	movzx edi, al   ; Zapisujemy do EDI 
	mov   eax, 10
	mul   esi       ; EDI * 10 
	add   eax, edi  ; dodanie ostatnio odczytanej cyfry
	mov   esi, eax  ; dotychczas obliczona warto��
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
	; wy�wietlanie zawarto�ci rejestru EAX w postaci liczby szesnastkowej 
	pusha ; przechowanie rejestr�w 

	; rezerwacja 12 bajt�w na stosie przeznaczonych
	;na tymczasowe przechowanie cyfr szesnastkowych wy�wietlanej liczby 
	sub esp, 12 
	mov edi, esp ; adres zarezerwowanego obszaru pami�ci
	
	; przygotowanie konwersji 
	mov ecx, 8 ; liczba obieg�w p�tli konwersji 
	mov esi, 1 ; indeks pocz�tkowy u�ywany przy zapisie cyfr 
	
	; p�tla konwersji 
	ptl3hex:
		; przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo 
		; w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28 
		; rejestru EAX zostan� przesuni�te na pozycje 3 - 0 
		rol eax, 4 

		; wyodr�bnienie 4 najm�odszych bit�w i odczytanie z tablicy 
		; 'dekoder' odpowiadaj�cej im cyfry w zapisie szesnastkowym 
		mov ebx, eax ; kopiowanie EAX do EBX 
		and ebx, 0000000FH ; zerowanie bit�w 31 - 4 rej.EBX 
		mov dl, dekoder[ebx] ; pobranie cyfry z tablicy 

		dalej:
		; przes�anie cyfry do obszaru roboczego 
		mov [edi][esi], dl 

		inc esi ;inkrementacja modyfikatora 
	loop ptl3hex ; sterowanie p�tl� 

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

	; wy�wietlenie przygotowanych cyfr 
	push 10 ; 8 cyfr + 2 znaki nowego wiersza 
	push edi ; adres obszaru roboczego 
	push 1 ; nr urz�dzenia (tu: ekran) 
	call __write ; wy�wietlenie 

	; usuni�cie ze stosu 24 bajt�w, w tym 12 bajt�w zapisanych 
	; przez 3 rozkazy push przed rozkazem call 
	; i 12 bajt�w zarezerwowanych na pocz�tku podprogramu 
	add esp, 24 

	popa ; odtworzenie rejestr�w
	ret ; powr�t z podprogramu 


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


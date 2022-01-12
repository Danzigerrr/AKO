;koloruj polowe ekranu
.386
rozkazy SEGMENT use16
	ASSUME cs:rozkazy

prostokat PROC
; przechowanie rejestrów
	push bx
	push ax
	push dx
	push es
	push ecx

	mov ax, 0A000H ; adres pamięci ekranu dla trybu 13H
	mov es, ax

	mov dx, cs:kierunek_teraz
	cmp cs:kierunek_2, dx
	je normalnie

		czarne:	
			mov al, 0 ;czarny
			mov cx, 320*200 ;cała plansza
			mov cs:adres_piksela, 0 ;od poczatku planszy
			kolejny_pixel_na_czarno:
				mov bx, cs:adres_piksela
				mov	es:[bx], al ; wpisanie kodu koloru do pamięci ekranu
				 ;kolejny pixel
				add bx, 1
				mov cs:adres_piksela, bx
			loop kolejny_pixel_na_czarno
		;zapisz nowy kierunek w zmiennej kopii
		mov cs:kierunek_2, dx

	; 1 sekunda to 18 cykli
	normalnie:
	cmp cs:licznik, 18		
	jb czerwony				
	cmp cs:licznik, 36		
	jb zielony			
	jmp niebieski

	czerwony:				
		mov al, 4 ;kod koloru
		inc cs:licznik
		jmp kolor_koniec
	zielony:				
		mov al, 2 ;kod koloru
		inc cs:licznik
		jmp kolor_koniec
	niebieski:
		mov al, 1 ;kod koloru
		inc cs:licznik
	
	cmp cs:licznik, 54		
	jb kolor_koniec				
	mov cs:licznik, 0	
	jmp kolor_koniec

	kolor_koniec:					
		cmp cs:kierunek_teraz, 3			
		je kolor_gora			
		cmp cs:kierunek_teraz, 2
		je kolor_dol
		cmp cs:kierunek_teraz, 1
		je kolor_lewo
		cmp cs:kierunek_teraz, 0
		je kolor_prawo

	kolor_gora:
		mov dx, cs:wys; 100
		mov cx, cs:szr2 ;320
		mov cs:adres_piksela, 0 ;lewy gorny rog
		mov cs:poczatek, 0  ;lewy gorny rog
		jmp koloruj

	kolor_dol:
		mov dx, 100*320 ;100 wierszy,  wkazdym po 320 (160 znaczkow)
		mov cs:adres_piksela, dx			
		mov cs:poczatek, dx	
		mov dx, cs:wys
		mov dx, cs:wys
		mov cx, cs:szr2
		jmp koloruj

	kolor_lewo:
		mov dx, cs:wys2
		mov cx, cs:szr		

		mov cs:adres_piksela, cx	
		mov cs:poczatek, cx
		jmp koloruj

	kolor_prawo:
		mov cx, cs:szr		
		mov dx, cs:wys2			
		
		mov cs:adres_piksela, 0		
		mov cs:poczatek, 0
		jmp koloruj

	koloruj:					
	kolor_kolumn:					
		push cx			
		mov cx, dx
		kolor_rzad:				
			mov bx, cs:adres_piksela ; adres bieżący piksela
			mov es:[bx], al ; wpisanie kodu koloru do pamięci ekranu
			; przejście do następnego wiersza na ekranie
			add bx, 320
			mov cs:adres_piksela, bx
			; sprawdzenie czy cała linia wykreślona
			loop kolor_rzad
		pop cx
		add word PTR cs:przesuniecie, 1
		mov bx, cs:poczatek
		add bx, cs:przesuniecie
		mov cs:adres_piksela, bx
		loop kolor_kolumn
	
; odtworzenie rejestrów

	mov cs:przesuniecie, 0
	pop ecx
	pop es
	pop dx
	pop ax
	pop bx

; skok do oryginalnego podprogramu obsługi przerwania
; zegaprzesuniecieego
	 jmp dword PTR cs:wektor8

; zmienne procedury
	licznik dw 0; zegar

	kierunek_teraz dw 0	;aktualny keirunek

	kierunek_2 dw 0 ;stary kierunek

	;rozmiar konsoli
	wys	dw 100
	szr	dw 160
	wys2 dw 200
	szr2 dw 320

	poczatek dw 0 
	adres_piksela dw 0		; bieżący adres piksela

	przesuniecie	dw 0		;indeks kolumny

	wektor8	dd ?
prostokat ENDP


obsluga_klaw PROC
	push bx
	push es
	push ax

	mov ax, 0B800h ;adres pamięci ekranu
	mov es, ax


	;z klawiatury
	in al, 60h

	;jak pusci klawisz
	cmp al, 200;72
	je bedzie_gora

	cmp al, 208 ;80
	je bedzie_dol

	cmp al, 203
	je bedzie_prawo

	cmp al, 205
	je bedzie_lewo

	jmp kolor_koniec2

	;0 - prawa połowa (domyślne), 1 - lewa połowa, 2 - dolna połowa, 3 - górna połowa
	bedzie_gora:					;ustawianie górnej połowy ekranu
		mov cs:kierunek_teraz, 3
		jmp kolor_koniec2

	bedzie_dol:				;ustawianie dolnej połowy ekranu
		mov cs:kierunek_teraz, 2
		jmp kolor_koniec2

	bedzie_lewo:				;ustawianie lewej połowy ekranu
		mov cs:kierunek_teraz, 1
		jmp kolor_koniec2

	bedzie_prawo:				;ustawianie prawej połowy ekranu
		mov cs:kierunek_teraz, 0
		jmp kolor_koniec2


;zakoncz ustawianie nowego kierunku
	kolor_koniec2:
	pop ax
	pop es
	pop bx


	jmp dword PTR cs:wektor9

	wektor9 dd ?
obsluga_klaw ENDP



; INT 10H, funkcja nr 0 ustawia tryb steprzesuniecienika graficznego
zacznij:
	mov ah, 0
	mov al, 13H ; nr trybu
	int 10H
	mov bx, 0
	mov es, bx 
	mov eax, es:[32] ; odczytanie wektora nr 8
	mov cs:wektor8, eax; zapamiętanie wektora nr 8

;segment:offset
	mov ax, SEG prostokat
	mov bx, OFFSET prostokat
	cli ; zablokowanie przerwań

; zapisanie adresu procedury 'prostokat' do wektora nr 8
	mov es:[32], bx
	mov es:[32+2], ax
	sti ; odblokowanie przerwań
	
	mov eax, es:[36] ; odczytanie wektora nr 9
	mov cs:wektor9, eax; zapamiętanie wektora nr 9

	mov ax, SEG obsluga_klaw
	mov bx, OFFSET obsluga_klaw
	cli ; zablokowanie przerwań

; zapisanie adresu procedury 'obsluga_klaw' do wektora nr 9
	mov es:[36], bx
	mov es:[36+2], ax
	sti ; odblokowanie przerwań


	czekaj:	
		mov ah, 0
		int 16H
		cmp al, 1Bh ;Escape -> wyjscie
		jne czekaj
		mov ah, 0 ; funkcja nr 0 ustawia tryb steprzesuniecienika
		mov al, 3H ; nr trybu
		int 10H

; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	mov es:[32], eax

	mov eax, cs:wektor9
	mov es:[36], eax

; zakończenie wykonywania programu
	mov ax, 4C00H
	int 21H
rozkazy ENDS

stosik SEGMENT stack
	db 256 dup (?)
stosik ENDS

END zacznij
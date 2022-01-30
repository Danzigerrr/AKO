comment @ 
//kod w C:


#include <stdio.h>

void wyswietl64(unsigned __int64);

int main()
{
	unsigned __int64 a= 0x0000000012345678;

	wyswietl64(a);

}

@

.686
.model flat


public _wyswietl64
extern  _MessageBoxA@16 : PROC

.data
; a = 1234567899999999h
;a_db     db 99h,99h,99h,99h,78h,56h,34h,12h
;a_dw     dw 9999h,9999h,5678h,1234h
;a_dq     dq 1234567899999999h
;             a0     , a1         -> LE czyli MNIEJSZE NIŻEJ
;a_dd     dd 99999999h,12345678h


;zmienne do MessageBox
tekst db 'wynik',0
wynik  db	20 dup (0), 0		; ciag ASCII reprezentujący liczbę

.code

_wyswietl64 PROC
	push ebp
	mov ebp,esp		; prolog
	push ebx
	push edi

	mov ebx,10	; dzielnik
  
	mov eax,[ebp+8]     ;; a_dd    ; eax <- a0
	mov edx,[ebp+12]  ;;;a_dd[4] ; edx <- a1
	mov edi,0		; licznik odłożonych cyfr

od_nowa:
	mov ecx,eax		; ecx <-a0
	mov eax,edx		; eax <-a1
	mov edx,0		; 0 : a1 /10
	div ebx			; eax<-w1, edx<-r1

	xchg  ecx, eax  ; eax<-a0, ecx<-w1

					; edx <-r1, eax <- a0
	div ebx		 ; eax<-w0, edx<-r0

	add dl,'0' ; '0' = 30h ; 33h - '3'  konwersja na ASCII
	push edx 
	inc edi	; zwiększenie licznika cyfr
	mov edx,ecx   ; edx <- w1 (nowe a1), eax = w0 (nowe a0)
				; ecx <- w1

	or  ecx,eax	 ;  ecx <- eax OR ecx  ustawiane flagi  ZF  
jnz  od_nowa   ; wyjście z pętli, gdy w1 i w0 == 0
  
	mov ecx,edi
	mov edi,0

;przepisz cyfry ze stosu do bufora z liczbą jako wynik
zapisz_wynik:
	pop edx
	mov wynik[edi],dl
	inc edi
loop zapisz_wynik
  
	push 0
	push offset tekst
	push offset wynik
	push 0
	call _MessageBoxA@16
   
	pop edi
	pop ebx
	pop ebp
ret
	
_wyswietl64 ENDP 

END

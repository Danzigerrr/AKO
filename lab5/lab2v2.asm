.686 
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE 
.model flat 
public _wyznacz_sumy_SSE
.code 
_wyznacz_sumy_SSE PROC 
push ebp 
mov ebp, esp 
push ebx 
push esi 
push edi 
mov esi, [ebp+8] ; adres pierwszej tablicy 
mov edi, [ebp+12] ; adres drugiej tablicy 
mov ebx, [ebp+16] ; adres tablicy wynikowej 

movups xmm5, [esi] 
movups xmm6, [edi] 
; sumowanie czterech liczb zmiennoprzecinkowych zawartych 
; w rejestrach xmm5 i xmm6 
paddsb xmm5, xmm6

; zapisanie wyniku sumowania w tablicy w pamiêci 
movups [ebx], xmm5 
pop edi 
pop esi 
pop ebx 
pop ebp 
ret 
_wyznacz_sumy_SSE ENDP 

END
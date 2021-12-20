.686 
.XMM  ; zezwolenie na asemblacj rozkaz�w grupy SSE 
.model flat 
 
public _int_na_float
 
.code 
 
_int_na_float PROC 
             push  ebp 
             mov   ebp, esp

             push  esi 
             push  edi 
 
             mov   esi, [ebp+8]    ; adres pierwszej tablicy 
             mov   edi, [ebp+12]   ; adres drugiej tablicy 
 
             movups   xmm5, [edi] 
 
; sumowanie czterech liczb zmiennoprzecinkowych zawartych 
; w rejestrach xmm5 i xmm6 
             cvtpi2ps    xmm5, qword PTR [esi]
                                    
; zapisanie wyniku sumowania w tablicy w pamici 
             movups   [edi], xmm5 
 
             pop   edi 
             pop   esi 
             pop   ebp 
             ret 
_int_na_float ENDP 
 
END
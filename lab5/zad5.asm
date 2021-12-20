.686 
.XMM  ; zezwolenie na asemblacje rozkazów grupy SSE 
.model flat 
 
public _pm_jeden

.data
floaty dd 1.0,1.0,1.0,1.0 ;same jedynki
.code 
 
_pm_jeden PROC 
    push  ebp 
    mov   ebp, esp

    push  esi 
    push  edi 
 
    mov   esi, [ebp+8]    ; adres tablicy 
 
    movups   xmm5, floaty
    movups   xmm3, [esi] 
 
; sumowanie czterech liczb zmiennoprzecinkowych zawartych 
; w rejestrach xmm5 i xmm6 
    ADDSUBPS    xmm3, xmm5
                                    
; zapisanie wyniku sumowania w tablicy w pamici 
    movups   [esi], xmm3
 
    pop   edi 
    pop   esi 
    pop   ebp 
    ret 
_pm_jeden ENDP 
 
END

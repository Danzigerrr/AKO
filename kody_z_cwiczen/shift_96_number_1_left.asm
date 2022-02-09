

.686
.model flat
public _shift_96_number_1_left

.data

.code
;shift_96_number_1_left
_shift_96_number_1_left	PROC

;the 96 bit number is stored as:
; EDX:EBX:EAX
mov edx, 0FFFF0000h
mov ebx, 00000000h
mov eax, 0FFFFFFFFh

bt edx, 31
rcl eax,1
rcl ebx,1
rcl edx,1

ret
_shift_96_number_1_left	ENDP

END

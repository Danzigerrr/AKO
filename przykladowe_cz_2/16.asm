.686
.model flat
public  _liczba_procesow
extern _malloc : proc
extern _GetSystemInfo@4 : proc
.data

.code
_liczba_procesow proc
	
	push eax
	Call _GetSystemInfo@4

	ret

_liczba_procesow endp
END

.686
.model flat
public  _ustaw_flage_TF
extern _malloc : proc

.data


.code
_ustaw_flage_TF proc

	pushf
	mov eax, [esp]
	bts eax,8
	mov [esp], eax
	popf

	ret

_ustaw_flage_TF endp
END

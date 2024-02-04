		.386
;
;
	include		xmhd.inc
	include		xmmac.mac
_DATA		segment	para public USE16 'DATA'
		extrn	debugflag:word
_DATA		ends
		
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
		public	Msg, PutSpace, PutChar, GetChar
		public	CRLF, Msg2ch, put2char, Hex32s, Hex, Hex32
		public	Hexs, HexALs
		extrn	a20_off:near, a20_on:near
;

Msg		proc	near
		push	si
		mov	si, dx
		cld
MsgMore:
		lodsb	
		cmp	al, 0
		je	.MsgX
		call	putchar
		jmp	MsgMore
.MsgX:		pop	si
		ret
Msg		endp

;
; now putchar/getchar support output to the commnunication port.
;
PutSpace	proc	near
		mov	al,' '
putchar		label	near
		test	DebugFlag, MASK Sys_Out_COM
		jnz	.putCom
IF  PCAT
		mov	ah, 0eh
		int	10h
ENDIF
IF  FMR70
		push	dx
		call	a20_off
		mov	dl, al
		mov	ah, 1dh
		int	91h
		call	a20_on
		pop	dx
ENDIF
		ret
.putCom:
IF PCAT		
		mov	ah, 1
		push	dx
		mov	dx, CommPort
		int	14h		
		pop	dx
ENDIF
IF FMR70
ENDIF
		ret
		endp

getchar		proc	near
;		test	DebugFlag, MASK Sys_Out_COM
;		jnz	.getCom
IF PCAT
		mov	ah,0
		int	16h
ENDIF
IF FMR70
		push	dx
		push	bx
		mov	ax, 0900h
		int	90h
		mov	al,dl
		pop	bx
		pop	dx
ENDIF		
		ret
.getCom:
IF PCAT
		mov	ah,2
		push	dx
		mov	dx, CommPort
		int	14h
		pop	dx
ENDIF
IF FMR70
		push	dx
		mov	dl, al
		mov	ah, 7
		mov	al, CommPort
		int	9bh
		pop	dx
ENDIF
		ret
		endp

;
; put2char will be used to output Kanji character.
;
CRLF		proc	near
		mov	ax, 0d0ah
Msg2ch		label	near
put2char	label	near
		push	ax
		mov	al, ah
		call	putchar
		pop	ax
		call	putchar
		ret
		endp

HexS		label	near
		push	ax
		call	PutSpace
		pop	ax
		jmp	Hex

HexALS		label	near
		push	ax
		call	PutSpace
		pop	ax
		jmp	HexAL

Hex32s		proc	near
		push	eax
		call	PutSpace
		pop	eax
Hex32:		push	eax
		shr	eax, 16
		call	Hex
		pop	eax
Hex:		push	ax
		mov	al, ah
		call	HexAL
		pop	ax
HexAL:		push	ax
		shr	al, 4
		call	HexDig
		pop	ax
HexDig:		and	ax, 0fh
		mov	ah, 3
		aaa
		adc	al, 0
		shl	al, 4
		shr	ax, 4
		call	PutChar
		ret
Hex32S		endp

_TEXT		ends
		end	
comment %
;
; copy parsed argument into stack of child program.
; used for C-interface (=UNIX interface)
;
CopyArg		proc	near
		push	ds
		mov	ds, PSP
		assume	ds: nothing, es: _DATA
		mov	esi, 81h
		movzx	ecx, ArgLen
		mov	edi, ExeESP
		sub	edi, ecx
		and	edi, NOT 3
		mov	ArgP, edi
		mov	ExeESP, edi
		add	edi, EData.Base
		sub	edi, ThisDataBase
		prefix32
	rep	movsb		;copy command line
		pop	ds
		assume	ds: _DATA, es: nothing
		ret
CopyArg		endp
%

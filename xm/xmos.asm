		.386

thiscodesel	=	18h
		
		include	xmhd.inc
		include	xmmac.mac
		include	xmmsg.def

_DATA		segment	para public USE16 'DATA'
		extrn	DosLog:word
		ends


_TEXT		segment	para public USE16 'CODE'
IF PCAT
		extrn	P8259: near
ENDIF
		extrn	a20_on:near, a20_off:near
_TEXT		ends

		
		
		
_DATA		segment	para public USE16 'DATA'
		public	endcode

RealGateSP	dw	?
EndCode		db	0

_DATA		ends
;
;
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
		public	OSExit
		
OSExit		proc	near
IF  PCAT
		push	ax
		mov	ah, 08h			;reloc ints to 8
		call	P8259			;program 8259
		pop	ax
ENDIF
IF  FMR70		
		call	a20_off
;		call	cpu_setup16
ENDIF
IF TransPort		
		lea	si, DosLog
		mov	cx, 0h
		cld
.dosout:	
		lodsw
		cmp	ax, 0
		jz	.dosout1
		push	ax
		mov	al, cl
		call	HexALs
		mov	al,':'
		call	putchar
		pop	ax
		call	Hex
.dosout1:
		inc	cx
		cmp	cx, DosFuncMax
		jbe	.dosout
		call	CRLF
ENDIF
IF FMR70
		call	a20_off
ENDIF
		mov	ah, 4ch
		mov	al, EndCode
		int	21h
OSExit		endp

_TEXT		ends
		end	

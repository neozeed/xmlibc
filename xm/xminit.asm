		.386
		include	xmhd.inc
		include xmmac.mac
		include	xmmsg.def
;
_DATA		segment	para public USE16 'DATA'
		extrn	edata:sect, ebss:sect, ecode:sect
_DATA		ends
;
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
		extrn	a20_on:near, a20_off:near
		extrn	pushtoexestack:near

		public  CopyVectors, setenvp	
CopyVectors	proc	near
		push	ds
		push	es
		sub	ax, ax
		mov	ds, ax
		mov	es, ax
		mov	si, 4*8		;copy vectors 8..f
		mov	di, 4*50h	;to 50..57
		mov	cx, 8		;eight double words
		rep	movsd
		pop	es
		pop	ds
		ret
CopyVectors	endp

SetEnvP		proc	near
		sub	eax, eax
		jmp	PushToExeStack
SetEnvP		endp

comment %

SetParm		proc	near
		push	es
		push	di
		push	cx
		mov	ax, _DATA
		mov	es, ax
		lea	di, PSPwork[129]
		mov	cx, 127
		cld
.setpr04:
		mov	al, es:[di]
		mov	es:byte ptr[di],' '
		inc	di
		dec	cx
		cmp	al, ' '
		jbe	.setpr04
.setpr05:
		mov	al, es:[di]
		cmp	al, ' '
		jbe	.setpr01
		mov	es:byte ptr[di],' '
		inc	di
		loop	.setpr05
		
.setpr01:
		mov	al, es:[di]
		cmp	al, 0
		jnz	.setpr02
		mov	es:byte ptr[di], ' '
.setpr02:
		inc	di
		loop	.setpr01
		pop	cx
		pop	di
		pop	es
		ret	
SetParm		endp
%
		public	memoryconfig, memscan, memmax

;
;
; Check memory configration by compairing lowest memory and just at 1MB area.
;	return cf=1 if 8Kbytes data is match
;	by cf=0, we assume that extended memory (above 1MByte) is valid.
;
MemoryConfig	proc	near	
		push	ds
		push	es
		push	cx
IF FMR70
		call	a20_on
ENDIF
		mov	cx, 0
		mov	ds, cx
		mov	si, cx
;
		mov	cx, 0ffffh
		mov	es, cx
		mov	di, 10h
;
		mov	cx, 0fffh
		cld
	repz	cmpsw			
		cmp	cx, 0
		je	.MemNormal
IF FMR70
		call	a20_on
ENDIF
		stc
.MemNormal:
		cmc
		pop	cx
		pop	es
		pop	ds
		ret
MemoryConfig	endp

memscan		proc	near
IF  FMR70
		call	a20_on
ENDIF
		mov	ax, es:word ptr[esi]
IF FMR70 and Testing
		call	a20_off
ENDIF
		mov	bx, ax
		not	ax
IF FMR70 and Testing
		call	a20_on
ENDIF
		mov	es: word ptr[esi], ax
		cmp	ax, es:word ptr[esi]
		mov	es:word ptr[esi], bx
IF FMR70 and Testing
		call	a20_off
ENDIF
		jne	.memscanx

		add	esi, edx
		cmp	esi, edi
		jae	.memscanx
		loop	memscan
.memscanx:
		ret
memscan		endp


MemMax		proc	near
;
; judge how much memory(above 1MB) is available
;	set maxmem in EData.Hi and return in esi
;
		push	es
		push	ax
		push	bx
		push	edi
;
IF PCAT
		call	a20_on
		mov	ax,8800h	; extended memory in K bytes
		int	15h
ENDIF
IF FMR70
		mov	ax,3072		; 3MByte of memory at most
ENDIF
		movzx	edx, ax
		shl	edx, 10
		mov	esi, 1024 * 1024	; at least
		lea	edi, [edx + esi]	; at most
;
		mov	ax, 0
		mov	es, ax
		shr	edx, 3
		mov	ecx, 11		; 
.exist:		
		push	cx
		mov	cx, 8			; 8M bytes at most
		call	memscan
		sub	esi, edx
		pop	cx
		shr	edx, 2
		loopnz	.exist
		pop	edi
		pop	bx
		pop	ax
		pop	es
		mov	EData.Hi, esi
		mov	EBSS.Hi, esi
		ret
		endp


_TEXT		ends
		end	

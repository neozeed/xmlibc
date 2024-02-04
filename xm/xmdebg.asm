		.386
;
		include	xmhd.inc
		include xmmac.mac
		include	xmmsg.def
;
TraceNum	equ	10
ExeCodeSel	equ	0ch	;ExeData  - LDT + 4	;14
ExeDataSel	equ	14h	;ExeData  - LDT + 4	;14
;
		
_DATA		segment	para public USE16 'DATA'
		public	puttracereg, ty_debugger, copy_original
		extrn	comp_buffer:byte, orig_code:dword
		extrn	orig_size:word
		extrn	traceCount: word
		extrn	SavedESP:dword, ThisDataBase:dword
		extrn	SavedEax:dword
		extrn	SavedSS: word
		extrn	EData:sect, ECode:sect
		extrn	DebugFlag:word
		extrn	ErrorOffset:byte
		extrn	SavedOpCode: byte
_DATA		ends

		
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
		extrn	getcode:near
		extrn	osexit:near
		extrn	a20_on:near, a20_off:near

Ty_debugger	proc	near
		push	ds
		push	es
		push	cx
		push	si
		push	di
		lea	si, Comp_Buffer
		les	di, orig_code
		mov	cx, orig_size
		cld
	rep	cmpsw
		cmp	cx, 0
		jnz	deb_abort
		pop	di
		pop	si
		pop	cx
		pop	es
		pop	ds
		ret
deb_abort:
IF FMR70
		call	a20_off
ENDIF
		lea	edx, code_modifyed
		call	Msg
		movzx	eax, di
		call	Hex32s
		jmp	OSExit
		int	3
		ret
		endp
;
Copy_original	proc	near
		push	ds
		push	es
		push	cx
		push	si
		push	di
		mov	ax, _DATA
		mov	es, ax
		lea	di, Comp_Buffer
		mov	cx, orig_Size
		lds	si, orig_code
IF FMR70
		call	a20_on
ENDIF
		cld
	rep	movsw
IF FMR70
		call	a20_off
ENDIF
		pop	di
		pop	si
		pop	cx
		pop	es
		pop	ds
		ret
		endp

;;; **** INT ROUTINES **** ;;;;

Hex32R		proc	near
		xchg	al, ah
		rol	eax, 16
		xchg	al, ah
		jmp	Hex32
Hex32R		endp
;		
		public	PrintTrace
PrintTrace	proc	near
		call	CRLF

		mov	ax, SavedSS
		call	Hex

		mov	dx, offset ColonS
		call	Msg
		
		mov	eax, SavedESP
		call	Hex32

		mov	eax, SavedEAX
		call	Hex32S

;
; XM itself may be traped. In such case, SS contains different value.
;
		mov	ax, ss		; is stack mine ? or programs ?
		mov	bx, ds
		cmp	ax, bx
		jne	.trapEx1
.trapPx1:				; my own bug !!
		mov	dx, offset Asterisk
		call	Msg
		mov	ebx, SavedESP	;
		jmp	.trapx1
.trapEx1:		
		mov	ebx, SavedESP
		add	ebx, EData.Base
		sub	ebx, ThisDataBase
.trapx1:
		push	ebx			; esp phisycal address
		mov	dx, offset SpaceS
		call	Msg

		mov	ax, [ebx+6]		;ds
		call	Hex

		mov	dx, offset SpaceS
		call	Msg

		mov	ax, [ebx+4]		;es
		call	Hex

		movzx	esi, ErrorOffset
		or	esi, esi
		jz	NoErrCode

		mov	dx, offset SpaceS
		call	Msg

		mov	ax, [ebx+8]
		call	Hex			;error code

NoErrCode:	mov	dx, offset SpaceS
		call	Msg

		mov	ax, [ebx+esi+12]	;CS
		call	Hex

		mov	dx, offset ColonS
		call	Msg

		mov	eax, [ebx+esi+8]	;EIP
		call	Hex32

		mov	dx, offset SpaceS
		call	Msg

		mov	ax, [ebx+esi+12]	;cs
		cmp	ax, ExeCodeSel
		mov	ecx, [ebx+esi+8]	;pointer to code
		je	.progcs
.mycs:
		pop	ebx
		push	ebx
		push	eax
		push	ecx
		mov	eax, cs:[ecx]
		call	Hex32R
		pop	ecx
		mov	eax, cs:[ecx+4]
		call	Hex32R
		pop	eax
		pop	ebx
		jmp	.putCodeContents
.progcs:
		pop	ebx
		add	ecx, ECode.Base
		sub	ecx, ThisDataBase
		mov	eax, [ecx]
;
		push	edx
		call	getcode
;
		push	ebx
		push	eax
;
		push	edx		; pointer to nemonic

		push	ecx
		call	Hex32R
		pop	ecx
		mov	eax, [ecx+4]
		call	Hex32R
;
		call	PutSpace
		pop	edx		; pointer to nemonic
		call	Msg
;		
		pop	eax		;restore opcode (al keeps next OPcode)
		pop	ebx		;restore stack pointer
		pop	edx
.putCodeContents:
		ret
PrintTrace	endp



putTraceReg	proc	near
		push	bp
		mov	bp,sp
		pushad
		call	CRLF
		add	ebp, 4*8+4	; ebp -> user's eax
		mov	cx, 4
.putTr1:
		sub	bp, 4		; from eax 
		mov	eax, [bp]
		call	Hex32s
		loop	.putTr1
		call	PutSpace
		call	PutSpace
		sub	bp, 4		; skip esp
		mov	cx, 3
.putTr2:
		sub	bp, 4		; eax is already shown
		mov	eax, [bp]
		call	Hex32s
		loop	.putTr2
		popad
		pop	bp
		ret
putTraceReg	endp

;
; single step
;
		public	PrintCode
		public	Int1, Int3
Int1		proc	near
		push	ds
		pushad
		mov	ax, _DATA
		mov	ds, ax
TraceIt:
		mov	ErrorOffset, 0
		call	PrintTrace
		test	DebugFlag, MASK Deb_Trace_reg
		jz	.trace_01
		call	putTraceReg
;
; far call or interrupt is usually system call.
; so, we do not trace it.
;
.trace_01:
		cmp	al, 09ah			;far call?
		je	IsLCall
		cmp	al, 0cdh			; soft interrupt ?
		je	IsSoftInt
		cmp	word ptr[TraceCount],0
		jbe	TraceDone
		dec	word ptr[TraceCount]
		or	word ptr [ebx+16], 100h
		jmp	PrintCode

IsSoftInt:	
		and	word ptr [ebx+16], NOT 100h
		mov	al, byte ptr [ecx+2]
		mov	byte ptr [ecx+2], 0cch
		mov	SavedOpCode, al
		mov	eax, [ecx]			;???
		jmp	PrintCode
IsLCall:	
		and	word ptr [ebx+16], NOT 100h
		mov	al, byte ptr [ecx+7]
		mov	byte ptr [ecx+7], 0cch
		mov	SavedOpCode, al
		mov	eax, [ecx]			;???
		jmp	PrintCode
TraceAgain:
		mov	word ptr[TraceCount], TraceNum * 2
		jmp	.traceAgn
TraceAgain10:
		mov	word ptr[TraceCount],TraceNum 
.traceAgn:
		or	word ptr [ebx+16], 100h
		mov	al,2eh
		call	putchar
		jmp	PrintCode
TraceDone:	
		call	GetChar
		and	al, not 20h		; toupper(inkey)
		cmp	al, 'P'
		je	TraceAgain
		cmp	al, 0
		je	TraceAgain10
		cmp	al, 'R'
		jz	.TraceRg
		cmp	al, 'C'
		jz	.TraceCM
		cmp	al, 'D'
		je	.TraceDb
		jmp	.traceHalt
.Tracedb:
		call	Ty_debugger
		jmp	TraceDone
.TraceRg:		
		call	putTraceReg
		xor	DebugFlag, MASK Deb_Trace_reg
		jmp	TraceDone
.TraceCM:		
		xor	DebugFlag, MASK Sys_Out_Com
		jmp	TraceDone
.traceHalt:		
		call	CRLF
		and	word ptr [ebx+16], NOT 100h
PrintCode:
		popad
		pop	ds
		ret
;		iret
Int1		endp
;
; this routine will be re-written (probably by TC) soon.
;
;
;
Int3		proc	near
		push	ds
		pushad
		mov	ax, _DATA
		mov	ds, ax
		mov	ebx, SavedESP
		add	ebx, EData.Base
		sub	ebx, ThisDataBase
		mov	ecx, [ebx+8]	;pointer to code
		dec	ecx
		mov	[ebx+8], ecx
;
;	get original code (from table - in future)
;		
		mov	al, SavedOpCode
;
		add	ecx, ECode.Base
		sub	ecx, ThisDataBase
		cmp	byte ptr[ecx], 0cch	; is it really debug int ?
		jnz	TraceIt
		mov	[ecx], al
		jmp	TraceIt
Int3		endp

_TEXT		ends
		end	

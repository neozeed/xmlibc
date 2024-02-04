		.386

thiscodesel	=	18h
psp2sel		=	24h

		include	xmhd.inc
		include	xmmac.mac
		include	xmmsg.def
;
_DATA		segment	para public USE16 'DATA'
		extrn	EData:sect
		extrn	ThisSSESP: fword
		extrn	ThisDataBase: dword
		extrn	ThisCodeBase: dword
		
		extrn	EndCode:byte
		extrn	RMIDTLIMITBase: fword
		extrn	IDTLIMITBase: fword
		extrn	GDTLIMITBase: fword
		extrn	ExeCSEIP: fword
		extrn	exeeip: dword
		extrn	ExeCS : word
		extrn	savedssesp: fword
		extrn	Exessesp: fword
		extrn	exeesp: dword
		extrn	Exess : word
		extrn	debugflag: word

		public	TestPoint01,cindxs,cfwrite,cfread,cpsp
		public	TestPoint02
		ends
	
_TEXT		segment	para public USE16 'CODE'
		extrn	OSExit:near
		extrn	a20_on:near, a20_off:near
		extrn	Ty_Debugger:near
		ends
		
_DATA		segment	para public USE16 'DATA'

		public	DosCallP
;		DosFuncMax
		public	DosBuffer, DosWorkI, DosWorkO, Mywork
		public	comp_buffer, pspwork
		extrn	exeeax:dword, exeax:word, savedflags:dword

		public	DosLog
DosLog		dw	80h dup (0h)
SavedDS		dw	0
SavedES		dw	0

TransferedByte	dd	?
		
PSPWork		db	768  dup (0)
DosBuffer	label	byte
DosWorkI	db	dosbuffersize dup (0)
		org	dosworki+PageSize
DosWorkO	db	PageSize dup (26)
MyWork		db	512  dup (27)
Comp_Buffer	dw	256  dup (0)

; input: lower nibble, output: upper nibble
; register only = 0,  
; 1 = ds:dx, 2 = es:bx, 3 = es:di, 4 = ds:di
		align	dword
DosCallP	dw	DosExit		;.0
		dw	cnopa		;.1
		dw	cnop		;.2
		dw	cnopa		;i3
		dw	cnop		;.4
		dw	cnop		;.5
		dw	cnopa		;.6
		dw	cnopa		;.7
		dw	cnopa		;.8
		dw	cins		;.9
		dw	cigets		;.10	get line
		dw	cnopa		;.11	console status
		dw	cigets_c	;.12	flush and key in
		dw	cnop		;.13	disk reset
		dw	cnopa		;.14	change current drive
		dw	cabort		;.15	open file
		dw	cabort		;.16	close file
		dw	cabort		;.17	find first
		dw	cabort		;.18	find next
		dw	cabort		;.19	delete file
		dw	cabort		;.20	sequencial read 
		dw	cabort		;.21	sequencial write
		dw	cabort		;.22	create file
		dw	cabort		;.23(17)	rename
		dw	cabort		;.18h	??
		dw	cnopa		;.19h	get current drive
		dw	cabort		;.1ah	set dta
		dw	cabort		;.1bh 	get current drive data
		dw	cremain		;.1ch	get drive data
		dw	cabort		;.1dh
		dw	cabort		;.1eh
		dw	cabort		;.1f
		dw	cabort		;.20
		dw	cabort		;.21h	random read
		dw	cabort		;.22h	random write
		dw	cabort		;.23h	get file size
		dw	cabort		;.24h	set ralative record
		dw	cabort		;.25h	set vector
		dw	cabort		;.26h
		dw	cabort		;.27h  	random block read
		dw	cabort 		;.28h	random block write
		dw	cabort		;.29h 	parse file name
		dw	cnopr		;.2ah	get date
		dw	cnopa		;.2bh	set date
		dw	cnopr		;.2ch	get time
		dw	cnopa		;.2dh	set time
		dw	cnop		;.2eh	set/reset verify flag
		dw	cremain		;.2fh	get dta
		dw	cnopa		;.30h	dos version no
		dw	cabort		;.31h	kiip process (TSR)
		dw	cremain		;.32h
		dw	cnopr		;.33h	set/reset ctr-c check
		dw	cabort		;.34h	
		dw	cabort		;.35h	get int vector
		dw	cnopr		;.36h	get disk free space
		dw	cabort		;.37h
		dw	cremain		;.38h	country information
		dw	cindxs		;.39h	create directory  
		dw	cindxs		;.3ah	remove directory entry
		dw	cindxs		;.3bh	change directory          
		dw	cindxs		;.3ch	create a file 
		dw	cindxs		;.3dh	open a file
		dw	cnopa		;.3eh	close a file
		dw	cfread		;.3fh	file/device read 
		dw	cfwrite		;.40h	file/device write 
		dw	cindxs		;.41h	delete a directory entry
		dw	cnopr		;.42h	move file pointer
		dw	cindxs		;.43h	chmod
		dw	ciIOC 		;.44h	i/o control for device
		dw	cnop		;.45h	duplicate File handle
		dw	cnopr		;.46h	force duplicate of a handle
		dw	ccdir		;.47h	return text of directory
		dw	cabort		;.48h	allocate memory
		dw	cabort		;.49h	free allocated memory
		dw	cabort		;.4ah	modify/allocated memory block
		dw	cremain		;.4bh	load/exec
		dw	DosExit		;.4ch	terminate
		dw	cnopa		;.4dh	get return code from child
		dw	cremain		;.4eh	find first
		dw	cremain		;.4fh	find next
		dw	cremain		;.50h
		dw	cremain		;.51h
		dw	cremain		;.52h	??
		dw	cremain		;.53h	??
		dw	cnopa		;.54h	return verify flag
		dw	cabort		;.55h	??
		dw	crename		;.56h	rename
		dw	cnopr		;.57h	get/set tod
		dw	cabort		; 58h 	malloc strategy
		dw	cnopr		; 59h	get extended error code
		dw	ctempnam  	; 5ah	create temporal file
		dw	cindxs		; 5bh  	create file with check
		dw	cabort
		dw	cabort		; 5dh
		dw	cabort		; 5eh
		dw	cabort		; 5fh
		dw	cabort		; 60h
		dw	cabort		; 61h
		dw	cpsp		; 62h
		dw	cabort
		dw	cabort
;
;DosFuncMax	equ	($ - DosCallP) / 2

_DATA		ends
;
;
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
		public	DosFlush
		extrn	DosProtected
;
; int 21 from protected mode
; Hardware interrupt may occure while CPU executing this routine.
; So, we must not share save area with other interrupt handlers.
;

		.386P
DosFlush	proc	far
		mov	ax,_DATA
		mov	ds,ax		; communication buffer is 
		mov	es,ax		; also in this _DATA segment
		mov	fs,ax
		mov	gs,ax

		lss	esp, ThisSSESP
		lidt	RMIDTLimitBase
		mov	eax, ExeEAX
;
		pushad
		mov	bp,sp
		sti
		mov	ax,_DATA
		mov	fs,ax
		mov	gs,ax
;
; Show register information at dos call.
;
		test	DebugFlag, MASK Deb_Trace_dos
		jz	.do_dos1
		push	ecx
		push	edx
		push	esi
		push	edi
		call	CRLF
		lea	si, 8*4[bp]
		mov	cx, 8
.show_reg:		
		lea	si, -4[si]
		mov	eax, ss:dword ptr[si]
		call	Hex32S			; Edi,esi,ebp,esp
						; ebx,edx,ecx,eax
		loop	.show_reg
		
		push	es
		les	eax, ExeCSEIP
		call	PutPointer
		pop	es
;		
		pop	edi
		pop	esi
		pop	edx
		pop	ecx
.do_dos1:
;
;  call debugger at dos call.
;  convention is  ty_debugger(eip, esp, edi, esi, ebp, xxx, ebx, edx, ecx, eax)
;  where 
;
		test	DebugFlag,MASK Deb_Trap_Dos
		jz	.do_dos2
		push	dword ptr ExeESP
		push	dword ptr ExeEIP
		call	Ty_debugger
		add	sp,8
.do_dos2:
;
		.386
TestPoint02	proc	near
IF FMR70
		call	a20_off
ENDIF
		mov	ax, [ExeAX]
		cmp	ah, DosFuncMax
		jae	DosExit
		movzx	ebx, ah
		push	offset .do_dos_ret
		inc	DosLog[ebx*2]
		push	DosCallP[ebx*2]
IF FMR70		
		call	a20_on
ENDIF
		mov	ah, byte ptr[SavedFlags]
		sahf
		movzx	ebx, [bp].rbx
		mov	eax, ExeEAX
		endp
TestPoint01	proc	near 			; assure this 'ret' is
		ret				; near-return
		endp
;
.do_dos_ret	proc	near
IF TransPort
IF FMR70	
		call	a20_off
		nop
		call	a20_on
ENDIF
ENDIF
;		mov	fs:[TempDS], ds
;		mov	fs:[TempES], es
;
; show register at dos-exit
;
		test	DebugFlag, MASK Deb_Trace_dos
		jz	.do_dos_ret1
		mov	al,'-'
		call	putchar
		mov	eax, ExeEAX
		call	Hex32S
		mov	eax, [bp].recx
		call	Hex32S
		mov	eax, [bp].redx
		call	Hex32S
		mov	eax, [bp].rebx
		call	Hex32S
		mov	al, byte ptr SavedFlags
		call	HexALS
		
.do_dos_ret1:
		.386P
		mov	sp, bp
		popad
;
; return to protected mode 
;
		cli
		lidt	fs:[IDTLimitBase]
		lgdt	fs:[GDTLimitBase]
		mov	eax, CR0
		or	al, ONCR0
		and	al, OFFCR0
		mov	CR0, eax
		fjmp	ThisCodeSel, DosProtected
		endp
;
;
; Dos (int 21h) handling routines
;
		.386
dosfunc		label	near
cnop		proc	near		
cnopa:
		mov	ax, [bp].rax
		mov	cx, [bp].rcx
		mov	bx, [bp].rbx
		mov	dx, [bp].rdx
IF FMR70
		call	a20_off
ENDIF
		int	21h
		mov	ExeEAX,eax
		lahf
		mov	byte ptr SavedFlags, ah
IF FMR70
		call	a20_on
ENDIF
		ret
cnopr:		
IF FMR70
		call	a20_off
ENDIF		
		mov	ax,[bp].rax
		mov	bx,[bp].rbx
		int	21h
		mov	[bp].rcx, cx
		mov	[bp].rdx, dx
		mov	[bp].rbx, bx
		mov	[bp].rsi, si
		mov	[bp].rdi, di
		movzx	eax,ax
		mov	ExeEAX,eax
		lahf
		mov	byte ptr SavedFlags, ah
IF FMR70
		call	a20_on
ENDIF
		ret
		endp

cremain:				; We'll support it in feature, 


cabort:
;
C_Exit:
		sti
		call	CRLF
		mov	eax, ExeEAX
		cmp	ah, 4ch
		je	C_normalx
		cmp	ah, 0
		je	C_normalx
		call	Hex32s
;		
		lea	edx, FuncNotAvail
		call	Msg
		les	eax, ExeCSEIP
		call	PutPointer
		les	eax, SavedSSESP
		call	PutPointer
		call	CRLF
		lea	edx, RegS
		call	Msg
		mov	eax, [bp].reax
		call	Hex32s
		mov	eax, [bp].recx
		call	Hex32s
		mov	eax, [bp].redx
		call	Hex32s
		mov	eax, [bp].rebx
		call	Hex32s
		mov	eax, [bp].resp
		call	Hex32s
		mov	eax, [bp].rebp
		call	Hex32s
		mov	eax, [bp].resi
		call	Hex32s
		mov	eax, [bp].redi
		call	Hex32s
		mov	ax, SavedDS
		call	HexS
		mov	ax, SavedES
		call	HexS
		call	CRLF
		mov	al,99			; my error code
		jmp	C_done
		endp
;
		public	dosexit
DosExit		proc	near
C_normalx:
		push	ax
		lea	edx, FileName
		call	Msg
		lea	edx, ExitMsg
		call	Msg
		pop	ax
		mov	EndCode, al
		call	Hex
		call	CRLF
C_done:		
		.386P
		mov	eax, CR0
		xor	ax, ax
		jmp	OSExit
		endp
;		
;
		.386
		public	putpointer
PutPointer	proc	near
		push	eax
		mov	ax, es
		call	HexS
		lea	dx, ColonS
		call	Msg
		pop	eax
		call	Hex32
		ret
		endp
;		
		align	dword
;
; copy string ds:dx to internal buffer  (_data:DosWorki)
;
c_strlen	proc	near
		cld
		mov	ecx, MaxTransfer 	;
		prefix32
	repnz	scasb	
		neg	ecx
		add	ecx, MaxTransfer + 1
		ret
		endp


cins		proc	near
		mov	al,'$'
		jmp	.cinz
cindxs		label	near
		mov	al,0
.cinz		label	near
		mov	edi,[bp].redx
		add	edi,Edata.Base
		sub	edi,ThisDataBase
		push	edi
		call	c_strlen
		pop	esi
		mov	edi,offset DosWorkI
		add	cx, 2
		prefix32
	rep	movsb
		mov	di, [bp].rdi
		mov	si, [bp].rsi
		mov	cx, [bp].rcx
IF FMR70
		call	a20_off
ENDIF		
		mov	dx, offset DosWorkI
		mov	ax, [bp].rax
		int	21h
		movzx	eax, ax
		mov	ExeEAX, eax
		lahf
		mov	byte ptr SavedFlags, ah
		mov	[bp].rcx, cx
		mov	[bp].rbx, bx
IF  FMR70
		call	a20_on
ENDIF
		ret
		endp
cinPrse:
		jmp	cabort
;	
cigets		proc	near
		mov	edx, [bp].redx
		add	edx, [EData.Base]
		sub	edx, [ThisDataBase]
		
		push	ax
		mov	al, [edx]
		mov	DosWorki[0], al
		pop	ax
		
IF FMR70
		call	a20_off
ENDIF
		push	edx
		mov	edx, offset Dosworki
		mov	EAX, ExeEAX
		int	21h
		mov	esi, edx
		pop	edi
IF FMR70
		call	a20_on
ENDIF
		movzx	ecx, byte ptr[esi]
		add	cx, 2
		cld
		Prefix32
	rep	movsb
		ret
		endp

cigets_c	proc	near
;		mov	eax, [ExeEAX]
		cmp	al, 0ah
		je	cigets
IF  FMR70
		call	a20_off
ENDIF		
		int	21h
		mov	ExeEAX, eax
IF FMR70
		call	a20_on
ENDIF
		ret
		endp

;
;
; call Real-Mode child process
;
;cexec:
;		ret



;
; ds:dx is pointer to output buffer
; so, set it to _data:DosWorkO
;
; file read (function 3fh)
;
cfread		proc	near
		add	edx, EData.base
		sub	edx, ThisDataBase
		mov	edi, edx
		mov	TransferedByte, 0
.cfr1:		
		jcxz	.cfrxe
		
		push	ecx
		cmp	ecx, DosBufferSize
		jbe	.cfr2
		mov	cx, DosBufferSize
.cfr2:		
		push	edi
		mov	bx, [bp].rbx
		mov	dx, offset DosBuffer
IF FMR70
		call	a20_off
ENDIF
		mov	ax, [bp].rax
		int	21h
		pop	edi
IF FMR70
		call	a20_on
ENDIF
		jc	.cfrxer
		
		movzx	eax, ax
		add	TransferedByte, eax
		mov	ecx, eax
		jcxz	.cfrxe1
		
		mov	esi, offset DosBuffer
		cld	
		prefix32
	rep	movsb	
		pop	ecx
		
		sub	ecx, eax
		ja	.cfr1
.cfrxe:
		and	byte ptr SavedFlags, not 1
		mov	eax, TransferedByte
		mov	ExeEAX, eax
		ret
.cfrxe1:
		pop	ecx
		jmp	.cfrxe
.cfrxer:
		pop	ecx
		or	byte ptr SavedFlags, 1
		ret
		endp
;
; only function 47h call 'ccdir'.
;  so, transfer data is always 64 byte.
;
;cisip:
ccdir:
		mov	esi,offset DosWorkO	
		int	21h
		mov	ExeEax, eax
		lahf
		mov	byte ptr SavedFlags, ah
		jc	.ccdirx
		mov	esi, offset DosWorkO
		mov	edi, [bp].resi
		add	edi, EData.Base
		sub	edi, ThisDataBase
		mov	cx, 64 / 4
		cld
	rep	movsd
.ccdirx:
		ret
;
; 	c_input_dx_data
; ds:dx contains input data
; ecx contains length
;
cfwrite		proc	near
		mov	esi, [bp].redx
		add	esi, EData.Base
		sub	esi, ThisDataBase
		xor	eax, eax
		mov	ExeEAX, eax	; transfered bytes
		mov	bx, [bp].rBX		; handle
		mov	ecx, [bp].rECX		; bytes
		cld
.cfw1:
		jcxz	.cfw3
		push	ecx
		cmp	ecx, DosBufferSize
		jbe	.cfw2
		mov	ecx, DosBufferSize
.cfw2:
		push	ecx
		mov	edi, offset DosBuffer
		mov	dx, di
		prefix32
	rep	movsb	
		pop	ecx

IF FMR70
		call	a20_off
ENDIF		
		mov	ax, [bp].rax
		int	21h
		pop	ecx
IF FMR70
		call	a20_on
ENDIF
		jc	.cfwxerr
		movzx	eax, ax
		add	ExeEax, eax
		
		sub	ecx, eax
		ja	.cfw1
.cfw3:
		and	byte ptr SavedFlags, not 1
		ret
.cfwxerr:
		or	byte ptr SavedFlags, 1
		ret
		endp
;
ctempnam:
		mov	esi, [bp].redx
		add	esi, EData.Base
		sub	esi, ThisDataBase
		push	esi

		mov	al, 0
; length of input string		-- should be subroutined
		mov	edi, esi
		mov	ecx, 200
		prefix32
	rep	scasb
		sub	ecx, 200
		neg	ecx
		inc	ecx
		
		push	ecx
		mov	edi, offset DosWorkI	; copy string int my buffer
		cld
		prefix32
	rep	movsb
IF FMR70
		call	a20_off
ENDIF		
		mov	ecx, [bp].recx		; issue system call
		int	21h
		mov	ExeEax, eax
IF FMR70
		call	a20_on
ENDIF
		jc	.ctempx
		pop	ecx			; remember input string length
;
		add	ecx, 13			; add tempname field
		pop	edi			; string buffer of exp
		mov	esi, offset DosWorkI
		cld
		prefix32			; copy answer
	rep	movsb
.ctempx:
		ret
		endp

;
; rename function
; ds:dx --> current path name
; es:di --> new path name
;	path name should shorter than 2+64+13 bytes !
crename		proc	near
;ci_ren:
		mov	esi,[bp].rEDI
		add	esi,[EData.Base]
		sub	esi,[ThisDataBase]
		cld
		mov	ecx, 128/4		; temporal value
		mov	edi, offset DosWorkI + 256
		prefix32
	rep	movsd	
		
		mov	esi,[bp].redx
		add	esi, EData.Base
		sub	esi, ThisDataBase
		cld
		mov	ecx, 128/4
		mov	edi, offset DosWorkI
		prefix32
	rep	movsd
		
		mov	dx, offset DosWorkI + 0
		mov	di, offset DosWorkI + 256
IF  FMR70
		call	a20_off
ENDIF		
		mov	eax, [bp].rEAX
		int	21h
		mov	ExeEAX, eax
		lahf	
		mov	byte ptr SavedFlags, ah
IF FMR70
		call	a20_on
ENDIF
		ret
		endp
;
cpsp		proc	near
		mov	[bp].rebx, PSP2Sel
		ret
		endp

;
; specially for I/O control 
; copy data in DosWorkI to ds:dx (cx bytes)
;
ciIOC		proc	near
		mov	ax,[bp].rax
		cmp	al,0
		je	cnopr
		cmp	al,1
		je	cnopr
		cmp	al,2
		je	cfread		; read cx bytes into ds:edx
		cmp	al,3
		je	cfwrite		; write cx bytes from ds:edx
		cmp	al,4
		je	cfread
		cmp	al,5
		je	cfwrite
		cmp	al,7		;6,7 get information
		jbe	cnopa		;
		cmp	al,8
		je	cnopa
		cmp	al,10
		jbe	cnopr		;9,10
		cmp	al,11
		je	cnopr
		jmp	cabort
		endp

_TEXT		ends
		end	

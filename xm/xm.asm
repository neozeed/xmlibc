; modify on ss:sp 
;
		.386
		%NOINCL
		page	85,132	

		include	xmhd.inc
		include xmmsg.def
		include	xmmac.mac
		
_DATA		segment	para public USE16 'DATA'
		extrn	DosCallP: word

		public	debugflag
		public	Param
;
		ends

_TEXT		segment	para public USE16 'CODE'
		
		public	ToProtection,Gate
		public	orig_code, orig_size
		extrn	PrintTrace:near
		extrn	retos:near
		extrn	DosExit:near
		extrn	putpointer:near
		
		extrn	Ty_Debugger:near
		extrn	puttracereg:near
		extrn	copy_original:near
		
		extrn	a20_off:near, a20_on:near
		extrn	OSExit:near
_TEXT		ends

_STACK		segment	para STACK USE16 'STACK'
StackSize	equ	512
		db	StackSize dup (?)
_STACK		ends

COMMUNICATION	segment	para public USE16 'DATA'
		public	ToDosDS, ToDosES, FromDosDS, FromDosES
ToDosDS		dw	?
ToDosES		dw	?
FromDosDS	dw	?
FromDosES	dw	?
CommLimit	equ	7
COMMUNICATION	ends

_DATA		segment	para public USE16 'DATA'

		extrn	Handle: word
;
;
; debug information
;
;
DebugFlag	dflag	<TraceReg, TrapDOS, TraceDOS, MsgToCom> 
		
		db	0,0
		public	traceCount
TraceCount	dw	0
		even
orig_code	label	dword
		dw	1800h
		dw	-1
orig_size	dw	256

;
;
Control387	dw	?

		public	exessesp, exeesp, exess
ExeSSESP	label	fword
ExeESP		dd	60 * 1024		;STACK_HI
ExeSS		dw	ExeDataSel,0

		public	savedcseip, savedeip, savedcs
SavedCSEIP	label	fword
SavedEIP	dd	0
SavedCS		dw	0,0

		public	savedssesp, savedesp, savedss
SavedSSESP	label	fword
SavedESP	dd	0
SavedSS		dw	0,0

		public	stack_log
		align	dword
stack_log	dd	60h dup (3a3a3ah)
		
		public	gateeax 
GateEAX		dd	?
		
		public	gatessesp, gateesp, gatess
GateSSESP	label	fword
GateESP		dd	?
GateSS		dw	0,0
		
		public	gateCarry
GateCarry	label	byte
		dw	0,0

SavedIntN	dw	0

		align	dword
		public	savedflags
SavedFlags	label	dword
SavedFlag_lo	dw	?
		dw	?
		
		public	savedeax, savedax
SavedEAX	label	dword
SavedAX  	dw	?
		dw	?
SavedEBX	dd	?
SavedECX	dd	?
SavedESI	dd	?
SavedEBP	dd	?
TempEBX		dd	?
TempDS		dw	?
TempES		dw	?
DosFuncNo	dw	?
DosCallNo	dw	?

		public	exeeax, exeax
ExeEAX		label	dword
ExeAX		dw	?
		dw	?
		
		public	execseip, exeeip, execs
		align	dword
ExeCSEIP	label	fword
ExeEIP		dd	?
ExeCS		dw	?

		public	thisssesp, thissp, thisss
		align	dword
ThisSSESP	label	fword
ThisSP		dw	?
		dw	0
ThisSS		dw	?

		align	8
;
;type of AccessRights = p,dpl,1,typ,a	or p,dpl,0,type
ar_data		equ	10010010b
ar_code		equ	10011010b
ar_stk		equ	10010110b
;
DPL0		equ	00000000b
DPL1		equ	00100000b
DPL2		equ	01000000b
DPL3		equ	01100000b
;	
;type of Granularity  = g,x,0,avl,limit19-16
;	
gr_16		equ	10000000b	; G=1, default 16 bit (286 compatible)
gr_16s		equ	00000000b	; G=0, default 16 bit (286 compatible)
gr_32		equ	11000000b	; G=1, default 32 bit
gr_32s		equ	01000000b	; G=0, default 32 bit
;
;			<lim0-15,bs0-15,bs16-23,ar,gr,bs24-31>
;
;	grobal segment
;
		align	dword
GDT		label	byte		;global descriptor table starts here
NULL		Desc	<>		;Null descriptor
ProgCode	Desc	<0ffffh,,,ar_code,gr_32,0> ;code descriptor
ProgData	Desc	<0ffffh,,,ar_data,gr_32,0> ;data descriptor
ThisCode	Desc	<0ffffh,,,ar_code,gr_16+15,>	;.code
ThisData	Desc	<0ffffh,,,ar_data,gr_16+15,>	;.data
CommData	Desc	<0ffffh,,,ar_data,00000000b,> 	;communication
LDTDesc		Desc	<LDTLimit,,,82h,,>		;selector to LDT
GDTDesc		Desc	<GDTLimit,,,82h,,>		;selector to GDT
FlatData	Desc	<0ffffh,0,0,ar_data,gr_32,0> 	;flat 256MB data
GDT_END		label	byte
GDTLimit	equ	GDT_END - GDT -1

NULLSelector	equ	0		;0
ProgCSel	equ	ProgCode - GDT	;+ 7
ProgDsel	equ	ProgData - GDT 	;+ 7
ThisCodeSel	equ	ThisCode - GDT	;18h
ThisDataSel	equ	ThisData - GDT	;20h
CommDataSel	equ	CommData - GDT	;28h
LDTSel		equ	LDTDesc  - GDT	;30h
GDTSel		equ	GDTDesc	 - GDT  ;38h
FlatDataSel	equ	FlatData - GDT	;40h

;
; local segment
; for the compatibility to Phar Lap's
;
;			<lim0-15,bs0-15,bs16-23,ar,gr,bs24-31>
;
		align	dword
LDT		label	byte		;local descriptor table starts here
CallGate	Desc	<Gate,ThisCodeSel,0,0ech,0,0>	;gate to proc Gate
ExeCode		Desc	<0ffffh,,,ar_code,gr_32,> ;code descriptor
ExeData		Desc	<0ffffh,,,ar_data,gr_32,> ;data descriptor
LSEG_VRAM	Desc	<256/4,0,0ah,ar_data,gr_32,0> 	; Video RAM
LSEG_PSP2	Desc	< 512,,,ar_data,gr_32s,0>	; PSP for user program
LSEG_ENV	Desc	<4096,,,ar_data,gr_32s,0>	; Environment
LSEG_LOWMEM	Desc	<1024/4,0,0,ar_data,gr_32,0>	; LowMemory (limit=1MB)
LDT_END		label	byte
;
LDTLimit	equ	LDT_END -LDT -1

GateSel		equ	CallGate - LDT + 4	;first entry in LDT, RPL 3
ExeCodeSel	equ	ExeCode  - LDT + 4	;c
ExeDataSel	equ	ExeData  - LDT + 4	;14
VramSel		equ	LSEG_VRAM - LDT + 4	;1c
PSP2Sel		equ	LSEG_PSP2 - LDT + 4	;24
ENVSel		equ	LSEG_ENV  - LDT + 4	;2c
LowMemSel	equ	LSEG_LowMem-LDT + 4	;34

		%NOMACS
		align	8
IDT		label	byte

IntDesc		macro	n
		dw	Intr&n		;;offset 0 15
		dw	ThisCodeSel	;;selector
		db	0		;;word count
		db	10001110b	;;gate type
		dw	0		;;offset 16 31
		endm

x		=	0
		rept	256
		IntDesc	%x
x		=	x+1
		endm

		align	dword
;FlushPtr	label	dword
;		dw	Flush
;		dw	_TEXT

ProtectedPtr	label	dword
		dw	Protected
		dw	ThisCodeSel

		public	gdtlimitbase, idtlimitbase
GDTLimitBase	label	fword
		dw	GDTLimit
GDTBase		dd	?
		

IDTLimitBase	label	fword
		dw	256*8-1
IDTBase		dd	?

		public	rmidtlimitbase 
RMIDTLimitBase	label	fword
		dw	256*4-1
		dd	0

LDTBase		dd	?

		public	EData, EBSS
		public	ECode
;		public	Parm

EData		sect	<,,>	;1
EBSS		sect	<,,>	;0
ECode		sect	<,,>	;1
ProgENV		sect	<,,>	;0
ProgPSP		sect	<,,>	;0

		public	thiscodebase, thisdatabase, commdatabase
ThisCodeBase	dd	?
ThisDataBase	dd	?
CommDataBase	dd	?
BrkVal		dd	?
NextTime	dd	?

Param		dd	8 dup (?) ; max 8 params
ArgP		dd	?
PSP		dw	?		; My PSP segment
EnvSeg		dw	?		; My ENV segment
ArgLen		db	?



		public	SavedOpCode
SavedOpCode	db	90h		; nop instruction for default
		public	ErrorOffset
ErrorOffset	db	?



; input: lower nibble, output: upper nibble
; register only = 0,  
; 1 = ds:dx, 2 = es:bx, 3 = es:di, 4 = ds:di
;
;	end of dos functions
;
		include	termio.inc
		include	stat.inc

;cons_tio	termio	<1805h,01bdh,003bh,00000h,00h,7fh,1ch,08h,40h,04h,0,0,0>
;file_tio	termio	<0000h,0000h,0000h,0ffffh,00h,00h,00h,00h,00h,00h,0,0,0>

		include	exp.inc
		
		extrn	fhdr:filehdr

		extrn	pspwork:byte, DosBuffer:byte
		extrn	DosworkI:byte, Dosworko:byte
		extrn	Mywork:byte, comp_buffer:byte

_DATA		ends

_TEXT		segment	para public USE16 'CODE'
		assume	cs: _TEXT, ds: _DATA


EntryPointer	label	fword
EntryEIP	dd	?
EntrySel	dw	ExeCodeSel

; stack frame:	0	gs
;		2	fs
;		4	es
;		8	ds
;		10	ret-offset
;		14	ret-segment
;		16	ret-offset to caller of system library
;		20	parameters...


		.386P
Gate		proc	far
		iret
		cli
		endp

		extrn	ReadFOHdr:near, ReadSHdr:near
		extrn	OpenExe:near
;
;
; Silly design on BIOS, used INTEL reserved interrupt. 
; 
;
		.386
IF PCAT
		%out	" This is PC/AT version "
IRC1		= 020h
IRC2		= 0a0h
		public	P8259
P8259		proc	near
		pushf
		cli
		outb	IRC1, 11h
		outbd	IRC1+1, ah
		outbd	IRC1+1, 4
		outbd	IRC1+1, 1
		outbd	IRC1+1, 00h
		outbd	IRC1, 20h
comment %
;  IRC 2
		outb	IRC2 + 0, 11h
		outbd	IRC2 + 1, ah
		outbd	IRC2 + 1, 4
		outbd	IRC2 + 1, 1
		outbd	IRC2 + 1, 00h
		outbd	IRC2 + 0, 20h
;
%
;
		popf
		ret
P8259		endp
ENDIF

		.386
		extrn	CopyVectors:near	
SetDescriptor	proc	near
; bx descriptor
; eax base
; ecx limit
		mov	[bx].Base_0_15, ax
		shr	eax, 16
		mov	[bx].Base_16_23, al
		mov	[bx].Base_24_31, ah
		cmp	ecx, 0fffffh	;greater than 1 MB?
		jbe	LimOK
		shr	ecx, PAGESHIFT	;size in pages
		or	ecx, 800000h	;set Granularity bit to 1
LimOK:		mov	[bx].Limit_0_15, cx
		shr	ecx, 16
		mov	al, [bx].Granularity
		and	al, NOT 8fh
		or	al, cl
		mov	[bx].Granularity, al
		ret
SetDescriptor	endp

SetDesc		macro	b, a, c
		mov	bx, offset b
		mov	eax, a
		mov	ecx, c
		call	SetDescriptor
		endm

		extrn	setenvp:near
		public	PushToExeStack

PushToExeStack	proc	near
IF FMR70
		call	a20_on
ENDIF
		mov	edi, ExeESP
		sub	edi, 4
		mov	ExeESP, edi
		add	edi, EData.Base
		sub	edi, ThisDataBase
		mov	[edi], eax
		ret
PushToExeStack	endp

SetArgP		proc	near
		movzx	ecx, ArgLen
		mov	edi, ArgP
		mov	ebx, EData.Base
		sub	ebx, ThisDataBase
		sub	esi, esi	;argc
		sub	eax, eax	;separator & NULL
		dec	edi
MoreArgs:
		jcxz	PushToExeStack	;eax==0 to stack
SkipZeros:	inc	edi
		prefix32
		cmp	byte ptr [edi][ebx], 0
		loope	SkipZeros	;eax==0 to stack
		jcxz	PushToExeStack
		push	edi		;remember the vaddr beginning
		inc	esi		;++argc
SkipArg:	inc	edi
		prefix32
		cmp	byte ptr [edi][ebx], 0
		loopne	SkipArg
		call	MoreArgs
		pop	eax		;restore the argument pointer
		jmp	PushToExeStack	;push it
		endp
;
;
cpu_setup32	proc	near
		mov	ax, _DATA
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax
		cwde	
		shl	eax, 4
		SetDesc	ThisData, eax, 0ffffffffh
		jmp	cpu_setup
		endp

cpu_setup16	proc	near
		mov	ax, _DATA
		mov	ds, ax
		mov	es, ax
		mov	ThisData.Granularity, 0	; G=0, default = 16bit
		mov	ThisData.Limit_0_15, 0ffffh
		jmp	cpu_setup
		endp


		.386P
cpu_setup	proc	near
		mov	ax, _DATA
		cwde
		shl	eax, 4
		add	eax, offset GDT
		mov	GDTBase, eax
		cli
		lgdt	GDTLimitBase		;global descriptor table

		mov	eax, CR0
		or	al, 11h			; keep ET bit as it is
		and	al, NOT 0eh
		mov	CR0, eax		;protection on
		jmp	$+2
		nop
		nop
		mov	ax, ThisDataSel		;select ThisData
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax

		mov	eax, CR0
		and	al, NOT 1
		mov	CR0, eax		;enter REAL mode

		db	0eah			;far jump to Flush
		dw	__Flush
		dw	_TEXT
__Flush:
		mov	ax, _DATA		;all segments to .data
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax
		xor	eax,eax
		mov	edx, eax
		mov	ebx, eax
		mov	ecx, eax
		ret
		endp
		
		.386
		extrn	memoryconfig:near
		extrn	memscan:near, memmax:near

.HimemInvalid	label	near
		push	ds
		mov	ax, _DATA
		mov	ds, ax
		mov	dx, offset MemValidQ
		call	Msg
		call	getchar
		and	al, 1101111B
		cmp	al, 'Y'
		pop	ds
		
		je	.HimemValid
IF FMR70		
		call	a20_off
ENDIF
		mov	ax, 4c02h
		int	21h
;
IF FMR70
		.386P
SetCPU		proc	near
		mov	ax, _DATA
		mov	ds, ax
		mov	es, ax

		or	ThisCode.Granularity, 8fh
		or	ThisData.Granularity, 8fh

		cwde			;base for GDT
		shl	eax, 4
		add	eax, offset GDT
		mov	GDTBase, eax

		mov	ax, cs		;.code
		shl	ax, 4
		mov	ThisCode.Base_0_15, ax
		mov	ax, cs
		shr	ax, 12
		mov	ThisCode.Base_16_23, al

		mov	ax, ds		;.data
		shl	ax, 4
		mov	ThisData.Base_0_15, ax
		mov	ax, ds
		shr	ax, 12
		mov	ThisData.Base_16_23, al

		cli
		lgdt	GDTLimitBase		;global descriptor table

		mov	eax, CR0
		or	al, 11h
		and	al, NOT 0eh
		mov	CR0, eax		;protection on
		fjmp	ThisCodeSel, set_prot
set_prot:
		mov	ax, ThisDataSel		;select ThisData
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax

		mov	eax, CR0
		and	al, NOT 1
		mov	CR0, eax		;enter REAL mode

		fjmp	_TEXT, set_flush
		.386
set_Flush:
		mov	ax, _DATA		;all segments to .data
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax
		ret
		endp
ENDIF

.Nomemory	proc	near
		mov	ax, 4c09h
		int	21h
		endp
;
;	Main entry
;
Start		proc	near
		push	ds
		
IF FMR70
		call	setCPU
ENDIF
		call	a20_on
IF PCAT
		call	cpu_setup32
ENDIF
		call	MemoryConfig
IF FMR70
		call	a20_off
ENDIF
		pop	ds
		mov	ax, ds
		mov	es, ax
		jc	.HimemInvalid
.initCOM:
IF  PCAT
		mov	ah, 0
		mov	dx, CommPort  		; use com0:
		mov	al, 11100011b		; 9600bps,nop,1stop,8bit
		int	14h
ENDIF
IF  FMR70
ENDIF
.HimemValid:		
		mov	bx, 80h
		mov	byte ptr [bx][7fh], ' '
		movzx	cx, byte ptr[bx]
		inc	cx
		push	cx
		cmp	cx, 1
		ja	SpaceThem
		mov	ax, _DATA
		mov	ds, ax
		jmp	.no_parm
SpaceThem:
		inc	bx			;81h
		cmp	byte ptr [bx], ' '
		ja	IsChar
		mov	byte ptr [bx], ' '
IsChar:		loop	SpaceThem
		pop	ax
		push	ax
		
		mov	cx, 07fh
		sub	cx, ax
ZeroThem:
		mov	byte ptr[bx], ' '
		inc	bx
		loop	ZeroThem
		
		pop	cx
		push	cx

		cmp	cx, MAXFILENAME
		jbe	NameLenOK
		mov	cx, MAXFILENAME
NameLenOK:
		mov	di, 81h
		mov	al, ' '
	repe	scasb

		mov	ax, _DATA
		mov	es, ax
		mov	es: PSP, ds
		pop	ax
		mov	es: ArgLen, al
		
		lea	si, [di-1]
		mov	di, offset FileName
;
.copyPname:
		movsb	
		cmp	byte ptr[si], ' '
		loopne	.copyPname
		mov	al, 0
		stosb
;
;  copy param into psp-work. 7-17
;
		push	di
		push	si
		
		lea	di, PSPwork[129]
		mov	cx, 128
	rep	movsb
		lea	di, PSPwork
		mov	cx, 129
		mov	si, 0
	rep	movsb
		pop	si
		pop	di
;
		mov	ax, es
		mov	ds, ax

IF	Testing
		mov	dx, offset HelloS
		call	Msg
ENDIF
;
; Store my (=this program) own environment.
;
		mov	ThisSS, ss
		mov	ThisSP, sp

		mov	ax, cs		;.code
		cwde
		shl	eax, 4
		mov	ThisCodeBase, eax

		mov	ax, ds		;.data
		cwde
		shl	eax, 4
		mov	ThisDataBase, eax
;
; Store/setup program's environment
;
;
		mov	eax, MEM_LO
		mov	ECode.Base, eax
		mov	EData.Base, eax
		mov	EBSS.Base, eax
		mov	ECode.Lo, 0
		mov	EData.Lo, 0
		mov	EBSS.Lo,  0
		mov	esi, eax
		call	MemMax
IF FMR70
		call	a20_off
ENDIF		
		push	esi
		sub	esi, ECode.Base
		mov	ECode.Hi, esi
		pop	esi
		
		sub	esi, EData.Base
		mov	EData.Hi, esi
		mov	EBSS.Hi,  esi
;		
		sub	esi, PageSize - 3
		and	esi, not 3
		mov	ExeESP, esi
;90-7-8
		mov	ax, ds
		movzx	eax, ax
		shl	eax, 4
		add	eax, (offset PSPwork) 
		mov	ProgPSP.Base, eax
;
;  setup EnvSeg and contents of psp  
;
		push	ds
		mov	ax, _DATA
		mov	es, ax
		lea	di, PSPwork
		mov	ds, es: PSP		; my PSP segment
		mov	si, psp_envseg		; my ENV segment
		mov	si, [si]
		mov	es:EnvSeg, si
		pop	ds

;
; setup param field
;
		mov	si, offset PSPwork + 128
		lodsb
		movzx	cx, al
;
; Store/setup  PSP
;		
		movzx	eax, EnvSeg
		shl	eax, 4
		mov	ProgEnv.Base, eax
		mov	ProgEnv.Hi, 2048		; Temporal patch

;		call	CopyArg

;
; Set up parameter to program
;
		or	esi, esi	;argc
		jnz	SaveArgc
.no_parm:
		mov	dx, offset UsageS
		call	Msg			;
		jmp	OSExit			; <-- We need OsExit function

SaveArgc:
		xchg	eax, esi
IF FMR70
		call	a20_on
ENDIF
		call	PushToExeStack		;push argc
		call	OpenExe
		call	ReadFOHdr
		call	ReadSHdr
IF FMR70
		call	a20_off
ENDIF		
		public	TP_load
TP_load		label	near
		mov	ax, _DATA
		mov	ds, ax

;
; clear BSS
;		
		mov	edi, EBSS.Lo
		add	edi, EBSS.Base
		sub	edi, ThisDataBase
;		mov	ecx, ahdr.bsize
		movzx	ecx, fhdr.f_minalloc
		shl	ecx, 12
IF FMR70
		call	a20_on
ENDIF
		mov	al, 0
		prefix32		;32-bit addrs
	rep	stosb			;zero bss

IF FMR70
		call	a20_off
ENDIF
		mov	ax, ds		;base for GDT
		cwde
		shl	eax, 4
		add	eax, offset GDT
		mov	GDTBase, eax

		mov	ax, ds		;base for IDT
		cwde
		shl	eax, 4
		add	eax, offset IDT
		mov	IDTBase, eax

		mov	ax, ds		;base for LDT
		cwde
		shl	eax, 4
		add	eax, offset LDT
		mov	LDTBase, eax

		mov	eax, COMMUNICATION ;base for communication
		shl	eax, 4
		mov	CommDataBase, eax

		SetDesc	LDTDesc,  LDTBase, LDTLimit
		SetDesc	GDTDesc,  GDTBase, GDTLimit
		SetDesc	ExeCode,  ECode.Base, ECode.Hi
		SetDesc	ExeData,  EData.Base, EData.Hi
		SetDesc	ThisCode, ThisCodeBase, 0fffffh
;
; we use ThisData to access both thisdata and ExeData,
; so, it's limit must be enogh (very large) value.
;
		SetDesc	ThisData, ThisDataBase, 0ffffffffh
		SetDesc	CommData, CommDataBase, CommLimit
		SetDesc LSEG_PSP2,ProgPSP.Base, 512
		SetDesc LSEG_ENV, ProgENV.Base, ProgENV.Hi

		mov	eax, fhdr.f_eip
		mov	[EntryEIP], eax
IF FMR70
		call	a20_off
ENDIF
;
; show memory allocation
;
IF	Testing
		mov	dx, offset GDTBaseS
		call	Msg
		mov	eax, GDTBase
		call	Hex32

		mov	dx, offset LDTBaseS
		call	Msg
		mov	eax, LDTBase
		call	Hex32

		mov	dx, offset IDTBaseS
		call	Msg
		mov	eax, IDTBase
		call	Hex32

		mov	dx, offset ExeCodeS
		call	Msg
		mov	eax, ECode.Base
		call	Hex32

		mov	dx, offset ExeDataS
		call	Msg
		mov	eax, EData.Base
		call	Hex32

		mov	dx, offset ExeEntry
		call	Msg
		mov	eax, EntryEIP
		call	Hex32

		mov	dx, offset ExeLimits
		call	Msg
		mov	eax, ECode.Hi
		call	Hex32

		mov	eax, EData.Hi
		call	Hex32s

		mov	eax, EBss.Hi
		call	Hex32s

		mov	dx, offset ThisCodeS
		call	Msg
		mov	eax, ThisCodeBase
		call	Hex32

		mov	dx, offset ThisDataS
		call	Msg
		mov	eax, ThisDataBase
		call	Hex32

		mov	dx, offset ProtectedS
		call	Msg
		
		pop	es
		

		call	getchar
IF FMR70
		call	a20_on
ENDIF
		cmp	al, 'c'
		jnz	.st_mode1
		or	DebugFlag, MASK Sys_Out_COM
.st_mode1:		
		cmp	al, 'r'
		jnz	.st_mode2
		or	DebugFlag, MASK Deb_Trace_Reg
.st_mode2:
		cmp	al, ' '
		jnz	.st_mode3
		mov	DebugFlag, 0
		mov	TraceCount, 0
		jmp	.st_modex
.st_mode3:
		and	al, 1fh
		mov	ah, 0
		mov	TraceCount, ax
.st_modex:
ENDIF

IF	0
IF	Trace OR I7
		push	ds
		sub	bx, bx
		mov	ds, bx
IF	Trace
		mov	word ptr [bx][1*4+0], offset Int1
		mov	word ptr [bx][1*4+2], cs
		mov	word ptr [bx][3*4+0], offset Int3
		mov	word ptr [bx][3*4+2], cs
ENDIF
IF	I7
		mov	word ptr [bx][7*4+0], offset Int7
		mov	word ptr [bx][7*4+2], cs
ENDIF
IF	I2
		mov	word ptr [bx][2*4+0], offset Int2
		mov	word ptr [bx][2*4+2], cs
ENDIF
		pop	ds
ENDIF
ENDIF
;		test	DebugFlag, MASK Deb_Trap_DOS
;		jz	.notrap
		call	Copy_original

IF PCAT
		call	CopyVectors
		mov	ah, 50h
		call	P8259
ENDIF
		public	TP_Vect
TP_Vect		label	near
IF FMR70
		call	a20_on
ENDIF

		.386P
;;IF  	WithFPU				; with or without FPU
		fninit
		fstcw	Control387
		fwait
		or	Control387, 3fh
		fldcw	Control387
		fclex
		fsetpm
;;ENDIF
		cli
		lidt	IDTLimitBase		;interrupt descriptor table
		lgdt	GDTLimitBase		;global descriptor table
		mov	eax, CR0
		or	al, ONCR0
		and	al, OFFCR0
		mov	CR0, eax		;protection on
		fjmp	ThisCodeSel, ToProtection
		endp
		
ToProtection	proc	far
		mov	ax, LDTSel
		lldt	ax			;local descriptor table
		mov	ax, ThisDataSel
		mov	ds, ax
		
		mov	[TraceCount],0
		lss	esp, ExeSSESP
		mov	ax, ExeDataSel
		mov	ds, ax
		mov	es, ax
		mov	gs, ax
		mov	fs, ax
		sti
IF	Trace
		pushf
		or	word ptr [esp], 100h
		popf
		
ENDIF
		jmp	cs:[EntryPointer]	;do image
		endp
;
; fault trap
;
IRout		macro	n
Int&n		proc	near
		pushad
		mov	dx, offset Int&n&S
		jmp	CommonTrap
Int&n		endp
		endm

CommonTrap	proc	near
		mov	ax, _DATA
		mov	ds, ax
		call	Msg
		mov	dx, offset RegS
		call	Msg
		mov	bp, sp
		add	bp, 7*4
		mov	cx, 8

PrintRegs:	mov	eax, [bp]
		call	Hex32S
		sub	bp, 4
		loop	PrintRegs

		mov	ErrorOffset, 4
		call	PrintTrace
		call	PrintStack
		mov	eax, CR0
		jmp	OSExit
CommonTrap	endp
;
PrintStack	proc	near
		push	esi
		push	ecx
		push	eax
		mov	esi, SavedESP
		call	CRLF
		mov	ax, SavedSS
		test	al, 04
		jz	.prints1
		push	ax
;		mov	al,'L'
;		call	putchar
		pop	ax
		add	esi, EData.base
		sub	esi, ThisDataBase
.prints1:
;		les	eax, SavedSSESP
;		call	printPointer
;
		mov	dx, offset msg_stack
		call	Msg
		cld
		prefix32
		lodsw
		call	Hex
		mov	cx, 5
.prints2:
		prefix32
		lodsw 
		call	Hexs
		loop	.prints2
		mov	cx, 5
.prints3:
		prefix32
		lodsd 
		call	Hex32s
		loop	.prints3
		pop	eax
		pop	ecx
		pop	esi
		ret
PrintStack	endp

		IRout	0
		IRout	2
		IRout	4
		IRout	5
		IRout	6
		IRout	7
		IRout	8
		IRout	9
		IRout	10
		IRout	11
		IRout	12
		IRout	13
		IRout	14
		IRout	15
		IRout	16
		IRout	117		; 75h = NDP trap

PutReg		proc	near
		mov	ebp,esp
		mov	ecx,16
putreg1:		
		mov	eax, [ebp]
		call	Hex32S
		add	ebp, 4
		loop	putreg1

		call	CRLF
		ret
PutReg		endp
		
		extrn	Int1:near, Int3:near

;Come here thru Interrupt gate N

		.386P
IntrN		macro	n
Intr&n:		push	ds			;B-bit set, use ESP
		push	es
		push	fs
		push	gs
; 
		push	eax
		mov	ax,ThisDataSel		;select ThisData
		mov	ds, ax
		pop	eax
		
		mov	SavedIntN, n		;remeber interrupt #
		jmp	near ptr IntServer
		endm

TrapN		macro	n
Intr&n:		push	ds			;B-bit set, use ESP
		push	es
		push	fs
		push	gs
; test 12:00		
		push	eax
		mov	ax, ThisDataSel		;select ThisData
		mov	ds, ax
		pop	eax
		
		mov	SavedIntN, offset Int&n	;remeber interrupt #
		jmp	near ptr TrapServer
		endm

x		=	0
		rept	10h-0h+1
		TrapN	%x
x		=	x+1
		endm

		rept	20h-11h+1	;11h..20h
		IntrN	%x
x		=	x+1
		endm

;		IntrN	33

x		= 	22h		;x becomes 22h
		rept	3fh-22h+1	;22h..74h
		IntrN	%x
x		=	x+1
		endm

x		= 	40h		;x becomes 22h
		rept	4fh-40h+1
		IntrN	%x
x		=	x+1
		endm

x		= 	50h		;x becomes 22h
		rept	74h-50h+1	;22h..74h
		IntrN	%x
x		=	x+1
		endm
		
		TrapN	117

x		=	76h
		rept	0ffh-76h+1
		IntrN	%x
x		=	x+1
		endm

		.386P
IntServer	proc	far
		mov	SavedSS, ss		;remember Image's stack
		mov	SavedESP, esp
		mov	SavedEAX, eax		;store
		mov	ax, ds
		mov	es, ax			;all segments to ThisData
		mov	ss, ax
		mov	fs, ax
		mov	gs, ax

		mov	eax, CR0
		and	al, NOT 1
		mov	CR0, eax		;enter REAL mode

		fjmp	_TEXT, Flush

Flush		label	far
		mov	ax, _DATA		;all segments to .data
		mov	ds, ax
		mov	gs, ax

		mov	ax, COMMUNICATION
		mov	es, ax
		assume	es: COMMUNICATION

		mov	ax, 0			;except fs to 0
		mov	fs, ax
		lidt	RMIDTLimitBase		;real mode interrupts
		lss	esp, ThisSSESP
		mov	ax, SavedIntN		;get intr index
		cwde
		mov	ds, ToDosDS
		mov	es, ToDosES
		pushf				;emulate int
		push	cs
		push	offset RetI
		push	dword ptr fs: [4*eax]	;push address of int. routine
		mov	eax, gs: SavedEAX	;restore EAX
		ret				;goto int routine
IntServer	endp
;
;come here from int routine n
;
RetI		proc	far
		cli
		push	COMMUNICATION
		pop	fs
		mov	fs: FromDosDS, ds
		mov	fs: FromDosES, es
		push	_DATA
		pop	ds
		mov	SavedEAX, eax

		lidt	IDTLimitBase		;protected mode ints
		lgdt	GDTLimitBase

		mov	eax, CR0		;enter protected mode
		or	al, ONCR0
		and	al, OFFCR0
		mov	CR0, eax
		fjmp	ThisCodeSel, Protected
		
		.386P
Protected:	mov	ax, LDTSel
		lldt	ax			;local descriptors
		mov	ax, ThisDataSel		;ThisData
		mov	ds, ax
		mov	eax, SavedEAX
		lss	esp, SavedSSESP		;restore image's stack
; B-bit now set, use ESP
		pop	gs			;restore segment registers
		pop	fs
		pop	es
		pop	ds
		iretd				;return to image
RetI		endp

		.386P
TrapServer	proc	far
		mov	SavedSS, ss		;remember Image's stack
		mov	SavedESP, esp
		mov	SavedEAX, eax		;store
		mov	ax, ds
		mov	es, ax			;all segments to ThisData
		mov	fs, ax
		mov	gs, ax
comment %
IF TransPort		
		push	edi
		push	esi
		push	ebp
		push	ebx
		mov	edi, offset stack_log
		mov	ebx, 0
		cld
		mov	eax, ebp
		stosd
.trap_ss1:		
		mov	eax, ss:[ebp + ebx*4]
		stosd
		inc	bx
		cmp	bx, 1fh
		jb	.trap_ss1
		pop	ebx
		pop	ebp
		pop	esi
		pop	edi
ENDIF
%
		mov	ss, ax
		mov	eax, CR0
		and	al, NOT 1
		mov	CR0, eax		;enter REAL mode

		fjmp	_TEXT, TrapFlush

TrapFlush	label	far
		mov	ax, _DATA		;all segments to .data
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax
		lss	esp, ThisSSESP

		lidt	RMIDTLimitBase		;real mode interrupts

		sti
		mov	eax, SavedEAX
		call	SavedIntN		;call the routine

		cli

		lidt	IDTLimitBase		;protected mode ints
		lgdt	GDTLimitBase

		mov	eax, CR0		;enter protected mode
		or	al, ONCR0
		and	al, OFFCR0
		mov	CR0, eax
		fjmp	ThisCodeSel, TrapProtected

		.386P
TrapProtected:	mov	ax, LDTSel
		lldt	ax			;local descriptors
		mov	ax, ThisDataSel		;ThisData
		mov	ds, ax
		mov	eax, SavedEAX
		lss	esp, SavedSSESP		;restore image's stack
;
; B-bit now set, use ESP
;
		pop	gs			;restore segment registers
		pop	fs
		pop	es
		pop	ds
		iretd				;return to image
TrapServer	endp


;
;
; int 21 from protected mode
; Hardware interrupt may occure while CPU executing this routine.
; So, we must not share save area with other interrupt handlers.
;
		.386P
DosServer	proc	far
Intr33		label	far
		push	ds
		push	es
		push	fs
		push	gs
		push	eax

; setup accessability		
		cli
;
		mov	ax, ThisDataSel
		mov	ds, ax
		mov	es, ax
;
; save registers
;
		pop	eax

		mov	ExeEAX, eax
		mov	eax, [esp].sp_eip
		mov	ExeEIP, eax
		mov	ax, [esp].sp_cs
		mov	ExeCS,  ax
		mov	eax, [esp].sp_flag
		mov	SavedFlags, eax
		mov	ExeESP, esp
		mov	ExeSS,  ss
;		
		mov	ax, ds
		mov	ds, ax
		mov	es, ax
		mov	fs, ax
		mov	gs, ax
		mov	ss, ax
;
		mov	eax, CR0
		and	al, NOT 1
		mov	CR0, eax
;
		extrn	DosFlush:far
		fjmp	_TEXT, DosFlush
		endp

		public	dosprotected
DosProtected	proc	far
		mov	ax, LDTsel
		lldt	ax
		mov	ax, ThisDataSel
		mov	ds, ax
		mov	es, ax
;
; labeled just for temporaly
;
		lss	esp, ExeSSESP
		mov	eax, SavedFlags
		mov	ss:[esp].sp_flag,eax
		mov	eax, ExeEAX
		pop	gs
		pop	fs
		pop	es
		pop	ds
		sti
		iretd
		endp

_TEXT		ends
		end	Start

		.386
O_APPEND	equ	8
O_CREAT		equ	100h
O_TRUNC		equ	200h
O_EXCL		equ	400h


		include xmhd.inc
		include xmmac.mac
		include	termio.inc
		include	stat.inc
		include	exp.inc
		include xmmsg.def

_DATA		segment	para public USE16 'DATA'
		
		
		extrn	EData:byte, EBSS:byte
		extrn	ECode:byte
		extrn	Param:dword
		extrn	DosWorkI: byte, DosWorkO: byte
		extrn	PSPWork: dword
		public	fhdr

;FileName	db	MAXFILENAME+2 dup (0)

fhdr		filehdr	<>
comment %
ahdr		aouthdr	<>
shdr		scnhdr	<>
%

NotSupported	db	'This format is not supported',13,10,0
Default_ext	db	'.exp',0

		public	Handle
Handle		dw	?

_DATA		ends
;
_TEXT		segment	para public USE16 'CODE'
		assume	cs:_TEXT, ds:_DATA
;
		public	ReadFOHdr, ReadSHdr
		public	OpenExe, AddExtention
		extrn	OSExit: near
IF FMR70
		extrn	a20_off: near, a20_on:near
ENDIF

ReadFOHdr	proc	near		; read file header 
IF FMR70
		call	a20_off
ENDIF
		mov	bx, Handle
		mov	ah, 3fh
		mov	dx, offset fhdr
		mov	cx, (size fhdr) 
		int	21h
		jc	Error
		cmp	ax, cx
		jc	Error

		mov	ax, fhdr.f_magic
		cmp	ax, EXPMAGIC
		je	read_fh_ok
		cmp	ax, AoutMagic
		je	read_fh_ok
		jne	Error
read_fh_ok:
		ret
ReadFOHdr	endp

ReadSHdr	proc	near		; read section headers
		mov	bx, offset fhdr
		cmp	[bx].f_magic, EXPMAGIC
		jne	read_aout
read_exp:		
		mov	dx, [bx].f_nhdr
		shl	dx, 4
		mov	cx, 0
		mov	bx, Handle
		mov	ah, 42h   	; skip header parts
		mov	al, 0		; seek from top of file
		int	21h		; 
		jc	Error
;read code
		movzx	ebx, Handle
		mov	Param[0], ebx
		mov	eax, ECode.Base
		mov	Param[4],eax		; code area to load in
		push	eax
		movzx	eax, fhdr.f_npage
		shl	eax, 9
		movzx	ebx, fhdr.f_nbyte
		add	eax, ebx
		movzx	ebx, fhdr.f_nhdr
		shl	ebx, 4
		sub	eax, ebx
		mov	Param[8], eax		; bytes to readin
		mov	si, psp_mem_min
		mov	dword ptr PSPwork[si], eax
		mov	ECode.Hi, eax
;
		push	eax
		neg	eax
		add	eax, EData.Hi
;		sub	eax, EData.Base
		mov	si, psp_mem_bss
		mov	dword ptr PSPwork[si], eax
		
		mov	eax, EData.Hi
;		sub	eax, EData.Base
		mov	si, psp_mem_max
;
; allocate communication buffer
;
		sub	eax, 1000h
		mov	dword ptr PSPwork[si], eax
		mov	EBSS.Hi, eax
		pop	eax
;		
		pop	ebx
		add	eax, ebx		; start + size
;		mov	ECode.Hi, eax
		inc	eax
		mov	EBSS.Lo, eax
		xor	eax,eax
;		mov	ECode.Lo, eax
;		mov	EData.Lo, eax

; setup transfer addres in es:edi
;
		push	es
		mov	ax, ds
		mov	es, ax
		movzx	eax, ax
		shl	eax, 4
		mov	edi, ECode.Base 	;48bit pointer
		sub	edi, eax	
		cld
;		
; read file into inner buffer	
.readloop:
IF FMR70
		call	a20_off
ENDIF
		mov	cx, PageSize
		lea	dx, DosWorkI		;PageBuffer
		mov	ah, 3fh
		mov	bx, Handle
		int	21h
		jc	Error
;
		mov	cx, ax
		jcxz	.done
IF FMR70
		call	a20_on
ENDIF
		lea	esi, DosWorkI		;PageBuffer
		prefix32
	rep	movsb
		jmp	.readloop
.done:
		pop	es
		ret 
ReadSHdr	endp

AddExtention	proc	near	
		push	di
		push	si
		push	cx
		push	ax
		mov	di, offset fileName
		mov	al, 0
		mov	cx, MAXFILENAME
		cld
	repne	scasb
		cmp	cx, 0
		je	.add_no
		dec	di
		mov	si, offset default_ext
		mov	cx, 5			; '.xxx'+EOS
	rep	movsb
.add_no:
		pop	ax
		pop	cx
		pop	si
		pop	di
		ret
AddExtention	endp

OpenExe		proc	near
IF FMR70
		call	a20_off
ENDIF
		mov	al, byte ptr FileName
		cmp	al, 0
		je	.file_not_found
		mov	dx, offset FileName
		mov	ax, 3d00h	;open for reading
		je	.file_not_found
		int	21h
		mov	Handle, ax
		jnc	OEDone
		call	AddExtention
; file not found error
		mov	dx, offset FileName
		mov	ax, 3d00h
		int	21h
		mov	Handle, ax
		jnc	OEDone

; file does not exist		
.file_not_found:
		mov	dx, offset XNameS
		call	Msg
		mov	dx, offset FileName
		call	Msg
		mov	dx, offset NFS
		call	Msg
		jmp	OSExit
OEDone:		ret
OpenExe		endp
		model	small

read_aout	proc	near
		cmp	[bx].a_magic, AoutMagic
		jne	Error
		cmp	[bx].a_CPU, AoutI386
		jne	Error
		mov	dx, offset NotSupported
		call	Msg
		mov	ax, [bx].a_CPU
		shl	eax, 16
		mov	ax, [bx].a_magic
;		
		endp
Error		proc	near
		push	ax
		call	hex32
		mov	dx, offset ErrorS
		mov	ax, _DATA
		mov	ds, ax
		pop	ax
		call	Msg
		jmp	OSExit
Error		endp




_TEXT		ends
		end	


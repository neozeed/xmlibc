filehdr		struc
f_magic		dw	?	; magic number, CPU id. etc.
f_nbyte		dw	?	; bytes in last page
f_npage		dw	?	; file size in pages 
f_nreloc	dw	?	; # of relocation item
f_nhdr		dw	?	; # bytes for header
f_minalloc	dw	?	; minimum memory required (page)
f_maxalloc	dw	?	; maximum 
f_esp		dd	?	; value of esp
f_sum		dw	?	; check sum
f_eip		dd	?	; entry point
f_qq		dw	?	;
f_ovr		dw	?	;
filehdr		ends

aouthdr		struc
a_magic		dw	?
a_cpu		dw	?
a_text		dd	?
a_data		dd	?
a_bss		dd	?
a_syms		dd	?
a_entry		dd	?
a_trsize	dd	?
a_drsize	dd	?
aouthdr		ends

; *** MAGIC *** ;

EXPMAGIC	equ	0504dh
AoutMagic	equ	00107h
AoutI386	equ	100

comment %
IAPX16		equ	0504o
IAPX16TV	equ	0505o
IAPX20		equ	0506o
IAPX20TV	equ	0507o

B16MAGIC	equ	0502o
BTVMAGIC	equ	0503o

X86MAGIC	equ	0510o
XTVMAGIC	equ	0511o

I286SMAGIC	equ	0512o
I286LMAGIC	equ	0522o

I386MAGIC	equ	0514o

N3BMAGIC	equ	0550o
NTVMAGIC	equ	0551o
WE32MAGIC	equ	0560o
FBOMAGIC	equ	0560o
RBOMAGIC	equ	0562o
MTVMAGIC	equ	0561o

VAXWRMAGIC	equ	0570o
VAXROMAGIC	equ	0575o

MC68MAGIC	equ	0520o
MC68KWRMAGIC	equ	0520o
MC68TVMAGIC	equ	0521o
MC68KROMAGIC	equ	0521o
MC68KPGMAGIC	equ	0522o
M68MAGIC	equ	0210o
M68TVMAGIC	equ	0211o

U370WRMAGIC	equ	0530o
U370ROMAGIC	equ	0535o

AMDRMMAGIC	equ	0531o
AMDROMAGIC	equ	0534o

%

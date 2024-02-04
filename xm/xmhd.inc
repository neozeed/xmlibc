;
; Testing..StopOs was 0
;
PCAT		equ	1
FMR70		equ	0
TransPort	equ	0
Testing		equ	0
Trace		equ	0
TraceDOS	equ	0
TrapDOS     	equ	0
TraceOS		equ	0
StopOS		equ	0
MsgToCom  	equ	0
TraceReg	equ	0

Sanity		equ	1
StackCheck	equ	0	; was 1
I7		equ	1
I2		equ	1

;
; communication (serial) port used by xm.
;
CommPort	equ	1	; com 1
;
; Machine dependent parm
;
;STACK_SIZE	equ	001000h
MEM_LO		equ	100000h
;MEM_HI		equ	1fffffh
;STACK_HI	equ	(MEM_HI-MEM_LO)
;test 22:32
;STACK_LO	equ	MEM_HI - STACK_SIZE	;(10f000h - STACK_SIZE)
PAGESIZE	equ	4096
PAGESHIFT	equ	12
MaxTransfer	equ	PageSize * 2	; 2 Pages at once


;
; Environment definition
;
psp_mem_min	equ	05ch
psp_mem_max	equ	060h
psp_mem_bss	equ	064h
psp_envseg	equ	02ch


MAXFILENAME	equ	31

ONCR0		equ	11h
OFFCR0		equ	(NOT 0eh)

DosFuncMax	equ	63h		;($ - DosCallP) / 2
OSFuncMax	equ	2		;

DosBufferSize	equ	PageSize * 2



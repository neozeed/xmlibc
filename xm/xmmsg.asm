		.386
		include xmhd.inc
		
_DATA		segment	para public USE16 'DATA'
		public	FileName, XNameS, ErrorS
		public	Int0S, Int2S, Int4S, Int5S
		public	Int6S, Int7S, Int8S, Int9S
		public	Int10S, Int11S, Int12S, Int13S
		public	Int14S, Int15S, Int16S, Int117S
;
;
FileName	db	MAXFILENAME+1 dup (0)

XNameS		db	"xm: ", 0
ErrorS		db	" Bad Header", 0

Int0S		db	0dh, 0ah, "Division Overflow", 0dh, 0ah, 0
Int2S		db	0dh, 0ah, "Non Maskable Interrupt", 0dh, 0ah, 0
Int4S		db	0dh, 0ah, "Overflow", 0dh, 0ah, 0
Int5S		db	0dh, 0ah, "Out of Bounds", 0dh, 0ah, 0
Int6S		db	0dh, 0ah, "Invalid Opcode", 0dh, 0ah, 0
Int7S		db	0dh, 0ah, "Coprocessor Not Available", 0dh, 0ah, 0
Int8S		db	0dh, 0ah, "Double Fault", 0dh, 0ah, 0
Int9S		db	0dh, 0ah, "*** RESERVED 9 ***", 0dh, 0ah, 0
Int10S		db	0dh, 0ah, "Invalid TSS", 0dh, 0ah, 0
Int11S		db	0dh, 0ah, "Segment Not Present", 0dh, 0ah, 0
Int12S		db	0dh, 0ah, "Stack Exception", 0dh, 0ah, 0
Int13S		db	0dh, 0ah, "General Protection Exception", 0dh, 0ah, 0
Int14S		db	0dh, 0ah, "Page Fault", 0dh, 0ah, 0
Int15S		db	0dh, 0ah, "*** RESERVED 0e ***", 0dh, 0ah, 0
Int16S		db	0dh, 0ah, "Coprocessor Error 10h", 0dh, 0ah, 0
Int117S		db	0dh, 0ah, "Coprocessor Error 75h", 0dh, 0ah, 0

		public	RegS, CRLFS, EraseS, SpaceS
		public	ColonS, Asterisk, UsageS
		public	NFS, SanityS, StackS, IllegalS
		public	FuncNotAvail, ExitMsg, TraceMsg
		public	msg_stack, code_modifyed, MemValidQ

RegS		db	"   EAX      ECX      EDX      EBX      ESP      EBP      ESI      EDI"
CRLFS		db	0ah, 0dh, 0
EraseS		db	8, 20h, 8, 0
SpaceS		db	" ", 0
ColonS		db	":", 0
Asterisk	db	"*", 0
UsageS		db	"eXtend Memory for "
IF  PCAT
		db	" PC/AT 386 "
ENDIF
IF  FMR70
		db	" FMR70 "
ENDIF
		db	13,10,"Usage: xm file {arg}", 0
NFS		db	" File not found", 0
SanityS		db	" InSane pointer to OS Call ", 0
StackS		db	" Stack exceeds limit ", 0
IllegalS	db	0dh, 0ah, "Illegal OS Gate Call: ", 0
FuncNotAvail	db	" is not available Dos Function. CS:EIP=",0
ExitMsg		db	" end by ",0
TraceMsg	db	13,10," Trace ",0
msg_stack	db	'Stk:',0
code_modifyed	db	" Program code has been modified at ",0
MemValidQ	db	"HiMEM seems invalid, go ? (y/n) ",0

IF	Testing
		public	HelloS, GDTBaseS, IDTBaseS
		public	LDTBaseS, ExeCodeS, ExeDataS
		public	ExeEntry, ExeLimits, ThisCodeS
		public	ThisDataS, ProtectedS

HelloS		db	0dh, 0ah, "eXtend Memory for ms-dos ver 0.5 "
IFDEF  FMR70
		db	" For FMR70 "
ENDIF
IFDEF	PCAT
		db	" For PC/AT "
ENDIF
		db	0
GDTBaseS	db	0dh, 0ah, "GDT Linear Base: ", 0
IDTBaseS	db	0dh, 0ah, "IDT Linear Base: ", 0
LDTBaseS	db	0dh, 0ah, "LDT Linear Base: ", 0
ExeCodeS	db	0dh, 0ah, "Image Code Segment Linear Base: ", 0
ExeDataS	db	0dh, 0ah, "Image Data Segment Linear Base: ", 0
ExeEntry	db	0dh, 0ah, "Image Code Entry point at: ", 0
ExeLimits	db	0dh, 0ah, "Image Data Limit at : ", 0
ThisCodeS	db	0dh, 0ah, "This Code Segment Linear Base: ", 0
ThisDataS	db	0dh, 0ah, "This Data Segment Linear Base: ", 0
ProtectedS	db	0dh, 0ah, "Entering Protected Mode", 0dh, 0ah, 0
ENDIF
_DATA		ends
		end
		
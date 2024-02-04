/*
	GNU Library	written by h.yama on 90-3-8
	
	error handler called by IEEE floating point emulator
*/
#for Towns

	.align 2
.globl	__em_error
__em_error:
/*	intl	$0
*/
	ret
	.align	2
.globl	__error
__error:
	movb	$0x4c,%ah
	movb	$8,%al
	intl	$0x21
	nop

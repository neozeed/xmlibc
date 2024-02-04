/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-4-4		version 0.4

 ***/   
.text                                   
	.align 2
.globl _ldexps			/* return x * 2**int */
_ldexps:			/* for single */
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%edi
	pushl	%edx
	movl	8(%ebp),%eax
	call	__em_ffloat
	addl	12(%ebp),%edi
	call	__em_2float
	popl	%edx
	popl	%edi
	leave
	ret


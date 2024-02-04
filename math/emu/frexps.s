/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-4-4		version 0.4

 ***/   
.text                                   
	.align 2
.globl _frexps			/* return mantissa, store exponent */
_frexps:			/* for single */
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%edi
	pushl	%edx
	movl	8(%ebp),%eax
	call	__em_ffloat
	movl	12(%ebp),%esi
	movl	%edi,0(%esi)
	xorl	%edi,%edi
	call	__em_2float
	popl	%edx
	popl	%edi
	leave
	ret


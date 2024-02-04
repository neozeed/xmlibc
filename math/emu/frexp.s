/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-4-4		version 0.4

 ***/   
.text                                   
	.align 2
.globl _frexp			/* return mantissa, store exponent */
_frexp:	
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%edi
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	call	__em_fdouble
	movl	16(%ebp),%esi
	incl	%edi
	movl	%edi,0(%esi)
	movl	$-1,%edi
	call	__em_2double
	popl	%edi
	leave
	ret


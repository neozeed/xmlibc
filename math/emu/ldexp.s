/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-4-4		version 0.4

 ***/   
.text                                   
	.align 2
.globl _ldexp			/* return x * 2**int */
_ldexp:		
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%edi
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	call	__em_fdouble
	addl	16(%ebp),%edi
	call	__em_2double
	popl	%edi
	leave
	ret


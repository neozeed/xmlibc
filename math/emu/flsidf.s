/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-20		version 0.4
		90-3-3		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___floatsidf		/* long --> double  */
___floatsidf:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	xorl	%edx,%edx	/* 64 bit sign extend		*/
	btl	$31,%eax
	sbbl	$0,%edx
	call	__em_flong
	call	__em_2double	
	btl	$31,8(%ebp)	/* keep original sign bit */
	jnb	.fdx
	btsl	$31,%edx		
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixdfsi		/* 倍精度浮動小数を longに */
___fixdfsi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	call	__em_fdouble
	call	__em_2long	
	testl	%edx,%edx
	jnz	.fi_over
	btl	$31,%eax
	jc	.fi_over
	btl	$31,12(%ebp)	/* 符号ビットは元のものを保存する */
	jnb	.fdx
	negl	%eax
	jnz	.fdx
	incl	%edx
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
.fi_over:
	movl	$-1,%eax
	btl	$31,12(%ebp)
	rcrl	$1,%eax
	ret
/*
	pushl	$9912
	call	__em_error
	call	__error
	addl	$4,%esp
	jmp	.fdx	
*/

/***  
   floating point for 80386 
   
   (c) h.yama  90-3-8		version 0.3
   
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
	jz	.fidx
	movl	$0x7fffffff,%eax
.fidx:	
	btl	$31,12(%ebp)	/* 符号ビットは元のものを保存する */
	jnb	.fdx
	negl	%eax
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


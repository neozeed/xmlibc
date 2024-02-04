/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixunssfsi		/* ’P¸“x•‚“®¬”‚ğ ulong‚É */
___fixunssfsi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	btl	$31,%eax
	jb	.fi_out
	call	__em_ffloat
	call	__em_2ulong	
	testl	%edx,%edx
	jz	.fdx
.fi_over:
	movl	$-1,%eax
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
.fi_out:			/* input out of range */
	movl	$0,%eax
	jmp	.fdx
	

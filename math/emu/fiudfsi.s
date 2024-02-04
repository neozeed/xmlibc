/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.4

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixunsdfsi		/* ”{¸“x•‚“®¬”‚ğ long‚É */
___fixunsdfsi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	btl	$31,%edx
	jc	.fi_out
	call	__em_fdouble
	call	__em_2ulong	
	btl	$31,%eax
	jc	.fdx0
	testl	%edx,%edx
.fdx0:	
	jz	.fdx
	movl	$0x7fffffff,%eax
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
.fi_out:		/* input out of range */
	movl	$0x0,%eax
	jmp	.fdx
	
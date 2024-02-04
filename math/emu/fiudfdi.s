/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixunsdfdi		/* ”{¸“x•‚“®¬”‚ğ ulong long‚É */
___fixunsdfdi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	btl	$31,%edx
	jb	.fi_out
	call	__em_fdouble
	call	__em_2ulong	
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
.fi_out:
	pushl	$9913
	call	__em_error
	call	__error
	addl	$4,%esp
	jmp	.fdx	



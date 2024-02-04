/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___floatunsdisf		/* ulong long‚ğ’P¸“x•‚“®¬” */
___floatunsdisf:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	btl	$31,%edx
	jnb	.fd1
	shrdl	$1,%edx,%eax
	shrl	$1,%edx
	call	__em_flong
	incl	%edi
	jmp	.fd2
.fd1:	
	call	__em_flong
.fd2:	
	call	__em_2float	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


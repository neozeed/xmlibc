/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___floatunssisf		/* ulong��P���x�������� */
___floatunssisf:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	xorl	%edx,%edx	/* 64 bit zero extend		*/
	call	__em_flong
	call	__em_2float	/* �����r�b�g��0 */
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


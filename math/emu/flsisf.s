/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___floatsisf		/* long��P���x�������� */
___floatsisf:
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
	call	__em_2float	/* �����r�b�g�͌��̂��̂�ۑ����� */
	btl	$31,8(%ebp)
	jnb	.fdx
	btsl	$31,%eax		
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


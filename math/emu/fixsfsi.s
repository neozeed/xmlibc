/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixsfsi		/* �P���x���������� long�� */
___fixsfsi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	call	__em_ffloat
	call	__em_2long	
	btl	$31,%eax
	jc	.fi_over
	testl	%edx,%edx
	jz	.fdx0
.fi_over:
	movl	$0x7fffffff,%eax
.fdx0:	
	btl	$31,8(%ebp)	/* �����r�b�g�͌��̂��̂�ۑ����� */
	jnb	.fdx
	negl	%eax		
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret

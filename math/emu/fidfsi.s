/***  
   floating point for 80386 
   
   (c) h.yama  90-3-8		version 0.3
   
 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixdfsi		/* �{���x���������� long�� */
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
	btl	$31,12(%ebp)	/* �����r�b�g�͌��̂��̂�ۑ����� */
	jnb	.fdx
	negl	%eax
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


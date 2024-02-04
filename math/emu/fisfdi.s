/***  
   floating point for 80386 
   
   (c) h.yama  90-3-8		version 0.3
   
 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixsfdi		/* �P���x���������� long long�� */
___fixsfdi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	call	__em_ffloat
	call	__em_2long	
	btl	$31,8(%ebp)	/* �����r�b�g�͌��̂��̂�ۑ����� */
	jnb	.fdx
	notl	%edx
	negl	%eax		
	jnz	.fdx
	incl	%edx
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 4
.globl ___extendsfdf2
___extendsfdf2:			/*�P���x����{���x�ɕϊ����� */
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax	/* ��x���Ԍ`���ɕϊ�����	*/
	call	__em_ffloat
	call	__em_2double	/* �{���x�ɕϊ�����		*/
	btl	$31,8(%ebp)	/* ���̒l�̕����r�b�g��ۑ�����	*/
	jnb	.extdf1
	btsl	$31,%edx
.extdf1:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret


/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text                                   
	.align 2
.globl _sqrts
_sqrts:				/* �P���x����̕����� */
	pushl %ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	movl	8(%ebp),%eax	
	testl	%eax,%eax
	jz	.sqrx		/* 0�ɑ΂��Ă�0��Ԃ�*/
	js	.sqre		/* ���̒l�ɑ΂��Ă� �G���[����*/
	call	__em_ffloat	/*�܂����Ԍ`���ɒ��� */	
	call	__em_sqrt	/* �J�������s	*/
	call	__em_2float
.sqrx:	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret
.sqre:
	pushl	$9910		/* ���̒l�ɑ΂���G���[����*/
	call	__em_error	/* em_error���Ă��	*/
	popl	%eax
	xorl	%eax,%eax	/* 0��Ԃ�		*/
	jmp	.sqrx



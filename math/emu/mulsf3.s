.text                                   
	.align 4
.globl ___mulsf3
___mulsf3:			/* �P���x��Z */
	pushl %ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	movl	12(%ebp),%eax	/*�܂����Ԍ`���ɒ��� */
	call	__em_ffloat
	movl	%edi,%esi
	movl	%edx,%ebx
	movl	%eax,%ecx
	movl	8(%ebp),%eax
	call	__em_ffloat
	call	__em_mulu	/* ��Z�����s	*/
	call	__em_2float
	testl	%eax,%eax
	jz	.fmulx
	movl	8(%ebp),%esi	/* �����𒲂ׂ� 	*/
	xorl	12(%ebp),%esi		/* �����ٕ����Ȃ� */
	andl	$0x80000000,%esi
	orl	%esi,%eax		/* ���ʂ͕�	*/
.fmulx:	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret




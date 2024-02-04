.text
	.align 2
.globl ___addsf3		/*�P���x�̉��Z  A + B */
___addsf3:			
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	
	movl	12(%ebp),%eax	/* ���������ǂ���Ƃ����Ԍ`���ɒ����Ă��� */
	call	__em_ffloat
	movl	%edi,%esi
	movl	%edx,%ebx
	movl	8(%ebp),%eax	/* edi.edx + esi.ebx �����΂���	*/
	call	__em_ffloat
	
	btl	$31,8(%ebp)	
	jb	.fadd3
	btl	$31,12(%ebp)	/* A �� 0 */
	jb	.fadd2			/* B �� 0 */
	call	__em_addu	
	call	__em_2float
	jmp	.faddx2
.fadd2:
	call	__em_subu		/* B �� 0 */
	jmp	.fadd3x
.fadd3:
	btl	$31,12(%ebp)	/* A �� 0 */
	jb	.fadd4			/* B �� 0 */
	xchgl	%edi,%esi
	xchgl	%edx,%ebx		/* |B| - |A| ���v�Z����	*/
	call	__em_subu
.fadd3x:	
	call	__em_2float		
	orl	%esi,%eax
	jmp	.faddx2
.fadd4:					/* B �� 0 */
	call	__em_addu		/* �܂� |A| + |B|������	*/
	call	__em_2float		/* ���ʂ̕����𕉂ɂ���	*/
	btsl	$31,%eax
.faddx2:
	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret


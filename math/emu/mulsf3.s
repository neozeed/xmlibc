.text                                   
	.align 4
.globl ___mulsf3
___mulsf3:			/* 単精度乗算 */
	pushl %ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	movl	12(%ebp),%eax	/*まず中間形式に直す */
	call	__em_ffloat
	movl	%edi,%esi
	movl	%edx,%ebx
	movl	%eax,%ecx
	movl	8(%ebp),%eax
	call	__em_ffloat
	call	__em_mulu	/* 乗算を実行	*/
	call	__em_2float
	testl	%eax,%eax
	jz	.fmulx
	movl	8(%ebp),%esi	/* 符号を調べる 	*/
	xorl	12(%ebp),%esi		/* 元が異符号なら */
	andl	$0x80000000,%esi
	orl	%esi,%eax		/* 結果は負	*/
.fmulx:	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret




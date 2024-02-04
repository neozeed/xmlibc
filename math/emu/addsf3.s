.text
	.align 2
.globl ___addsf3		/*単精度の加算  A + B */
___addsf3:			
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	
	movl	12(%ebp),%eax	/* 引き数をどちらとも中間形式に直しておく */
	call	__em_ffloat
	movl	%edi,%esi
	movl	%edx,%ebx
	movl	8(%ebp),%eax	/* edi.edx + esi.ebx をやればいい	*/
	call	__em_ffloat
	
	btl	$31,8(%ebp)	
	jb	.fadd3
	btl	$31,12(%ebp)	/* A ≧ 0 */
	jb	.fadd2			/* B ≧ 0 */
	call	__em_addu	
	call	__em_2float
	jmp	.faddx2
.fadd2:
	call	__em_subu		/* B ≦ 0 */
	jmp	.fadd3x
.fadd3:
	btl	$31,12(%ebp)	/* A ≦ 0 */
	jb	.fadd4			/* B ≧ 0 */
	xchgl	%edi,%esi
	xchgl	%edx,%ebx		/* |B| - |A| を計算する	*/
	call	__em_subu
.fadd3x:	
	call	__em_2float		
	orl	%esi,%eax
	jmp	.faddx2
.fadd4:					/* B ≦ 0 */
	call	__em_addu		/* まず |A| + |B|を求め	*/
	call	__em_2float		/* 結果の符号を負にする	*/
	btsl	$31,%eax
.faddx2:
	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret


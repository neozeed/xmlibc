.text
	.align 2
.globl ___divsf3
___divsf3:		/*単精度浮動小数の割り算  A÷B	*/
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	
	movl	8(%ebp),%eax
	andl	0x7fffffff,%eax
	movl	12(%ebp),%eax
	jz	.fdiv_by_0
	call	__em_ffloat
	movl	%edi,%esi
	movl	%edx,%ebx
	movl	%eax,%ecx
	movl	8(%ebp),%eax
	call	__em_ffloat		/* 被除数を中間形式に	*/

	cmp	%edx, %ebx
	jb	.fdiv_01
	shrl	$1,%edx
	incl	%edi
.fdiv_01:
	xorl	%eax,%eax
	divl	%ebx
	mov	%eax, %ecx
	xorl	%eax, %eax
	divl	%ebx
	movl	%ecx, %edx
	subl	%edi, %esi
;
	or	%eax,%ecx
	jz	.fdiv1
.fdiv_02:
	decl	%edi
	shll	$1,%eax
	rcl	$1,%edx
	jnc	.fdiv_02
	mov	%edx,%eax
	shrdl	$8,%edi,%eax
	andl	$0x7fffffff,%eax	
	jz	.fdiv1
	
	movl	8(%ebp),%edx		/* 符号を調べておく */
	xorl	12(%ebp),%edx
	andl	$0x80000000,%edx
	orl	%edx,%eax		/* 符号ビットを設定する */
.fdiv1:
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret
.fdiv_by_0:
	or	%eax, 0x7fffffff
	jmp	.fdiv1


/*	gnu cc library
	(c) h.yama	1990,
*/
.text
	.align 2
.globl ___lshrdi3
___lshrdi3:
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ecx
	movl 	8(%ebp),%ecx
	movl 	12(%ebp),%eax
	movl 	16(%ebp),%edx
	testl 	%ecx,%ecx
	je L1
	cmpl	$64,%ecx
	jae	.ret_zero
	cmpl	$32,%ecx
	jb	.do
	movl	%edx,%eax
	xorl	%edx,%edx
	shrl	%cl,%eax
	jmp	.done
.do:
	shrdl	%cl,%edx,%eax
	shrl	%cl,%edx
.done:
	popl	%ecx
	leave
	ret
.ret_zero:
	xorl	%edx,%edx
	xorl	%eax,%eax
	jmp	.done

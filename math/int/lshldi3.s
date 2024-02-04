/*	gnu cc library
	(c) h.yama	1990,
*/
.text
	.align 2
.globl ___lshldi3
___lshldi3:
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
	movl	%eax,%edx
	xorl	%eax,%eax
	shrl	%cl,%edx
	jmp	.done
.do:
	shldl	%cl,%eax,%edx
	shll	%cl,%eax
.done:
	popl	%ecx
	leave
	ret
.ret_zero:
	xorl	%edx,%edx
	xorl	%eax,%eax
	jmp	.done

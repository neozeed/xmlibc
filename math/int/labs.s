/*	gcc library	by h.yama
*/
.text
.align	2
.globl	_labs
_labs:
	movl	4(%esp),%eax
	movl	8(%esp),%edx
	testl	%edx,%edx
	jae	.done
	notl	%edx
	negl	%eax
	jnz	.done
	incl	%edx
.done:
	ret


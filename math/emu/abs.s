/*	gcc library	by h.yama
*/
.text
.align	2
.globl	_abs
_abs:
	movl	4(%esp),%eax
	testl	%eax,%eax
	jae	.done
	negl	%eax
.done:
	ret


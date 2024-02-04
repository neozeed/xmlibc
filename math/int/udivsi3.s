/*  gcc library
*/
.text
	.align 2
.globl ___udivsi3
___udivsi3:
	movl 	4(%esp),%eax
	xorl 	%edx,%edx
	divl 	8(%esp)
	ret


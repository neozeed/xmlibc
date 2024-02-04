/* gcc library
	(c) h.yama	1990,
*/
.text
	.align 2
.globl ___umodsi3
___umodsi3:
	movl 	4(%esp),%eax
	xorl	%edx,%edx
	divl 	8(%esp)
	xchgl	%eax,%edx
	ret

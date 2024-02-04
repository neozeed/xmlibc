/*  gnu cc library
	(c) h.yama 	1990,
*/
.text
.text
	.align 2
.globl ___adddi3
___adddi3:
	pushl 	%ebp
	movl 	%esp,%ebp
	movl 	8(%ebp),%eax
	movl 	12(%ebp),%edx
	addl 	16(%ebp)
	adcl 	20(%ebp)
	leave
	ret

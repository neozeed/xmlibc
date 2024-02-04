/*  gnu cc library
	(c) h.yama 	1990,
*/
.text
	.align 2
.globl ___subdi3
___subdi3:
	pushl 	%ebp
	movl 	%esp,%ebp
	movl 	8(%ebp),%eax
	movl 	12(%ebp),%edx
	subl 	16(%ebp)
	sbbl 	20(%ebp)
	leave
	ret

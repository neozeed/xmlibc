/*  gnu cc library
	(c) h.yama	1990,
*/

.text
	.align 4
.globl ___anddi3
___anddi3:
	pushl 	%ebp
	movl 	%esp,%ebp
	movl 	8(%ebp),%eax
	movl 	12(%ebp),%edx
	andl 	16(%ebp),%eax
	andl 	20(%ebp),%edx
	leave
	ret

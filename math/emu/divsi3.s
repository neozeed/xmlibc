/*	gcc library
*/
.text
	.align 2
.globl ___divsi3
___divsi3:
	pushl 	%ebp
	movl 	%esp,%ebp

	movl 	8(%ebp),%eax
	cltd
	idivl 	12(%ebp)

	leave
	ret

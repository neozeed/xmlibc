/*  gcc library
*/
.text
	.align 2
.globl ___mulsi3
___mulsi3:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	imull 12(%ebp),%eax
	leave
	ret

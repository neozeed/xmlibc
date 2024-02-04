/*  gcc library
*/
.text
	.align 2
.globl ___lshrsi3
___lshrsi3:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	movl 12(%ebp),%ecx
	shrl %cl,%eax
	leave
	ret

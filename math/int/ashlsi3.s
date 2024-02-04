/*  gcc library
*/
.text
	.align 2
.globl ___ashlsi3
___ashlsi3:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	movl 12(%ebp),%ecx
	sall %cl,%eax
	leave
	ret

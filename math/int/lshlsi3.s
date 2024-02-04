/*  gcc library
*/
.text
	.align 2
.globl ___lshlsi3
___lshlsi3:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	movl 12(%ebp),%ecx
	shll %cl,%eax
	leave
	ret

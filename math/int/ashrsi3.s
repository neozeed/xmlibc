/* gcc library
*/
.text
	.align 2
.globl ___ashrsi3
___ashrsi3:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	movl 12(%ebp),%ecx
	sarl %cl,%eax
	leave
	ret

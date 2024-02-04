/*  gcc library 
*/
.text
	.align 2
.globl ___modsi3
___modsi3:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	cltd
	idivl 12(%ebp)
	movl %edx,%eax
	leave
	ret

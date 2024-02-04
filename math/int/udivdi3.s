	.file	"tmp0001.$$$"
gcc_compiled.:
.text
	.align 4
.globl ___udivdi3
___udivdi3:
	pushl %ebp
	movl %esp,%ebp
	subl $40,%esp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ecx
	movl 12(%ebp),%ebx
	movl 16(%ebp),%eax
	movl 20(%ebp),%edx
	movl $0,-4(%ebp)
	movl $0,-8(%ebp)
	movl %ebx,-12(%ebp)
	movl %ecx,-16(%ebp)
	movl %edx,-20(%ebp)
	movl %eax,-24(%ebp)
	pushl $8
	pushl $16
	leal -40(%ebp),%eax
	pushl %eax
	leal -32(%ebp),%eax
	pushl %eax
	leal -24(%ebp),%eax
	pushl %eax
	leal -16(%ebp),%eax
	pushl %eax
	call ___bdiv
	movl -28(%ebp),%esi
	movl -32(%ebp),%ebx
	movl %ebx,%eax
	movl %esi,%edx
	leal -48(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

	.file	"g:/gnu/tmp/cmpdf21.i"
gcc_compiled.:
.text
	.align 4
.globl ___cmpdf2
___cmpdf2:
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%esi
	movl 16(%ebp),%ebx
	movl 12(%ebp),%ecx
	movl 20(%ebp),%edx
	cmpl %esi,%ebx
	jne L2
	cmpl %ecx,%edx
	je L11
	movl %ecx,%eax
	xorl %edx,%eax
	cmpl $-2147483648,%eax
	je L11
L2:
	cmpl %ecx,%edx
	jl L13
	jg L14
	cmpl %esi,%ebx
	jge L9
L13:
	movl $1,%eax
	jmp L1
	.align 2
L9:
	cmpl %esi,%ebx
	jle L11
L14:
	movl $-1,%eax
	jmp L1
	.align 2
L11:
	xorl %eax,%eax
L1:
	leal -8(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

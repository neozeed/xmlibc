	.file	"g:/gnu/tmp/cmpsf21.i"
gcc_compiled.:
.text
	.align 4
.globl ___cmpsf2
___cmpsf2:
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movl 12(%ebp),%esi
	pushl %ebx
	call ___floatsidf
	addl $4,%esp
	pushl %edx
	pushl %eax
	call ___truncdfsf2
	addl $8,%esp
	pushl 12(%ebp)
	pushl %eax
	call ___cmpsf2
	testl %eax,%eax
	je L3
	cmpl $-2147483648,%esi
	sete %al
	andl $1,%eax
	xorl %ebx,%eax
	je L2
L3:
	xorl %eax,%eax
	jmp L1
	.align 2
L2:
	cmpl %ebx,%esi
	jge L5
	movl $1,%eax
	jmp L1
	.align 2
L5:
	movl $-1,%eax
L1:
	leal -8(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

	.file	"tmp0001.$$$"
gcc_compiled.:
.text
	.align 4
.globl ___divdi3
___divdi3:
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movl 12(%ebp),%esi
	pushl $0
	pushl $0
	pushl %esi
	pushl %ebx
	call ___cmpdi2
	addl $16,%esp
	cmpl $1,%eax
	jge L2
	pushl $0
	pushl $0
	pushl 20(%ebp)
	pushl 16(%ebp)
	call ___cmpdi2
	addl $16,%esp
	cmpl $1,%eax
	jge L3
	pushl %esi
	pushl %ebx
	call ___negdi2
	addl $8,%esp
	movl %eax,%ebx
	movl %edx,%esi
	pushl 20(%ebp)
	pushl 16(%ebp)
	call ___negdi2
	addl $8,%esp
	pushl %edx
	pushl %eax
	jmp L8
	.align 2
L3:
	pushl %esi
	pushl %ebx
	call ___negdi2
	addl $8,%esp
	pushl 20(%ebp)
	pushl 16(%ebp)
	pushl %edx
	pushl %eax
	jmp L9
	.align 2
L2:
	pushl $0
	pushl $0
	pushl 20(%ebp)
	pushl 16(%ebp)
	call ___cmpdi2
	addl $16,%esp
	cmpl $1,%eax
	jge L6
	pushl 20(%ebp)
	pushl 16(%ebp)
	call ___negdi2
	addl $8,%esp
	pushl %edx
	pushl %eax
	pushl %esi
	pushl %ebx
L9:
	call ___udivdi3
	addl $16,%esp
	pushl %edx
	pushl %eax
	call ___negdi2
	jmp L1
	.align 2
L6:
	pushl 20(%ebp)
	pushl 16(%ebp)
L8:
	pushl %esi
	pushl %ebx
	call ___udivdi3
L1:
	leal -8(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

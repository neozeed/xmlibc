	.file	"/gnu/tmp/floor.i"
gcc_compiled.:
.text
	.align 4
.globl _floor
_floor:
	pushl %ebp
	movl %esp,%ebp
	subl $8,%esp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movl 12(%ebp),%esi
	leal -8(%ebp),%eax
	pushl %eax
	pushl %esi
	pushl %ebx
	call _modf
	pushl %eax
	call ___floatsidf
	addl $4,%esp
	addl $12,%esp
	pushl $0
	pushl $0
	pushl %edx
	pushl %eax
	call ___cmpdf2
	addl $16,%esp
	testl %eax,%eax
	jne L2
	movl %ebx,%eax
	movl %esi,%edx
	jmp L1
	.align 2
L2:
	pushl $0
	pushl $0
	pushl %esi
	pushl %ebx
	call ___cmpdf2
	addl $16,%esp
	testl %eax,%eax
	jl L4
	movl -8(%ebp),%eax
	movl -4(%ebp),%edx
	jmp L1
	.align 2
L4:
	pushl $1883483866
	pushl $-307352112
	pushl -4(%ebp)
	pushl -8(%ebp)
	call ___subdf3
L1:
	leal -16(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

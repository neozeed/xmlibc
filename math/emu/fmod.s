	.file	"/gnu/tmp/fmod.i"
gcc_compiled.:
.text
	.align 4
.globl _fmod
_fmod:
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %ebx
	pushl $0
	pushl $0
	pushl 20(%ebp)
	pushl 16(%ebp)
	call ___cmpdf2
	addl $16,%esp
	testl %eax,%eax
	jne L2
	movl 8(%ebp),%eax
	movl 12(%ebp),%edx
	jmp L1
	.align 2
L2:
	pushl 20(%ebp)
	pushl 16(%ebp)
	pushl 12(%ebp)
	pushl 8(%ebp)
	call ___divdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	call ___fixdfdi
	addl $8,%esp
	movl %eax,%ebx
	movl %edx,%esi
	pushl $0
	pushl $0
	pushl %esi
	pushl %ebx
	call ___cmpdi2
	addl $16,%esp
	cmpl $1,%eax
	jl L3
	pushl %esi
	pushl %ebx
	jmp L5
	.align 2
L3:
	pushl $0
	pushl $-1
	pushl %esi
	pushl %ebx
	call ___adddi3
	addl $16,%esp
	pushl %edx
	pushl %eax
L5:
	call ___floatdidf
	addl $8,%esp
	pushl 20(%ebp)
	pushl 16(%ebp)
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl 12(%ebp)
	pushl 8(%ebp)
	call ___subdf3
L1:
	leal -8(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

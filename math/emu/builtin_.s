	.file	"g:/gnu/tmp/builtin_.i"
gcc_compiled.:
.text
	.align 2
.globl ___builtin_new
___builtin_new:
	pushl %ebp
	movl %esp,%ebp
	pushl %ebx
	pushl 8(%ebp)
	call _malloc
	movl %eax,%ebx
	addl $4,%esp
	testl %ebx,%ebx
	jne L2
	movl ___new_handler,%eax
	call *%eax
L2:
	movl %ebx,%eax
	leal -4(%ebp),%esp
	popl %ebx
	leave
	ret

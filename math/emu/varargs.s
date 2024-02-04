	.file	"g:/gnu/tmp/varargs.i"
gcc_compiled.:
.text
	.align 2
.globl ___builtin_saveregs
___builtin_saveregs:
	pushl %ebp
	movl %esp,%ebp
	call _abort
	leave
	ret

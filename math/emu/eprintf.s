	.file	"/gnu/tmp/eprintf.i"
gcc_compiled.:
.text
	.align 4
.globl ___eprintf
___eprintf:
	pushl %ebp
	movl %esp,%ebp
	pushl 16(%ebp)
	pushl 12(%ebp)
	pushl 8(%ebp)
	pushl $__iob+48
	call _fprintf
	leave
	ret

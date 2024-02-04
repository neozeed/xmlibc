	.file	"g:/gnu/tmp/cos.i"
gcc_compiled.:
.text
	.align 4
.globl _cos
_cos:
	pushl %ebp
	movl %esp,%ebp
	pushl 12(%ebp)
	pushl 8(%ebp)
	pushl $1073291771
	pushl $1413754137
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	call _sin
	leave
	ret

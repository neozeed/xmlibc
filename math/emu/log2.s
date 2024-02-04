	.file	"g:/gnu/tmp/log2.i"
gcc_compiled.:
.text
	.align 4
.globl _log2
_log2:
	pushl %ebp
	movl %esp,%ebp
	pushl 12(%ebp)
	pushl 8(%ebp)
	call _log
	pushl _LOG_E_OF_2+4
	pushl _LOG_E_OF_2
	pushl %edx
	pushl %eax
	call ___muldf3
	leave
	ret

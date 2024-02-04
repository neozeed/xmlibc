	.file	"g:/gnu/tmp/log10.i"
gcc_compiled.:
.text
	.align 4
.globl _log10
_log10:
	pushl %ebp
	movl %esp,%ebp
	pushl 12(%ebp)
	pushl 8(%ebp)
	call _log
	pushl _LOG_E_OF_10+4
	pushl _LOG_E_OF_10
	pushl %edx
	pushl %eax
	call ___muldf3
	leave
	ret

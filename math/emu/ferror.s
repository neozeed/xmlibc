	.file	"g:/gnu/tmp/ferror.i"
gcc_compiled.:
.text
LC0:
	.ascii " divide by 0 \0"
LC1:
	.ascii " divide out of range\0"
	.align 2
.globl __ferror
__ferror:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	testl %eax,%eax
	je L3
	cmpl $1,%eax
	je L4
	jmp L2
	.align 2
L3:
	pushl $LC0
	jmp L7
	.align 2
L4:
	pushl $LC1
L7:
	pushl $__iob+48
	call _fprintf
	call _abort
L2:
	leave
	ret

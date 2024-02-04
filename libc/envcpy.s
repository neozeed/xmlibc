.text
.align 4
.globl	__envcpy,__envsize

/*
 void _envcpy(char *buf, size)
*/

__envcpy:
	pushl	%ebp
	movl	%esp,%ebp

	pushl	%edi
	pushl	%ecx

	movl	8(%ebp),%edi
	movl	12(%ebp),%ecx

	pushl	%ds
	pushl	%esi

	movl	%edi,%eax
	
	pushl	$0x2c			/* env segment */
	popl	%ds
	movl	$0,%esi

	rep
	movsb

	popl	%esi
	popl	%ds
	popl	%ecx
	popl	%edi

	leave
	ret

/* int _envsize(void) */
__envsize:
	pushl	%ds
	pushl	%esi

	pushl	$0x2c			/* env segment */
	popl	%ds
	movl	$0,%esi

_envsize_0:
	lodsb
	cmpb	$0,%al
	jz	_envsize_zero
	jmp	_envsize_0

_envsize_zero:
	lodsb
	cmpb	$0,%al
	jnz	_envsize_0

	lodsb
	lodsb
	lodsb

_envsize_progname:
	lodsb
	cmpb	$0,%al
	jnz	_envsize_progname

	movl	%esi,%eax

	popl	%esi
	popl	%ds
	ret

	.file	"g:/gnu/tmp/cmpsf2.i"
gcc_compiled.:
.text
	.align 2
.globl ___cmpsf2
___cmpsf2:
	pushl %ebp
	movl %esp,%ebp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movl 12(%ebp),%esi
	movl %ebx,%eax
	shrl $31,%eax
	movl %esi,%edx
	shrl $31,%edx
	leal (%edx,%eax),%eax
	movl $1,%ecx
	cmpl $1,%eax
	jne L18
	movl %ebx,%eax
	shrl $23,%eax
	testl $255,%eax
	jne L19
	movl %esi,%eax
	shrl $23,%eax
	testl $255,%eax
	jne L19
	testl $8388607,%ebx
	jne L19
	testl $8388607,%esi
	je L29
L19:
	movl %ebx,%eax
	shrl $31,%eax
	jne L20
	movl $1,%eax
	jmp L17
	.align 2
L20:
	movl $-1,%eax
	jmp L17
	.align 2
L18:
	cmpl $2,%eax
	jne L22
	movl $-1,%ecx
L22:
	movl %ebx,%eax
	shrl $23,%eax
	andl $255,%eax
	movl %esi,%edx
	shrl $23,%edx
	andl $255,%edx
	cmpl %eax,%edx
	jl L31
	movl %ebx,%eax
	shrl $23,%eax
	andl $255,%eax
	movl %esi,%edx
	shrl $23,%edx
	andl $255,%edx
	cmpl %eax,%edx
	jg L32
	movl %ebx,%eax
	andl $8388607,%eax
	movl %esi,%edx
	andl $8388607,%edx
	cmpl %eax,%edx
	jge L27
L31:
	movl %ecx,%eax
	jmp L17
	.align 2
L27:
	movl %ebx,%eax
	andl $8388607,%eax
	movl %esi,%edx
	andl $8388607,%edx
	cmpl %eax,%edx
	jle L29
L32:
	movl %ecx,%eax
	negl %eax
	jmp L17
	.align 2
L29:
	xorl %eax,%eax
L17:
	leal -8(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

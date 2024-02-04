	.file	"g:/gnu/tmp/cmpdf2.i"
gcc_compiled.:
.text
	.align 2
.globl ___cmpdf2
___cmpdf2:
	pushl %ebp
	movl %esp,%ebp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ebx
	movl 12(%ebp),%esi
	movl %esi,%edi
	shrl $31,%edi
	movl %edi,%eax
	movl 20(%ebp),%edi
	shrl $31,%edi
	movl %edi,%edx
	leal (%edx,%eax),%eax
	movl $1,%ecx
	cmpl $1,%eax
	jne L18
	movl %esi,%edi
	shrl $20,%edi
	movl %edi,%eax
	testl $2047,%eax
	jne L19
	movl 20(%ebp),%edi
	shrl $20,%edi
	movl %edi,%eax
	testl $2047,%eax
	jne L19
	testl $1048575,%esi
	jne L19
	testl $1048575,20(%ebp)
	jne L19
	testl %ebx,%ebx
	jne L19
	cmpl $0,16(%ebp)
	je L33
L19:
	movl %esi,%edi
	shrl $31,%edi
	movl %edi,%eax
	testl %eax,%eax
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
	movl %esi,%edi
	shrl $20,%edi
	movl %edi,%eax
	andl $2047,%eax
	movl 20(%ebp),%edi
	shrl $20,%edi
	movl %edi,%edx
	andl $2047,%edx
	cmpl %eax,%edx
	jl L35
	movl %esi,%edi
	shrl $20,%edi
	movl %edi,%eax
	andl $2047,%eax
	movl 20(%ebp),%edi
	shrl $20,%edi
	movl %edi,%edx
	andl $2047,%edx
	cmpl %eax,%edx
	jg L36
	movl $1048575,%eax
	andl %esi,%eax
	movl $1048575,%edx
	andl 20(%ebp),%edx
	cmpl %eax,%edx
	jl L35
	movl $1048575,%eax
	andl %esi,%eax
	movl $1048575,%edx
	andl 20(%ebp),%edx
	cmpl %eax,%edx
	jg L36
	cmpl 16(%ebp),%ebx
	jbe L31
L35:
	movl %ecx,%eax
	jmp L17
	.align 2
L31:
	cmpl 16(%ebp),%ebx
	jae L33
L36:
	movl %ecx,%eax
	negl %eax
	jmp L17
	.align 2
L33:
	xorl %eax,%eax
L17:
	leal -12(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	leave
	ret

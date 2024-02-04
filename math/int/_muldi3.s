	.file	"tmp0001.$$$"
gcc_compiled.:
.text
	.align 4
.globl ___muldi3
___muldi3:
	pushl %ebp
	movl %esp,%ebp
	subl $4,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 12(%ebp),%ebx
	movl 20(%ebp),%esi
	testl %ebx,%ebx
	jge L4
	testl %esi,%esi
	jg L3
L4:
	testl %ebx,%ebx
	jle L2
	testl %esi,%esi
	jge L2
L3:
	movl $-1,%edi
	jmp L5
	.align 2
L2:
	xorl %edi,%edi
L5:
	testl %ebx,%ebx
	jge L6
	pushl 12(%ebp)
	pushl 8(%ebp)
	call ___negdi2
	addl $8,%esp
	movl %eax,8(%ebp)
	movl %edx,12(%ebp)
	movl 12(%ebp),%ebx
L6:
	testl %esi,%esi
	jge L7
	movl  20(%ebp),%edx
	movl  16(%ebp),%eax
	notl	%edx
	negl	%eax
	adcl	$0,%edx
	movl %eax,16(%ebp)
	movl %edx,20(%ebp)
L7:
	movl 8(%ebp),%eax
	movl 16(%ebp),%ecx
	movl %ecx,-4(%ebp)
	testl %ebx,%ebx
	jle L8
	testl %esi,%esi
	jle L8
	movl $2147483647,%ebx
	movl $0,%esi
	jmp L9
	.align 2
L8:
	imull -4(%ebp),%eax
	movl %ebx,%edx
	imull -4(%ebp),%edx
	movl $32,%ecx
	sall %cl,%edx
	leal (%edx,%eax),%eax
	movl -4(%ebp),%edx
	imull %ebx,%edx
	sall %cl,%edx
	leal (%edx,%eax),%eax
	xorl %esi,%esi
	movl %eax,%ebx
	testl %eax,%eax
	jge L9
	notl %esi
L9:
	testl %edi,%edi
	jge L11
	pushl %esi
	pushl %ebx
	call ___negdi2
	movl %eax,%ebx
	movl %edx,%esi
L11:
	movl %ebx,%eax
	leal -16(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	leave
	ret

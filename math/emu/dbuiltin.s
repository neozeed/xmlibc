	.file	"g:/gnu/tmp/dbuiltin.i"
gcc_compiled.:
.text
	.align 2
.globl ___builtin_delete
___builtin_delete:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	testl %eax,%eax
	je L2
	pushl %eax
	call _free
L2:
	leave
	ret
	.align 2
.globl ___builtin_vec_delete
___builtin_vec_delete:
	pushl %ebp
	movl %esp,%ebp
	subl $4,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%esi
	movl 12(%ebp),%edi
	incl %edi
	movl %esi,-4(%ebp)
	movl %edi,%eax
	imull 16(%ebp),%eax
	leal (%eax,%esi),%esi
	xorl %ebx,%ebx
	cmpl %ebx,%edi
	jle L9
L7:
	subl 16(%ebp),%esi
	pushl 28(%ebp)
	pushl %esi
	movl 20(%ebp),%edx
	call *%edx
	addl $8,%esp
	incl %ebx
	cmpl %ebx,%edi
	jg L7
L9:
	cmpl $0,24(%ebp)
	je L8
	pushl -4(%ebp)
	call _free
L8:
	leal -16(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	leave
	ret

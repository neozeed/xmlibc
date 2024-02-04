	.file	"g:/gnu/tmp/vbuiltin.i"
gcc_compiled.:
.globl ___new_handler
.data
	.align 2
___new_handler:
	.long _default_new_handler
.text
	.align 2
.globl ___builtin_vec_new
___builtin_vec_new:
	pushl %ebp
	movl %esp,%ebp
	subl $4,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%esi
	movl 12(%ebp),%edi
	incl %edi
	testl %esi,%esi
	jne L2
	movl %edi,%eax
	imull 16(%ebp),%eax
	pushl %eax
	call ___builtin_new
	movl %eax,%esi
	addl $4,%esp
L2:
	movl %esi,-4(%ebp)
	xorl %ebx,%ebx
	cmpl %ebx,%edi
	jle L7
L6:
	pushl %esi
	movl 20(%ebp),%edx
	call *%edx
	movl 16(%ebp),%edx
	leal (%edx,%esi),%esi
	addl $4,%esp
	incl %ebx
	cmpl %ebx,%edi
	jg L6
L7:
	movl -4(%ebp),%eax
	leal -16(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	leave
	ret
	.align 2
.globl ___set_new_handler
___set_new_handler:
	pushl %ebp
	movl %esp,%ebp
	movl 8(%ebp),%eax
	movl ___new_handler,%edx
	testl %eax,%eax
	jne L9
	movl $_default_new_handler,%eax
L9:
	movl %eax,___new_handler
	movl %edx,%eax
	leave
	ret
	.align 2
.globl _set_new_handler
_set_new_handler:
	pushl %ebp
	movl %esp,%ebp
	pushl 8(%ebp)
	call ___set_new_handler
	leave
	ret
LC0:
	.ascii "default_new_handler: out of memory... aaaiiiiiieeeeeeeeeeeeee!\12\0"
	.align 2
_default_new_handler:
	pushl %ebp
	movl %esp,%ebp
	pushl $65
	pushl $LC0
	pushl $2
	call _write
	pushl $-1
	call __exit
	leave
	ret

	.file	"tmp0001.$$$"
gcc_compiled.:
.text
	.align 4
.globl ___muldi3
___muldi3:
	pushl %ebp
	movl %esp,%ebp
	subl $32,%esp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ecx
	movl 12(%ebp),%ebx
	movl 16(%ebp),%eax
	movl 20(%ebp),%edx
	movl %ebx,-20(%ebp)
	movl %ecx,-24(%ebp)
	movl %edx,-28(%ebp)
	movl %eax,-32(%ebp)
	pushl $8
	pushl $8
	leal -16(%ebp),%eax
	pushl %eax
	leal -32(%ebp),%eax
	pushl %eax
	leal -24(%ebp),%eax
	pushl %eax
	call _bmul
	movl -12(%ebp),%esi
	movl -16(%ebp),%ebx
	movl %ebx,%eax
	movl %esi,%edx
	leal -40(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret
	.align 4
_bmul:
	pushl %ebp
	movl %esp,%ebp
	subl $16,%esp
	pushl %edi
	pushl %esi
	pushl %ebx
	movl 20(%ebp),%esi
	movl %esi,-4(%ebp)
	movl 24(%ebp),%esi
	movl %esi,-8(%ebp)
	movl -4(%ebp),%esi
	movl -8(%ebp),%edx
	leal (%edx,%esi),%eax
	pushl %eax
	pushl $0
	pushl 16(%ebp)
	call _memset
	shrl $1,-4(%ebp)
	shrl $1,-8(%ebp)
	xorl %edi,%edi
	cmpl -8(%ebp),%edi
	jae L12
L10:
	movl 16(%ebp),%esi
	leal (%esi,%edi,2),%esi
	movl %esi,-12(%ebp)
	xorl %ebx,%ebx
	xorl %ecx,%ecx
	cmpl -4(%ebp),%ecx
	jae L11
L9:
	movl 8(%ebp),%esi
	movzwl (%esi,%ecx,2),%eax
	movl 12(%ebp),%esi
	movzwl (%esi,%edi,2),%esi
	movl %esi,-16(%ebp)
	imull %esi,%eax
	movl -12(%ebp),%esi
	movzwl (%esi,%ecx,2),%esi
	movl %esi,-16(%ebp)
	leal (%esi,%eax),%eax
	leal (%eax,%ebx),%ebx
	movl -12(%ebp),%esi
	movw %bx,(%esi,%ecx,2)
	shrl $16,%ebx
	incl %ecx
	cmpl -4(%ebp),%ecx
	jb L9
L11:
	movl -12(%ebp),%esi
	movw %bx,(%esi,%ecx,2)
	incl %edi
	cmpl -8(%ebp),%edi
	jb L10
L12:
	leal -28(%ebp),%esp
	popl %ebx
	popl %esi
	popl %edi
	leave
	ret

	.file	"g:/gnu/tmp/sin.i"
gcc_compiled.:
.text
	.align 4
.globl _sin
_sin:
	pushl %ebp
	movl %esp,%ebp
	subl $84,%esp
	pushl %esi
	pushl %ebx
	movl 8(%ebp),%ecx
	movl 12(%ebp),%ebx
	movl %ecx,-16(%ebp)
	movl %ebx,-12(%ebp)
	pushl $0
	pushl $0
	pushl -12(%ebp)
	pushl -16(%ebp)
	call ___cmpdf2
	addl $16,%esp
	testl %eax,%eax
	jge L2
	movb $-1,-28(%ebp)
	pushl -12(%ebp)
	pushl -16(%ebp)
	call ___negdf2
	addl $8,%esp
	movl %eax,-16(%ebp)
	movl %edx,-12(%ebp)
	jmp L3
	.align 2
L2:
	movb $1,-28(%ebp)
L3:
	pushl $-7
	pushl $1072693248
	pushl $0
	call _ldexp
	addl $12,%esp
	pushl %edx
	pushl %eax
	pushl -12(%ebp)
	pushl -16(%ebp)
	call ___cmpdf2
	addl $16,%esp
	testl %eax,%eax
	jge L4
	movsbl -28(%ebp),%eax
	pushl %eax
	call ___floatsidf
	addl $4,%esp
	pushl -12(%ebp)
	pushl -16(%ebp)
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	movl %eax,%ebx
	movl %edx,%esi
	pushl -12(%ebp)
	pushl -16(%ebp)
	pushl -12(%ebp)
	pushl -16(%ebp)
	call ___muldf3
	addl $16,%esp
	movl %eax,-36(%ebp)
	movl %edx,-32(%ebp)
	pushl $1075314688
	pushl $0
	pushl -32(%ebp)
	pushl -36(%ebp)
	call ___divdf3
	addl $16,%esp
	movl %eax,-44(%ebp)
	movl %edx,-40(%ebp)
	pushl $1077149696
	pushl $0
	pushl -32(%ebp)
	pushl -36(%ebp)
	call ___divdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl -40(%ebp)
	pushl -44(%ebp)
	jmp L10
	.align 2
L4:
	leal -8(%ebp),%eax
	pushl %eax
	pushl $1073291771
	pushl $1413754137
	pushl -12(%ebp)
	pushl -16(%ebp)
	call ___divdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	call _modf
	pushl $1073291771
	pushl $1413754137
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	movl %eax,-24(%ebp)
	movl %edx,-20(%ebp)
	pushl -4(%ebp)
	pushl -8(%ebp)
	call ___fixdfsi
	addl $8,%esp
	movl %eax,%edx
	testl %edx,%edx
	jge L5
	addl $3,%eax
L5:
	andl $-4,%eax
	subl %eax,%edx
	addl $12,%esp
	cmpl $1,%edx
	jle L6
	addl $-2,%edx
	negb -28(%ebp)
L6:
	cmpl $1,%edx
	jne L7
	pushl -20(%ebp)
	pushl -24(%ebp)
	pushl $1073291771
	pushl $1413754137
	call ___subdf3
	addl $16,%esp
	movl %eax,-24(%ebp)
	movl %edx,-20(%ebp)
L7:
	pushl $-3
	pushl $1073291771
	pushl $1413754137
	call _ldexp
	addl $12,%esp
	pushl %edx
	pushl %eax
	pushl -20(%ebp)
	pushl -24(%ebp)
	call ___cmpdf2
	addl $16,%esp
	testl %eax,%eax
	jle L8
	pushl $-2
	pushl -20(%ebp)
	pushl -24(%ebp)
	call _ldexp
	movl %eax,-24(%ebp)
	movl %edx,-20(%ebp)
	pushl -20(%ebp)
	pushl -24(%ebp)
	call _sin
	movl %eax,-8(%ebp)
	movl %edx,-4(%ebp)
	pushl %edx
	pushl %eax
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	call _sqrt
	movl %eax,%ebx
	movl %edx,%esi
	movsbl -28(%ebp),%eax
	pushl %eax
	call ___floatsidf
	addl $4,%esp
	pushl -4(%ebp)
	pushl -8(%ebp)
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	pushl %esi
	pushl %ebx
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	movl %eax,%ebx
	movl %edx,%esi
	pushl -4(%ebp)
	pushl -8(%ebp)
	pushl -4(%ebp)
	pushl -8(%ebp)
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	movl %eax,-52(%ebp)
	movl %edx,-48(%ebp)
	pushl -4(%ebp)
	pushl -8(%ebp)
	pushl -4(%ebp)
	pushl -8(%ebp)
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl -48(%ebp)
	pushl -52(%ebp)
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl %esi
	pushl %ebx
	call ___muldf3
	addl $16,%esp
	movl %eax,-8(%ebp)
	movl %edx,-4(%ebp)
	pushl $2
	pushl %edx
	pushl %eax
	call _ldexp
	jmp L1
	.align 2
L8:
	movsbl -28(%ebp),%eax
	pushl %eax
	call ___floatsidf
	addl $4,%esp
	pushl -20(%ebp)
	pushl -24(%ebp)
	pushl %edx
	pushl %eax
	call ___muldf3
	addl $16,%esp
	movl %eax,%ebx
	movl %edx,%esi
	pushl -20(%ebp)
	pushl -24(%ebp)
	pushl -20(%ebp)
	pushl -24(%ebp)
	call ___muldf3
	addl $16,%esp
	movl %eax,-60(%ebp)
	movl %edx,-56(%ebp)
	pushl $1075314688
	pushl $0
	pushl -56(%ebp)
	pushl -60(%ebp)
	call ___divdf3
	addl $16,%esp
	movl %eax,-68(%ebp)
	movl %edx,-64(%ebp)
	pushl $1077149696
	pushl $0
	pushl -56(%ebp)
	pushl -60(%ebp)
	call ___divdf3
	addl $16,%esp
	movl %eax,-76(%ebp)
	movl %edx,-72(%ebp)
	pushl $1078263808
	pushl $0
	pushl -56(%ebp)
	pushl -60(%ebp)
	call ___divdf3
	addl $16,%esp
	movl %eax,-84(%ebp)
	movl %edx,-80(%ebp)
	pushl $1079115776
	pushl $0
	pushl -56(%ebp)
	pushl -60(%ebp)
	call ___divdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl -80(%ebp)
	pushl -84(%ebp)
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl -72(%ebp)
	pushl -76(%ebp)
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl -64(%ebp)
	pushl -68(%ebp)
L10:
	call ___muldf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl $1072693248
	pushl $0
	call ___subdf3
	addl $16,%esp
	pushl %edx
	pushl %eax
	pushl %esi
	pushl %ebx
	call ___muldf3
L1:
	leal -92(%ebp),%esp
	popl %ebx
	popl %esi
	leave
	ret

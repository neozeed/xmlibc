/* gcc library
*/
.text
	.align 2
.globl ___umulsi3
___umulsi3:
	movl 4(%esp),%eax
	imull 8(%esp),%eax
	ret

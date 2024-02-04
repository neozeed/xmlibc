/* gnu cc library 
	(c) h.yama  1990,
*/
.text
	.align 2
.globl ___xordi3
___xordi3:
	pushl 	%ebp
	movl 	%esp,%ebp
	movl 	 8(%ebp),%eax
	movl 	12(%ebp),%edx
	xorl 	16(%ebp),%eax
	xorl	20(%ebp),%edx
	leave
	ret

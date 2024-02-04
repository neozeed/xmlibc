/* gnu cc library
	(c)  h.yama   1990,
*/

.text
	.align 2
.globl ___negdi2
___negdi2:
	pushl 	%ebp
	movl 	%esp,%ebp
	movl 	8(%ebp),%eax
	movl 	12(%ebp),%edx
	notl	%edx
	negl	%eax
	jnz	.done
	incl	%edx
.done:	
	leave
	ret

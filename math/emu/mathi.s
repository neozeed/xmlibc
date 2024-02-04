/* long long math 	*/

.globl	__adddi3
__adddi3:		/* long long + long long */
	pushl	%ebp
	movl	%esp,%ebp
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	addl	16(%ebp),%eax
	adcl	20(%ebp),%edx
	leave
	ret
		
.globl	__subdi3
__subdi3:
	pushl	%ebp
	movl	%esp,%ebp
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	subl	16(%ebp),%eax
	sbbl	20(%ebp),%edx
	leave
	ret


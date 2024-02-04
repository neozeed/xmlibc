/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-3-8		version 0.41

   Here are commonly called functions
*/
.text
.align  2
.globl	__em_return_0

__em_return_0:
	xorl	%edx,%edx
	xorl	%eax,%eax
	movl	$0xffff8000,%edi
	ret

.globl	__em_return_max
__em_return_max:
	xorl	%edx,%edx
	decl	%edx
	movl	%edx,%eax
	movl	$0x7fff,%edi
	ret

.globl  __em_normalize
__em_normalize:
	testl	%edx,%edx
	jnz	.adjust1
	testl	%eax,%eax
	jz	__em_return_0
	movl	%eax,%edx
	xorl	%eax,%eax
	subl	$32,%edi
.adjust1:
	pushl	%ecx
	bsrl	%edx,%ecx
	notl	%ecx
	andl	$0x01f,%ecx	/* not for shift but substruction */
	shldl	%cl,%eax,%edx
	shll	%cl,%eax
	subl	%ecx,%edi
	popl	%ecx
	ret
	
.globl	__em_assure_dx_ge_bx	/* swap if di.edx:eax < si.ebx:ecx	*/
				/* set Z-flag if  di.edx:eax == si.ebx:ecx */
				/* set carry flag if swap has been done */
.globl	__em_swap		/* swap di.edx:eax with si.ebx:ecx	*/
				
.align 2
__em_assure_dx_ge_bx:	
	cmpl	%esi,%edi	/* exponent is signed		*/
	js	__em_swap_1
	jz	._check_mantissa
	clc
	ret
._check_mantissa:
	cmpl	%ebx,%edx
	jb	__em_swap
	jz	._check_lower
	ret
._check_lower:	
	cmpl	%ecx,%eax
	jb	__em_swap
	ret

.align	2	
__em_swap_1:
	stc
__em_swap:
	xchgl	%esi,%edi
	xchgl	%edx,%ebx
	xchgl	%eax,%ecx
	ret


/***  
   floating point for 80386 (inner use)
   
   (c) h.yama  90-4-4		version 0.4
   
 ***/   

.text
	.align 2
.globl __em_ffrac
__em_ffrac:			/* get fract part from di.edx:eax	*/
	btl	$31,%edi	/* keep all registers other than edi.edx:eax */
	jc	.do_non
	cmpl	$63,%edi
	jae	__em_return_0
._frac1:
	incl	%edi
	jz	.frac_exact
	pushl	%ecx
	movl	%edi,%ecx
	cmpl	$32,%ecx
	jb	._flacs1
	movl	%eax,%edx	/* more than 32 bit shift */
	xorl	%eax,%eax
._flacs1:	
	shldl	%cl,%eax,%edx
	shll	%cl,%eax
	popl	%ecx
	xorl	%edi,%edi
.frac_exact:	
	decl	%edi
	jmp	__em_normalize
.do_non:
	ret

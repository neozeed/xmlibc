/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-10		version 0.5

   em	__em_ffloat(float)	single -> inner expression
   em	__em_fdouble(double)	double -> inner expression
   em	__em_flac(em)		return frac
   em	__em_int(em)		return int
   em	__em_mulu(em,em)	multiply
   em	__em_divu(em,em)	divide
   em	__em_addu(em,em)	add
   em	__em_subu(em,em)	sub
   em	__em_sqrt(em)		squere root
  
 ***/   

# For towns.
.text
	.align 2
.globl	__em_laddu,__em_lsubu
__em_laddu:		/* di.edx:eax <- di.edx:eax - si.ebx:ecx  */ 
	call	__em_assure_dx_ge_bx
	jnz	._ladd
	incl	%edi		/* input di.edx:eax == si.ebx:ecx */
._do_non:	
	ret
.emadds:
	xchgl	%esi,%edi
	xchgl	%edx,%ebx
	xchgl	%eax,%ecx
._ladd:
	call	__em_ladjust_exp
	ja	._do_non
._do_add:	
	addl	%ecx,%eax
	adcl	%ebx,%edx	/* do long addition		*/
	jnc	._addx:
	rcrl	$1,%edx		/* take in carry		*/
	rcrl	$1,%eax
	incl	%edi		/* adjust exponent		*/
._addx:	
	ret


__em_lsubu:		/* di.edx <- di.edx:eax + si.ebx:ecx */
	call	__em_assure_dx_ge_bx
	jz	__em_return_0
	pushl	$0	
	jnc	._positive	/* carry flag means result sign	*/
	movl	$0x80000000,0(%esp)
._positive:	
	call	__em_ladjust_exp
	popl	%esi		/* esi means result sign */
	ja	._do_non
._lsub:	
	subl	%ecx,%eax
	sbbl	%ebx,%edx	/* do substruction	*/
	jmp	__em_normalize
	ret


__em_ladjust_exp:
	pushl	%edi
	
	subl	%esi,%edi	/* patch on 4-7	*/
	jz	._adj_non
	cmpl	$63,%edi
	jbe	._adj0
	xorl	%ebx,%ebx
	xorl	%ecx,%ecx
	jmp	._adj_over
._adj0:
	cmpl	$32,%edi
	jb	._adj1
	movl	%ebx,%ecx
	xorl	%ebx,%ebx
._adj1:	
	xchgl	%edi,%ecx	
	shrdl	%cl,%ebx,%edi
	shrl	%cl,%ebx	
	xchgl	%edi,%ecx
	stc
._adj_over:	
._adj_non:	
	
	popl	%edi
	ret
	
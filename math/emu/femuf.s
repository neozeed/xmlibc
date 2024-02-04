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
.globl	__em_sqrt
__em_sqrt:		/* di.edx <- sqroot( di.edx:eax )	*/
	call	__em_normalize
	testl	%edx,%edx
	jz	__em_return_0
	pushl	%ebp
	xorl	%ebp,%ebp
	incl	%edi
	btl	$0,%edi
	jnb	.emsq1
				/* odd exponent		*/
	decl	%edi
	addl	%eax,%eax
	adcl	%edx,%edx
	adcl	%ebp,%ebp
.emsq1:	
	sarl	$1,%edi		/* get exponent		 */
/*
	our algolithm is of ancient Japanese method
*/	
	xorl	%ebx,%ebx	/* EBX:work  ESI:result */
	xorl	%esi,%esi
	movl	$30,%ecx	/* n-2 bits accuracy 	*/
.emsq2:				/* start	 	*/
	addl	%esi,%esi	/* do 1 bit by 1 bit	*/
	addl	%ebx,%ebx
	cmpl	%ebx,%ebp
	jna	.emsq3
	incl	%ebx
	subl	%ebx,%ebp
	incl	%esi
	incl	%ebx
.emsq3:	
	shldl	$2,%edx,%ebp
	shldl	$2,%eax,%edx
	shll	$2,%eax
	loop	.emsq2
	
	popl	%ebp	
/*
	here eax == 0  because of 60 bit shift
*/
	movl	%esi,%edx	/* normalize	 */
	addl	%edx,%edx
	incl	%edi		/* adjust exponent */
	testl	%edx,%edx
	jz	__em_return_0
.emsq4:	
	decl	%edi
	addl	%edx,%edx
	btl	$31,%edx
	jnb	.emsq4
.emsqx:
	ret
	

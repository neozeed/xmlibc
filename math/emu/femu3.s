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
.globl	__em_lmulu,__em_ldivu
__em_lmulu:		/* di.edx:eax <- di.edx:eax * si.ebx:ecx  */ 
	addl	%esi,%edi	
	incl	%edi
	pushl	%eax
	orl	%edx,%eax
	popl	%eax
	jz	__em_return_0
	pushl	%ecx
	orl	%ebx,%ecx
	popl	%ecx
	jz	__em_return_0
	pushl	%edi	/* edx:eax <- (edx*ebx + eax*ebx + edx*ecx)*/	
	pushl	%edx	/* use edx:edi:esi as  accumulator		*/
	mull	%ebx		/* eax*ebx 	*/
	movl	%edx,%edi
	movl	%eax,%esi
	popl	%eax
	pushl	%ecx
	
	pushl	%eax
	mull	%ecx		/*  edx*ecx	*/
	movl	$0,%ecx
	addl	%eax,%esi
	adcl	%edx,%edi
	rcll	$1,%ecx		/* carry status */
	popl	%eax
	
	mull	%ebx		/* edx*ebx	*/
	btl	$31,%esi
	adcl	%edi,%eax
	adcl	%ecx,%edx
	popl	%ecx		/* recover ecx	*/
	
	popl	%edi		/* recover exponent	 */
	jmp	__em_normalize
	ret
	
	.align 2
__em_ldivu:		/* di.edx <- di.edx:eax / si.ebx:ecx */
	subl	%esi,%edi	
	decl	%edi
	pushl	%edx
	orl	%eax,%edx
	popl	%edx
	jz	__em_return_0	/* 0 /someting		*/
/* 
	in case higher word is zero, move from lower word,
	though such case is not expected.
*/
	orl	%ebx,%ebx
	jnz	.__em_divn
	xchgl	%ecx,%ebx
	addl	$32,%edi		/* adjust exponent */
.__em_divn:	
	orl	%ebx,%ebx
	jz	__em_return_max		/* divide by 0 error */

.emldiv1:
	btl	$31,%ebx
	jb	.emldiv2
	shldl	$1,%ecx,%ebx
	shll	$1,%ecx
	incl	%edi		
	jmp	.emldiv1
.emldiv2:
	cmpl	%edx,%ebx	/* avoid overflow	*/
	ja	.emldiv3
	incl	%edi
	shrdl	$1,%edx,%eax
	shrl	$1,%edx
.emldiv3:	
	pushl	%edi		/* keep exponent	*/
/* 
	here, we use approximation (A+a)/(B+b) where A/a , B/b overs 2**30
	such that
  	(A+a)/(B+b) -> (A+a)/B * 1/(1 + b/B) 	-> (A+a)/B * (1 - b/B)
			-> A/B + a/B - Ab/BB	-> [A + (a - Ab/B)]/B	
	Be careful that (A,a) = (EDX,EAX), (B,b) = (EBX,ECX)
*/
	pushl	%edx
	pushl	%eax
	movl	%edx,%eax
	mull	%ecx		/* Ab 		*/
	divl	%ebx		/* Ab/B	overflow is not expected*/
	movl	%eax,%edx
	popl	%eax		/* a		*/
	subl	%edx,%eax	/* a - Ab/B	*/
	popl	%edx		
	sbbl	$0,%edx		/*[A + (a - Ab/B)]*/
	divl	%ebx		/*  [   ]/B	*/
	pushl	%eax		
	xorl	%eax,%eax	/* to keep accuracy	*/
	divl	%ebx
	popl	%edx		
	popl	%edi		/* recover exponent	*/
	jmp	__em_normalize	
.__em_divx:
	ret

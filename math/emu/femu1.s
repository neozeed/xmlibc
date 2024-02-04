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
.globl	__em_mulu,__em_divu
__em_mulu:			/* di.edx:eax <- di.edx * si.ebx  */ 
	addl	%esi,%edi	/* add exponent			*/
	incl	%edi		/* mantissa ranges  1.0 ..to.. 2.0-epsiron */
				/* so exponent++ as result	*/
	orl	%edx,%edx	/* either of input was zero ?	*/
	jz	__em_return_0
	orl	%ebx,%ebx
	jz	__em_return_0
	movl	%edx,%eax
	mull	%ebx		/* do multiply	*/
	jmp	__em_normalize
	ret
	
	.align 2
__em_divu:			/* di.edx <- di.edx:eax / si.ebx */
	subl	%esi,%edi	/* substruct exponent		*/
	decl	%edi		/* 'cause mantissa  >= 1.0	*/
	andl	$0x7fffffff,%edx
	jz	__em_return_0	/* 0/ someting		*/
	andl	$0x7fffffff,%ebx
	jz	__em_return_max	/* divide by 0 error 	*/
	cmpl	%ebx,%edx	/* avoid overflow 	*/
	jb	.emdiv1
	incl	%edi
	shrl	$1,%edx		/* assure that [edx < ebx ] */
.emdiv1:	
	divl	%ebx		/*  [   ]/B	*/
	pushl	%eax		
	xorl	%eax,%eax	/* to keep accuracy	 */
	divl	%ebx
	popl	%edx		
	jmp	__em_normalize
.__em_divx:
	ret


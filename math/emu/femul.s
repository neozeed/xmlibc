/***  
   floating point for 80386 (inner use)
   
		90-4-5		version 0.4
   by   h.yama  90-3-8		version 0.3
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
.globl	__em_2double,__em_fdouble
				/* di.edx:eax --> double edx:eax@*/ 
__em_2double:			/* used registers areCedi.edx:eax ecx */
	call	__em_normalize
	testl	%edx,%edx
	jz	._return	/* input was zero */
/*_round_up:	*/
	addl	$0x200,%eax	/* carry from lower bits	*/
	adcl	$0,%edx
	jc	._get_exponent  
._kill_hidden_bit:	
	rcll	$1,%eax
	rcll	$1,%edx
	decl	%edi
._get_exponent:	
	incl	%edi
	addl	$0x3ff,%edi		/* offset to exponent */
	js	._denormal		/* patch on 4-5 */

	cmpl	$0x07ff,%edi		/* was 0x800	*/
	jae	._overflow
._shift_exponent_in:	
	shrdl	$12,%edx,%eax		/* shift in exponent	*/
	shrdl	$12,%edi,%edx
	btrl	$31,%edx		/* result > 0		*/
._return:
	ret

._denormal:
/* return (double) 0 */	
/*	addl	$52,%edi
	jbe	._double_zero
	addl	$12,%edi
	negl	%edi
	
	pushl	%ecx
	xchg	%edi,%ecx
	cmpl	$32,%ecx
	jae	._small
	movl	%edx,%eax
	xorl	%edx,%edx
._small:
	shrdl	%cl,%edx,%eax
	shrl	%cl,%edx
	xchgl	%edi,%ecx
	popl	%ecx
	ret
*/
._double_zero:	
	xorl	%edx,%edx
	xorl	%eax,%eax
	ret

._overflow:
/* return (double) max */
	movl	$0x7ff00000,%edx	/* overflow ! 	*/
	xorl	%eax,%eax
	ret

__em_fdouble:			/* (doulbe) edx:eax --> (em) di.edx:eax */
	btrl	$31,%edx	/* only positive	*/
	pushl	%eax		/* was 0		*/
	orl	%edx,%eax
	popl	%eax
	jz	__em_return_0
	xorl	%edi,%edi
	shldl	$12,%edx,%edi
	shldl	$12,%eax,%edx
	shll	$12,%eax
	stc
	rcrl	$1,%edx		/* hidden bit --> MSB of edx	*/
	rcrl	$1,%eax
	subl	$0x3ff,%edi	/* offset of exponent		*/
	ret


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
.globl	__em_2float,__em_ffloat
				/* di.edx:eax  --> single eax@	*/ 
__em_2float:			/* used only edi.edx:eax,ecx 	*/
	call	__em_normalize
	orl	%edx,%edx
	jz	.do_non
	
	addl	$0x040,%edx
	jnc	.__emx1
	rcrl	$1,%edx
	incl	%edi
.__emx1:	
	shll	$1,%edx			/* erase hidden bit	*/
	movl	%edx,%eax		/* result -->  eax	*/
	addl	$0x7f,%edi		/* offset to exponent	*/
	js	._s_denormal		/* patch on 4-5	*/
	
	cmpl	$0xff,%edi		/* was 0x100		*/
	jae	._s_infinit
	shrdl	$9,%edi,%eax
	btrl	$31,%eax
.do_non:
	ret
._s_infinit:
	movl	$0x7f800000,%eax
	ret
._s_denormal:	
/*	shrl	$9,%eax		*/
	xorl	%eax,%eax
	ret

__em_ffloat:			/* (single)eax --> (em) di.edx:eax */
	xorl	%edi,%edi
	btrl	$31,%eax	/* only positive		*/
	test	%eax,%eax	/* !!0	*/
	jz	__em_return_0
	shldl	$9,%eax,%edi	/* get exponent		*/
	shll	$9,%eax
	subl	$0x7f,%edi	/* offset to exponent	*/
	stc
	rcrl	$1,%eax		/* hidden bit -->  MSB of edx	*/
	movl	%eax,%edx
	xorl	%eax,%eax
	ret


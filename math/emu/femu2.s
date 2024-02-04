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

.text
	.align 2
.globl	__em_addu,__em_subu
		
__em_addu:		/* di.edx <- di.edx + si.ebx		*/
			/* let's assure  di.edx > si.ebx	*/
	call	__em_assure_dx_ge_bx
	jnz	._adjust_exponent
	incl	%edi
	ret
._adjust_exponent:
	movl	%edi,%ecx	
	subl	%esi,%ecx
	jz	._add
	cmpl	$31,%ecx	
	ja	._do_non
	shrl	%cl,%ebx
._add:
	addl	%ebx,%edx	
	jnc	._do_non
	rcrl	$1,%edx		/* take over_flow in	*/
	incl	%edi		/* adjust exponent	*/
._do_non:
	ret

__em_subu:			/* di.edx <- di.edx - si.ebx	*/
	call	__em_assure_dx_ge_bx
	jz	__em_return_0
	pushl	$0		/* this word keeps +/- flag	*/
	jnc	._s_adjust_exponent
				/* carry flag means result sign	*/
	movl	$0x80000000,0(%esp)	
._s_adjust_exponent:
	movl	%edi,%ecx	
	subl	%esi,%ecx
	popl	%esi		/* esi keeps result sign	*/
	jz	._sub
	cmpl	$31,%ecx	
	ja	._sub_non
	shrl	%cl,%ebx
._sub:
	subl	%ebx,%edx	/* result must be >= 0		*/
	jz	__em_return_0	
	jmp	__em_normalize
._sub_non:
	ret

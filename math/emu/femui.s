/***  
   floating point for 80386 (inner use)
   
   (c) h.yama  90-3-8		version 0.3
   
 ***/   

.text
	.align 2
.globl	__em_2long,__em_flong,__em_2ulong
				/* di.edx:eax -> long long edx:eax@*/ 
__em_2long:			/*used:Cedi.edx:eax ecx */
__em_2ulong:			/* intermediate -> unsigned long long  */
	testl	%edi,%edi
	js	.em2lz
	cmpl	$64,%edi
	jae	.em2la1
	movl	$63,%ecx
	subl	%edi,%ecx
;
	andl	$63,%ecx	/* HOW MANY BITS TO SHIFT 	*/
	cmpb	$32,%cl
	jb	.em2le		/* more than or equal to 32 bit	*/
	movl	%edx,%eax
	xorl	%edx,%edx
.em2le:
	shrdl	%cl,%edx,%eax
	shrl	%cl,%edx
	ret	
.em2la1:
	movl	$-1,%edx
	movl	%edx,%eax
	ret
#.em2la1:			/* too large value on input 	*/
#	pushl	$9911
#.em2lax:	
#	call	__em_error
#	call	__error
#	addl	$4,%esp
#	ret
.em2lz:
	xorl	%edx,%edx
	xorl	%eax,%eax
	ret

__em_flong:			/* long long edx:eax --> (em) di.edx:eax */
	pushl	%eax		/* was 0	*/
	orl	%edx,%eax
	popl	%eax
	jz	__em_return_0
	
	testl	%edx,%edx
	jns	.emfli1		/* positive only	*/
	notl	%edx
	negl	%eax
	jnz	.emfli1
	incl	%edx
.emfli1:	
	movl	$32,%edi	/* exponent		*/
	testl	%edx,%edx
	jnz	.emfli4
	xchgl	%eax,%edx
	subl	$32,%edi
.emfli4:			/* when edx != 0		*/
	bsrl	%edx,%ecx
	addl	%ecx,%edi
	notl	%ecx
	shldl	%cl,%eax,%edx
	shll	%cl,%eax
	ret


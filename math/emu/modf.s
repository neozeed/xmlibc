/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl _modf		/* splits into integer and fraction */
_modf:			
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	
	movl	8(%ebp),%eax	/* convert to inner expression */
	movl	12(%ebp),%edx
	
	call	__em_fdouble
	movl	%edi,%esi	/* keep it */
	movl	%edx,%ebx
	movl	%eax,%ecx
	call	__em_ffrac
	xchgl	%edi,%esi	/* fract -> si.bx:cx */
	xchgl	%edx,%ebx
	xchgl	%eax,%ecx
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	call	__em_lsubu
	call	__em_2double		
	movl	16(%ebp),%esi
	movl	%eax,0(%esi)	/* store integer part */
	movl	%edx,4(%esi)
	popl	%eax
	popl	%edx
	popl	%edi
	call	__em_2double	/* return fractal part */
	btl	$31,12(%ebp)	/* was negative ? */
	jnc	._modp
	btsl	$31,%edx	/* return negative value */
	btsl	$31,4(%esi)
._modp:	
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret


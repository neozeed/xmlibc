/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl _ffrac		/*get fract part from double */
_ffrac:			
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	
	movl	8(%ebp),%eax	/* convert to inner expression */
	movl	12(%ebp),%edx
	
	call	__em_fdouble
	call	__em_ffrac
	call	__em_2double		
	btl	$31,12(%ebp)	/* was negative ? */
	jnc	._flacp
	btsl	$31,%edx	/* return negative value */
._flacp:	
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret


/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl _ffracs		/*get fract part from single */
_ffracs:			
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	
	movl	8(%ebp),%eax	/* convert to inner expression */
	
	call	__em_ffloat
	call	__em_ffrac
	call	__em_2float		
	btl	$31,8(%ebp)	/* was negative ? */
	jnc	._fracp
	btsl	$31,%eax	/* return negative value */
._fracp:	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret


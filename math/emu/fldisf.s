/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___floatdisf		/* long longを単精度浮動小数 */
___floatdisf:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	call	__em_flong
	call	__em_2float	/* 符号ビットは元のものを保存する */
	btl	$31,12(%ebp)
	jnb	.fdx
	btsl	$31,%eax		
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
	


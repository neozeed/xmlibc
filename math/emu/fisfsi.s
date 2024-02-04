/***  
   floating point for 80386 
   
   (c) h.yama  90-3-8		version 0.3
   
 ***/   
.text
	.align 2
/*.extern	_ferror */
.globl	___fixsfsi		/* 単精度浮動小数を longに */
___fixsfsi:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax
	call	__em_ffloat
	call	__em_2long	
	btl	$31,%eax
	jc	.fdx0
	testl	%edx,%edx
	jz	.fdx1
.fdx0:	
	movl	$0x7fffffff,%eax
.fdx1:	
	btl	$31,8(%ebp)	/* 符号ビットは元のものを保存する */
	jnb	.fdx
	negl	%eax		
.fdx:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret


/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 4
.globl ___extendsfdf2
___extendsfdf2:			/*単精度から倍精度に変換する */
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	
	movl	8(%ebp),%eax	/* 一度中間形式に変換して	*/
	call	__em_ffloat
	call	__em_2double	/* 倍精度に変換する		*/
	btl	$31,8(%ebp)	/* 元の値の符号ビットを保存する	*/
	jnb	.extdf1
	btsl	$31,%edx
.extdf1:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret


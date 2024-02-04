/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text                                   
	.align 2
.globl _sqrts
_sqrts:				/* 単精度からの平方根 */
	pushl %ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	movl	8(%ebp),%eax	
	testl	%eax,%eax
	jz	.sqrx		/* 0に対しては0を返す*/
	js	.sqre		/* 負の値に対しては エラー処理*/
	call	__em_ffloat	/*まず中間形式に直す */	
	call	__em_sqrt	/* 開平を実行	*/
	call	__em_2float
.sqrx:	
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret
.sqre:
	pushl	$9910		/* 負の値に対するエラー処理*/
	call	__em_error	/* em_errorを呼んで	*/
	popl	%eax
	xorl	%eax,%eax	/* 0を返す		*/
	jmp	.sqrx



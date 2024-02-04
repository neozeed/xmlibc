/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3
	h.yama  90-4-10		version 0.5

 ***/   
.text                                   
	.align 2
.globl _sqrt
_sqrt:				/* 倍精度からの平方根 */
	pushl %ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl	%ecx
	pushl 	%esi
	pushl 	%edi

	movl	8(%ebp),%eax
	movl	12(%ebp),%edx	
	testl	%edx,%edx
	jz	.sqrx		/* was 0	*/
	js	.sqre		/* negative value	*/
	call	__em_fdouble	/*			*/	
	
	pushl	%edi
	pushl	%edx
	pushl	%eax
	call	__em_sqrt	/* 			*/
	movl	%eax,%ecx
	movl	%edx,%ebx
	movl	%edi,%esi
	popl	%eax
	popl	%edx
	popl	%edi
	
	pushl	%esi
	pushl	%ebx
	pushl	%ecx
	call	__em_ldivu
	popl	%ecx
	popl	%ebx
	popl	%esi
	call	__em_laddu
	decl	%edi
	call	__em_2double

.sqrx:	
	popl 	%edi
	popl 	%esi
	popl	%ecx
	popl 	%ebx
	leave
	ret
.sqre:
	pushl	$9910		/* 負の値に対するエラー処理*/
	call	__em_error	/* em_errorを呼んで	*/
	popl	%eax
	xorl	%eax,%eax	/* 0を返す		*/
	movl	%eax,%edx
	jmp	.sqrx



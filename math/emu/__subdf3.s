/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl ___subdf3
___subdf3:			/*倍精度の減算	*/
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl	%ecx
	pushl 	%esi
	pushl 	%edi
	
	movl	16(%ebp),%eax	/* 引き数をどちらとも中間形式に直しておく */
	movl	20(%ebp),%edx
	call	__em_fdouble
	movl	%eax,%ecx
	movl	%edx,%ebx
	movl	%edi,%esi
	movl	8(%ebp),%ax	/* 第二引き数		*/
	movl	12(%ebp),%edx
	call	__em_fdouble	/* edi.edx:eax - esi.ebx:ecx をやる*/
	
	btl	$31,12(%ebp)	/* A ≧ 0 */
	jb	.fsub3
	btl	$31,20(%ebp)		/* B ≧ 0 */
	jb	.fsub2
	call	__em_lsubu
	jmp	.fsub4x
.fsub2:
	call	__em_laddu		/* B ≦ 0 */
	call	__em_2double
	jmp	.fsubx2
.fsub3:				/* A ≦ 0 */
	btl	$31,20(%ebp)		/* B ≧ 0 */
	jb	.fsub4
	call	__em_laddu
	call	__em_2double
	btsl	$31,%edx		/* 符号を負にする*/
	jmp	.fsubx2
.fsub4:
	xchgl	%eax,%ecx
	xchgl	%edx,%ebx
	xchgl	%edi,%esi
	call	__em_lsubu		/* B ≦ 0 */
.fsub4x:	
	call	__em_2double
	orl	%esi,%edx
.fsubx2:
	popl 	%edi
	popl 	%esi
	popl	%ecx
	popl 	%ebx
	leave
	ret


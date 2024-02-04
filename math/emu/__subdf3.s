/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl ___subdf3
___subdf3:			/*”{¸“x‚ÌŒ¸Z	*/
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl	%ecx
	pushl 	%esi
	pushl 	%edi
	
	movl	16(%ebp),%eax	/* ˆø‚«”‚ğ‚Ç‚¿‚ç‚Æ‚à’†ŠÔŒ`®‚É’¼‚µ‚Ä‚¨‚­ */
	movl	20(%ebp),%edx
	call	__em_fdouble
	movl	%eax,%ecx
	movl	%edx,%ebx
	movl	%edi,%esi
	movl	8(%ebp),%ax	/* ‘æ“ñˆø‚«”		*/
	movl	12(%ebp),%edx
	call	__em_fdouble	/* edi.edx:eax - esi.ebx:ecx ‚ğ‚â‚é*/
	
	btl	$31,12(%ebp)	/* A † 0 */
	jb	.fsub3
	btl	$31,20(%ebp)		/* B † 0 */
	jb	.fsub2
	call	__em_lsubu
	jmp	.fsub4x
.fsub2:
	call	__em_laddu		/* B … 0 */
	call	__em_2double
	jmp	.fsubx2
.fsub3:				/* A … 0 */
	btl	$31,20(%ebp)		/* B † 0 */
	jb	.fsub4
	call	__em_laddu
	call	__em_2double
	btsl	$31,%edx		/* •„†‚ğ•‰‚É‚·‚é*/
	jmp	.fsubx2
.fsub4:
	xchgl	%eax,%ecx
	xchgl	%edx,%ebx
	xchgl	%edi,%esi
	call	__em_lsubu		/* B … 0 */
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


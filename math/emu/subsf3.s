.text
	.align 4
.globl ___subsf3
___subsf3:			/*’P¸“x‚ÌŒ¸Z	*/
	pushl 	%ebp
	movl 	%esp,%ebp
	pushl 	%ebx
	pushl 	%esi
	pushl 	%edi
	pushl	%ecx
	pushl	%edx
	
	movl	12(%ebp),%eax	/* ˆø‚«”‚ğ‚Ç‚¿‚ç‚Æ‚à’†ŠÔŒ`®‚É’¼‚µ‚Ä‚¨‚­ */
	call	__em_ffloat
	movl	%edx,%ebx
	movl	%edi,%esi
	movl	8(%ebp),%ax
	call	__em_ffloat	/* edi.edx - esi.ebx ‚ğ‚â‚ê‚Î‚¢‚¢	*/
	
	btl	$31,8(%ebp)	/* A † 0 */
	jb	.fsub3
	btl	$31,12(%ebp)		/* B † 0 */
	jb	.fsub2
	call	__em_subu
	jmp	.fsub4x
.fsub2:
	call	__em_addu		/* B … 0 */
	call	__em_2float
	jmp	.fsubx2
.fsub3:				/* A … 0 */
	btl	$31,12(%ebp)		/* B † 0 */
	jb	.fsub4
	call	__em_addu
	call	__em_2float
	btsl	$31,%eax
	jmp	.fsubx2
.fsub4:
	xchgl	%edx,%ebx
	xchgl	%edi,%esi
	call	__em_subu		/* B … 0 */
.fsub4x:	
	call	__em_2float
	orl	%esi,%eax
.fsubx2:
	popl	%edx
	popl	%ecx
	popl 	%edi
	popl 	%esi
	popl 	%ebx
	leave
	ret


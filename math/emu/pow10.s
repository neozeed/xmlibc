/***  
   floating point for 80386 (inner use)
   
   by   h.yama  90-4-9		version 0.4

   _pow10(double x , int #)  returns  x * 1e#
   pow10( int #) returns 1e#
*/

.data
c1e20:	
	.long	0xac620000		/* value of 1e20 inner expression */
	.long	0xad78ebc5
	.long	0x42
.double
.text
.globl	_pow10,__pow10
_pow10:
	push	%ebp
	movl	%esp,%ebp
	pushl	8(%ebp)
	pushl	$0x3ff00000		/* double 1 */
	pushl	$0
	call	__pow10
	leave
	ret

.align 2
__pow10:		
	pushl	%bp
	movl	%esp,%ebp
	push	%esi
	push	%edi
	push	%ecx
	push	%ebx
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	call	__em_fdouble
	movl	16(%ebp),%ecx
	btl	$31,%ecx
	jnc	.up				/* # >= 0	*/
.down:
	cmpl	$-310,%ecx
	jbe	.too_small
	negl	%ecx
.divide1:	
	cmpl	$20,%ecx
	jbe	.divide
	subl	$20,%ecx
	pushl	%ecx
	movl	c1e20,%ecx
	movl	c1e20+4,%ebx
	movl	c1e20+8,%esi
	call	__em_ldivu
	popl	%ecx
	jmp	.divide1
.divide:
	pushl	%ecx
	movl	$3,%esi
	movl	$0xa0000000,%ebx		/* double 10 */
	xorl	%ecx,%ecx
	call	__em_ldivu
	popl	%ecx
	loop	.divide
	jmp	.done
.up:	
	cmpl	$310,%ecx
	jae	.too_large
	orl	%ecx,%ecx
	jz	.done
.multiply1:	
	cmpl	$20,%ecx
	jbe	.multiply
	subl	$20,%ecx
	pushl	%ecx
	movl	c1e20,%ecx
	movl	c1e20+4,%ebx
	movl	c1e20+8,%esi
	call	__em_lmulu
	popl	%ecx
	jmp	.multiply1
.multiply:	
	pushl	%ecx
	movl	$3,%esi
	movl	$0xa0000000,%ebx		/* double 10 */
	xorl	%ecx,%ecx
	call	__em_lmulu
	popl	%ecx
	loop	.multiply
.done:
	call	__em_2double
.done1:
	shll	$1,%edx
	btl	$31,12(%ebp)
	rcrl	$1,%edx
.done2:	
	popl	%ebx
	popl	%ecx
	popl	%edi
	popl	%esi
	leave
	ret
.too_large:
	movl	$-1,%edx
	movl	$-1,%eax
	jmp	.done1
.too_small:
	xorl	%edx,%edx
	xorl	%eax,%eax
	jmp	.done1

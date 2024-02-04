/*** 
	library program for GCC on DOS-Extender
	
	(c) kay & h.yama  1989,90		ver 0.92

*/
.text

.align	2
.globl	__setdta
/*void setdta( char *buf, size_t size) */
__setdta:
	pushl	%ebp
	movl	%esp,%ebp
	pushal
	pushl	%es

	movb	$0x2f,%ah
	intl	$0x21
	movl	%ebx,%edi
	movl	8(%ebp),%esi
	movl	12(%ebp),%ecx
	rep  
	movsb
	
	popl	%es
	popal	
	leave
	ret


/*** 
	library program for GCC on DOS-Extender
	
	(c) kay & h.yama  1989,90		ver 0.92

*/
.text
.align	2
.globl	__getdta
/*void getdta( char *buf, size_t size) */
__getdta:
	pushl	%ebp
	movl	%esp,%ebp
	pushal
	pushl	%es
	pushl	%ds

	movb	$0x2f,%ah
	intl	$0x21
	movl	%ebx,%esi
	pushl	%es
	popl	%ds
	movl	8(%ebp),%edi
	movl	12(%ebp),%ecx
	popl	%es
	pushl	%es
	rep  
	movsb
	
	popl	%ds
	popl	%es
	popal	
	leave
	ret


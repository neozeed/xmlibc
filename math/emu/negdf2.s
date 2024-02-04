/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl ___negdf2
___negdf2:
	pushl 	%ebp
	movl 	%esp,%ebp
	movl  	8(%ebp),%eax
	movl	12(%ebp),%edx
	xorl	$0x80000000,%edx
	leave
	ret


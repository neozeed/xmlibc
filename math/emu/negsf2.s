/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align 2
.globl ___negsf2
___negsf2:
	pushl %ebp
	movl %esp,%ebp
	movl  8(%ebp),%eax
	xorl  $0x80000000,%eax
	leave
	ret


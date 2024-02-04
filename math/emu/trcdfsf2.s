/***  
   floating point for 80386 , GCC
   
   (c)  h.yama  90-3-8		version 0.3

 ***/   
.text
	.align	2
.globl ___truncdfsf2
___truncdfsf2:
	pushl	%ebp
	movl	%esp,%ebp
	pushl	%ebx
	pushl	%ecx
	pushl	%edi
	movl	8(%ebp),%eax
	movl	12(%ebp),%edx
	call	__em_fdouble	/* 一度中間形式にして，	*/
	call	__em_2float	/* あらためて，単精度にする	*/
	btl	$31,12(%ebp)
	jnb	.trunc1
	btsl	$31,%eax
.trunc1:	
	popl	%edi
	popl	%ecx
	popl	%ebx
	leave
	ret
		


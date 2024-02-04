/* double add/sub/neg function
	v 0.2        1990-7-09 elfin  bugfix(detected by Mr. BUTCH)
	v 0.1  begin 1990-6-23 elfin (Nifty Serve)
*/

.text
.globl	___adddf3
.globl	___subdf3

	.align	2
___adddf3:
	enter	$8, $0
	push	%ebx
	push	%edi
	push	%esi

	xorl	%eax, %eax
	xorl	%edi, %edi
	xorl	%esi, %esi
	movl	%eax, -4(%ebp)	/* assume the answer is positive */
	movl	12(%ebp), %edx	/* High digit of A */
	movl	20(%ebp), %ebx	/* High digit of B */
	btrl	$31,%edx	/* sign bit of A */
	jc	aA_is_negative
	btrl	$31, %ebx	/* sign bit of B */
	jc	AminusB
	jmp	AplusB
aA_is_negative:
	btrl	$31, %ebx	/* A <0, B ?? */
	jnc	BminusA
aA_and_B_are_negative:		/* both A and B are < 0 */
	btsl	$31, -4(%ebp)	/* default sign is '-' */
	jmp	AplusB

	.align	2
___subdf3:
	enter	$8, $0
	push	%ebx
	push	%edi
	push	%esi

	xorl	%eax, %eax
	xorl	%edi, %edi
	xorl	%esi, %esi
	movl	%eax, -4(%ebp)	/* assume result >= 0 */
	movl	12(%ebp), %edx	/* High order of A */
	movl	20(%ebp), %ebx	/* High order of B */
	btrl	$31, %edx
	jc	sA_is_negative
	btrl	$31, %ebx
	jc	AplusB
	jmp	AminusB
sA_is_negative:
	btrl	$31, %ebx	/* B >0 ?? */
	jc	BminusA
	jmp	aA_and_B_are_negative

AplusB:				/* both A and B are positive */
/* assure dx > bx */	
	cmpl	%ebx, %edx	/* A >= B ? */
	jge	ladd0
	xchgl	%ebx, %edx	
	movl	16(%ebp), %eax
	shldl	$12, %edx, %edi	/* edi <- exponent */
	shldl	$11, %eax, %edx	/* edx:eax <<	x*/
	shll	$11, %eax
	movl	%eax, -8(%ebp)	/* Store lower order of A */
	movl	8(%ebp), %eax	/* get lower order of B into eax */
	jmp	ladd1
ladd0:
	movl	8(%ebp), %eax
	shldl	$12, %edx, %edi	
	shldl	$11, %eax, %edx	
	shll	$11, %eax
	movl	%eax, -8(%ebp)	
	movl	16(%ebp), %eax	
ladd1:	
	testl	%edi, %edi	/* greater == 0, answer= 0 */
	jz	retZ
	orl	$0x80000000, %edx	/* hidden bit of A  */
	shldl	$12, %ebx, %esi	/* exponent --> esi */
	shldl	$11, %eax, %ebx	
	shll	$11, %eax
	orl	$0x80000000, %ebx	/* hidden bit of B */
/* */	
	movl	%edi, %ecx
	subl	%esi, %ecx	
	cmpl	$64, %ecx
	jge	retA		/* 差が64以上なら, 計算不要 */
	btl	$5, %ecx	/* 32ビット以上のシフトか？ */
	jnc	ladd2
	movl	%ebx, %eax	/* 32ビット シフト */
	xorl	%ebx, %ebx
ladd2:	shrdl	%cl, %ebx, %eax	/* シフトして桁を合わせ */
	shrl	%cl, %ebx
	addl	-8(%ebp), %eax	/* A + B を実行 */
	adcl	%ebx, %edx
	jnc	norm
	shrdl	$1, %edx, %eax	/* キャリーが出たので補正 */
	stc
	rcrl	$1, %edx
	incl	%edi
	jmp	norm

retA:	movl	-8(%ebp), %eax	/* A が充分大きいので, Aが答え */
	jmp	norm

BminusA:
	movl	8(%ebp), %eax	/* A の下位 */
	movl	16(%ebp), %ecx	/* B の下位 */
	cmpl	%ebx, %edx	/* A と Bを比較 */
	jl	lsubx
	jg	lsuba
	cmpl	%ecx, %eax	/*  上位は同じ, 下位を比較 */
	jle	lsubx
lsuba:	btsl	$31, -4(%ebp)	/* A が大, 結果は負 */
	jmp	lsub0

AminusB:
	movl	8(%ebp), %eax	/* A の下位 */
	movl	16(%ebp), %ecx	/* B の下位 */
	cmpl	%ebx, %edx	/* A と Bを比較 */
	jg	lsub0
	jl	lsubb
	cmpl	%ecx, %eax	/*  上位は同じ, 下位を比較 */
	jge	lsub0
lsubb:	btsl	$31, -4(%ebp)	/* B が大, 結果は負 */
lsubx:
	xchgl	%ebx, %edx	/* A と Bを交換し，A >= Bとする */
	xchgl	%ecx, %eax
	shldl	$12, %edx, %edi	/* 指数部を ediにいれる */
	shldl	$11, %eax, %edx	/* ガードビットを 11ビットつける */
	shll	$11, %eax
	movl	%eax, -8(%ebp)	/* A の下位をセーブ */
	movl	%ecx, %eax	/* B の下位を eaxへ */
	jmp	lsub1
lsub0:
	shldl	$12, %edx, %edi	/* 指数部を ediにいれる */
	shldl	$11, %eax, %edx	/* ガードビットを 11ビットつける */
	shll	$11, %eax
	movl	%eax, -8(%ebp)	/* A の下位をセーブ */
	movl	%ecx, %eax	/* B の下位を eaxへ */
lsub1:	
	testl	%edi, %edi	/* 大きい方が 0なら, 結果は 0*/
	jz	retZ
	orl	$0x80000000, %edx	/* A の隠しビットを補う */
	shldl	$12, %ebx, %esi	/* Bの指数部を esiに入れる */
	shldl	$11, %eax, %ebx	/* ガードビットを 11ビットつける */
	shll	$11, %eax
	orl	$0x80000000, %ebx	/* B の隠しビットを補う */
	movl	%edi, %ecx
	subl	%esi, %ecx	/* 指数の差を求める */
	cmpl	$64, %ecx
	jge	retA		/* 差が64以上なら, 計算不要 */
	btl	$5, %ecx	/* 32ビット以上のシフトか？ */
	jnc	lsub2
	movl	%ebx, %eax	/* 32ビット シフト */
	xorl	%ebx, %ebx
lsub2:	shrdl	%cl, %ebx, %eax	/* シフトして桁を合わせ */
	shrl	%cl, %ebx
	movl	%eax, %ecx	/* A - B を実行 */
	movl	-8(%ebp), %eax
	subl	%ecx, %eax
	sbbl	%ebx, %edx

norm:				/* 結果を正規化 */
	bsrl	%edx, %ecx	/* 頭の 0を数える */
	jnz	norm0		
	xchgl	%eax, %edx	/* 上位 32ビット 0なら, 32ビットシフト */
	subl	$32, %edi
	bsrl	%edx, %ecx
	jz	ret0		/* 結果は, 0 */
norm0:	notl	%ecx
	andl	$0x1f, %ecx
	shldl	%cl, %eax, %edx	/* 正規化 */
	shll	%cl, %eax
	shldl	$1, %eax, %edx	/* 隠しビットを除去 */
	shll	$1, %eax
	addl	$0x800, %eax	/* 丸めを行う */
	adcl	$0, %edx
	jnc	norm1
	shrdl	$1, %edx, %eax	/* 繰り上げあり，補正する */
	shrl	%edx
	incl	%edi
norm1:	subl	%ecx, %edi	/* 正規化のシフト分 指数を補正 */
	jg	norm2		/* 指数が 1以上なら */
retZ:
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	ret1

norm2:	cmpl	$0x7ff, %edi
	jl	norm3	
retI:				/* 指数が 7ff 以上なら, 無限大 */
	movl	$0x7ff00000, %edx
	xorl	%eax, %eax
	orl	-4(%ebp), %edx
	jmp	ret0

norm3:	shrdl	$12, %edx, %eax	/* 指数部を付ける */
	shrdl	$12, %edi, %edx
ret0:	orl	-4(%ebp), %edx	/* 符号を付ける */
ret1:	popl	%esi
	popl	%edi
	popl	%ebx
	leave
	ret


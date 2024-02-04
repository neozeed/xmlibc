/* double mul/div function
	v 0.1  begin 1990-6-24 elfin
*/

.text
.globl	___muldf3
.globl	___divdf3

	.align	2
___muldf3:
	enter	$8, $0
	push	%ebx
	push	%edi
	push	%esi

	movl	12(%ebp), %edx	/* A の上位 */
	testl	%edx, %edx
	jz	retZ		/* ゼロなら，結果は 0*/
	movl	20(%ebp), %ebx	/* B の上位 */
	testl	%ebx, %ebx
	jz	retZ		/* ゼロなら，結果は 0*/
	xorl	%edi, %edi	/* 指数と符号を取り出す */
	shldl	$12, %edx, %edi
	xorl	%ecx, %ecx
	shldl	$12, %ebx, %ecx
	movl	%edx, %esi	/* 結果の符号を求める */
	xorl	%ebx, %esi
	andl	$0x80000000, %esi
	movl	%esi, -4(%ebp)
	andl	$0x7ff, %edi	/* 結果の指数を求める */
	andl	$0x7ff, %ecx
	addl	%ecx, %edi
	subl	$0x3fd, %edi
	movl	%edi, -8(%ebp)
	movl	8(%ebp), %eax	/* A を正規化 */
	shldl	$11, %eax, %edx
	shll	$11, %eax
	orl	$0x80000000, %edx
	movl	16(%ebp), %ecx	/* B を正規化 */
	shldl	$11, %ecx, %ebx
	shll	$11, %ecx
	orl	$0x80000000, %ebx
	push	%edx
	mull	%ebx		/* AL * BH */
	movl	%edx, %edi	/* 中間結果を edi:esiに格納 */
	movl	%eax, %esi
	movl	%ecx, %eax	/* BL * AH */
	popl	%ecx
	mull	%ecx
	xchgl	%ecx, %eax	/* AH が eaxに入る */
	addl	%ecx, %esi	/* 中間結果を加算する */
	adcl	%edx, %edi
	rcrl	$1, %ecx	/* キャリーを ecxに保存 */
	mull	%ebx		/* AH * BH */
	addl	%edi, %eax
	adcl	$0, %edx
	btl	$31, %ecx
	adcl	$0, %edx
norm:
	movl	-8(%ebp), %edi	/* 指数を ediに入れる */
	bsrl	%edx, %ecx	/* 正規化, 頭の 0を数える */
	notl	%ecx
	andl	$0x1f, %ecx
	incl	%ecx		/* 隠しビット分のシフト */
	shldl	%cl, %eax, %edx
	shll	%cl, %eax
	addl	$0x800, %eax	/* 丸めを行う */
	adcl	$0, %edx
	jnc	lmul0
	shrdl	$1, %edx, %eax	/* 繰り上がりあり，補正する */
	shrl	$1, %edx
	incl	%edi
lmul0:	subl	%ecx, %edi	/* 正規化分だけ，指数を補正 */
	jg	lmul1
retZ:	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	ret1

lmul1:	cmpl	$0x7ff, %edi
	jl	lmul2
retI:	movl	$0x7ff00000, %edx
	xorl	%eax, %eax
	jmp	ret0

lmul2:	shrdl	$12, %edx, %eax	/* 指数を付ける */
	shrdl	$12, %edi, %edx
ret0:	orl	-4(%ebp), %edx	/* 符号を付ける */
ret1:	popl	%esi
	popl	%edi
	popl	%ebx
	leave
	ret

	.align	2
___divdf3:
	enter	$8, $0
	push	%ebx
	push	%edi
	push	%esi

	movl	12(%ebp), %edx	/* A の上位 */
	testl	%edx, %edx
	jz	retZ		/* ゼロなら，結果は 0 */
	movl	20(%ebp), %ebx	/* B の上位 */
	xorl	%edi, %edi	/* 指数と符号を取り出す */
	shldl	$12, %edx, %edi
	xorl	%ecx, %ecx
	shldl	$12, %ebx, %ecx
	movl	%edx, %esi	/* 結果の符号を求める */
	xorl	%ebx, %esi
	andl	$0x80000000, %esi
	movl	%esi, -4(%ebp)
	testl	%ebx, %ebx	/* B がゼロなら， */
	jz	retI		/*   結果は 無限大 */
	andl	$0x7ff, %edi	/* 結果の指数を求める */
	andl	$0x7ff, %ecx
	cmpl	$0x7ff, %ecx	/* B が無限大なら, */
	jge	retZ		/*   結果は 0 */
	subl	%ecx, %edi
	addl	$0x3ff, %edi
	movl	8(%ebp), %eax	/* A の仮数を取り出す */
	shldl	$11, %eax, %edx
	shll	$11, %eax
	orl	$0x80000000, %edx
	movl	16(%ebp), %ecx	/* B の仮数を取り出す */
	shldl	$11, %ecx, %ebx
	shll	$11, %ecx
	orl	$0x80000000, %ebx

/* h.yama氏のアルゴリズムを使用する。
	(A+a)/(B+b) -> (A+a)/B * 1/(1 + b/B) これを, (A+a)/B * (1 - b/B) と近似
	これは, A/B + a/B - Ab/BB - ab/BB であるが，最後の項を省略し，
	A/B + a/B - Ab/BB -> {A + (a - Ab/B)}/B として計算する。

	正確には， A/B + (a/B - Aa/BB) - (ab/BB - Abb/BBB) + ....
	であり，上記の近似は 3項以下を省略している。しかし， A+a, B+bが正規化
	されていれば，3項以下は，2**-61以下の寄与であり，充分な精度である。
*/
	cmpl	%edx, %ebx	/* A+a < B+b として, オーバフローを避ける */
	ja	ldiv0
	shrdl	$1, %edx, %eax
	shrl	$1, %edx
	incl	%edi
ldiv0:	movl	%edi, -8(%ebp)	/* 指数をセーブ */
	movl	%edx, %edi	/* edxを退避 */
	movl	%eax, %esi
	movl	%edx, %eax	/* A * b */
	mull	%ecx
	divl	%ebx		/* Ab / B */
	subl	%eax, %esi	/* a - Aa/B */
	sbbl	$0, %edi	/* A + (a - Aa/B) */
	movl	%esi, %eax
	movl	%edi, %edx
	divl	%ebx		/* {A + (a-Aa/B)} / B */
	movl	%eax, %edi	/* 商をセーブ */
	xorl	%eax, %eax	/* 剰余を割り, 下の桁を求める */
	divl	%ebx
	movl	%edi, %edx	/* 上の桁を戻す */
	jmp	norm





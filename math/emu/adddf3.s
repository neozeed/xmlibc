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
	jge	retA		/* ����64�ȏ�Ȃ�, �v�Z�s�v */
	btl	$5, %ecx	/* 32�r�b�g�ȏ�̃V�t�g���H */
	jnc	ladd2
	movl	%ebx, %eax	/* 32�r�b�g �V�t�g */
	xorl	%ebx, %ebx
ladd2:	shrdl	%cl, %ebx, %eax	/* �V�t�g���Č������킹 */
	shrl	%cl, %ebx
	addl	-8(%ebp), %eax	/* A + B �����s */
	adcl	%ebx, %edx
	jnc	norm
	shrdl	$1, %edx, %eax	/* �L�����[���o���̂ŕ␳ */
	stc
	rcrl	$1, %edx
	incl	%edi
	jmp	norm

retA:	movl	-8(%ebp), %eax	/* A ���[���傫���̂�, A������ */
	jmp	norm

BminusA:
	movl	8(%ebp), %eax	/* A �̉��� */
	movl	16(%ebp), %ecx	/* B �̉��� */
	cmpl	%ebx, %edx	/* A �� B���r */
	jl	lsubx
	jg	lsuba
	cmpl	%ecx, %eax	/*  ��ʂ͓���, ���ʂ��r */
	jle	lsubx
lsuba:	btsl	$31, -4(%ebp)	/* A ����, ���ʂ͕� */
	jmp	lsub0

AminusB:
	movl	8(%ebp), %eax	/* A �̉��� */
	movl	16(%ebp), %ecx	/* B �̉��� */
	cmpl	%ebx, %edx	/* A �� B���r */
	jg	lsub0
	jl	lsubb
	cmpl	%ecx, %eax	/*  ��ʂ͓���, ���ʂ��r */
	jge	lsub0
lsubb:	btsl	$31, -4(%ebp)	/* B ����, ���ʂ͕� */
lsubx:
	xchgl	%ebx, %edx	/* A �� B���������CA >= B�Ƃ��� */
	xchgl	%ecx, %eax
	shldl	$12, %edx, %edi	/* �w������ edi�ɂ���� */
	shldl	$11, %eax, %edx	/* �K�[�h�r�b�g�� 11�r�b�g���� */
	shll	$11, %eax
	movl	%eax, -8(%ebp)	/* A �̉��ʂ��Z�[�u */
	movl	%ecx, %eax	/* B �̉��ʂ� eax�� */
	jmp	lsub1
lsub0:
	shldl	$12, %edx, %edi	/* �w������ edi�ɂ���� */
	shldl	$11, %eax, %edx	/* �K�[�h�r�b�g�� 11�r�b�g���� */
	shll	$11, %eax
	movl	%eax, -8(%ebp)	/* A �̉��ʂ��Z�[�u */
	movl	%ecx, %eax	/* B �̉��ʂ� eax�� */
lsub1:	
	testl	%edi, %edi	/* �傫������ 0�Ȃ�, ���ʂ� 0*/
	jz	retZ
	orl	$0x80000000, %edx	/* A �̉B���r�b�g��₤ */
	shldl	$12, %ebx, %esi	/* B�̎w������ esi�ɓ���� */
	shldl	$11, %eax, %ebx	/* �K�[�h�r�b�g�� 11�r�b�g���� */
	shll	$11, %eax
	orl	$0x80000000, %ebx	/* B �̉B���r�b�g��₤ */
	movl	%edi, %ecx
	subl	%esi, %ecx	/* �w���̍������߂� */
	cmpl	$64, %ecx
	jge	retA		/* ����64�ȏ�Ȃ�, �v�Z�s�v */
	btl	$5, %ecx	/* 32�r�b�g�ȏ�̃V�t�g���H */
	jnc	lsub2
	movl	%ebx, %eax	/* 32�r�b�g �V�t�g */
	xorl	%ebx, %ebx
lsub2:	shrdl	%cl, %ebx, %eax	/* �V�t�g���Č������킹 */
	shrl	%cl, %ebx
	movl	%eax, %ecx	/* A - B �����s */
	movl	-8(%ebp), %eax
	subl	%ecx, %eax
	sbbl	%ebx, %edx

norm:				/* ���ʂ𐳋K�� */
	bsrl	%edx, %ecx	/* ���� 0�𐔂��� */
	jnz	norm0		
	xchgl	%eax, %edx	/* ��� 32�r�b�g 0�Ȃ�, 32�r�b�g�V�t�g */
	subl	$32, %edi
	bsrl	%edx, %ecx
	jz	ret0		/* ���ʂ�, 0 */
norm0:	notl	%ecx
	andl	$0x1f, %ecx
	shldl	%cl, %eax, %edx	/* ���K�� */
	shll	%cl, %eax
	shldl	$1, %eax, %edx	/* �B���r�b�g������ */
	shll	$1, %eax
	addl	$0x800, %eax	/* �ۂ߂��s�� */
	adcl	$0, %edx
	jnc	norm1
	shrdl	$1, %edx, %eax	/* �J��グ����C�␳���� */
	shrl	%edx
	incl	%edi
norm1:	subl	%ecx, %edi	/* ���K���̃V�t�g�� �w����␳ */
	jg	norm2		/* �w���� 1�ȏ�Ȃ� */
retZ:
	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	ret1

norm2:	cmpl	$0x7ff, %edi
	jl	norm3	
retI:				/* �w���� 7ff �ȏ�Ȃ�, ������ */
	movl	$0x7ff00000, %edx
	xorl	%eax, %eax
	orl	-4(%ebp), %edx
	jmp	ret0

norm3:	shrdl	$12, %edx, %eax	/* �w������t���� */
	shrdl	$12, %edi, %edx
ret0:	orl	-4(%ebp), %edx	/* ������t���� */
ret1:	popl	%esi
	popl	%edi
	popl	%ebx
	leave
	ret


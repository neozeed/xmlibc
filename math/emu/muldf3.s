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

	movl	12(%ebp), %edx	/* A �̏�� */
	testl	%edx, %edx
	jz	retZ		/* �[���Ȃ�C���ʂ� 0*/
	movl	20(%ebp), %ebx	/* B �̏�� */
	testl	%ebx, %ebx
	jz	retZ		/* �[���Ȃ�C���ʂ� 0*/
	xorl	%edi, %edi	/* �w���ƕ��������o�� */
	shldl	$12, %edx, %edi
	xorl	%ecx, %ecx
	shldl	$12, %ebx, %ecx
	movl	%edx, %esi	/* ���ʂ̕��������߂� */
	xorl	%ebx, %esi
	andl	$0x80000000, %esi
	movl	%esi, -4(%ebp)
	andl	$0x7ff, %edi	/* ���ʂ̎w�������߂� */
	andl	$0x7ff, %ecx
	addl	%ecx, %edi
	subl	$0x3fd, %edi
	movl	%edi, -8(%ebp)
	movl	8(%ebp), %eax	/* A �𐳋K�� */
	shldl	$11, %eax, %edx
	shll	$11, %eax
	orl	$0x80000000, %edx
	movl	16(%ebp), %ecx	/* B �𐳋K�� */
	shldl	$11, %ecx, %ebx
	shll	$11, %ecx
	orl	$0x80000000, %ebx
	push	%edx
	mull	%ebx		/* AL * BH */
	movl	%edx, %edi	/* ���Ԍ��ʂ� edi:esi�Ɋi�[ */
	movl	%eax, %esi
	movl	%ecx, %eax	/* BL * AH */
	popl	%ecx
	mull	%ecx
	xchgl	%ecx, %eax	/* AH �� eax�ɓ��� */
	addl	%ecx, %esi	/* ���Ԍ��ʂ����Z���� */
	adcl	%edx, %edi
	rcrl	$1, %ecx	/* �L�����[�� ecx�ɕۑ� */
	mull	%ebx		/* AH * BH */
	addl	%edi, %eax
	adcl	$0, %edx
	btl	$31, %ecx
	adcl	$0, %edx
norm:
	movl	-8(%ebp), %edi	/* �w���� edi�ɓ���� */
	bsrl	%edx, %ecx	/* ���K��, ���� 0�𐔂��� */
	notl	%ecx
	andl	$0x1f, %ecx
	incl	%ecx		/* �B���r�b�g���̃V�t�g */
	shldl	%cl, %eax, %edx
	shll	%cl, %eax
	addl	$0x800, %eax	/* �ۂ߂��s�� */
	adcl	$0, %edx
	jnc	lmul0
	shrdl	$1, %edx, %eax	/* �J��オ�肠��C�␳���� */
	shrl	$1, %edx
	incl	%edi
lmul0:	subl	%ecx, %edi	/* ���K���������C�w����␳ */
	jg	lmul1
retZ:	xorl	%edx, %edx
	xorl	%eax, %eax
	jmp	ret1

lmul1:	cmpl	$0x7ff, %edi
	jl	lmul2
retI:	movl	$0x7ff00000, %edx
	xorl	%eax, %eax
	jmp	ret0

lmul2:	shrdl	$12, %edx, %eax	/* �w����t���� */
	shrdl	$12, %edi, %edx
ret0:	orl	-4(%ebp), %edx	/* ������t���� */
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

	movl	12(%ebp), %edx	/* A �̏�� */
	testl	%edx, %edx
	jz	retZ		/* �[���Ȃ�C���ʂ� 0 */
	movl	20(%ebp), %ebx	/* B �̏�� */
	xorl	%edi, %edi	/* �w���ƕ��������o�� */
	shldl	$12, %edx, %edi
	xorl	%ecx, %ecx
	shldl	$12, %ebx, %ecx
	movl	%edx, %esi	/* ���ʂ̕��������߂� */
	xorl	%ebx, %esi
	andl	$0x80000000, %esi
	movl	%esi, -4(%ebp)
	testl	%ebx, %ebx	/* B ���[���Ȃ�C */
	jz	retI		/*   ���ʂ� ������ */
	andl	$0x7ff, %edi	/* ���ʂ̎w�������߂� */
	andl	$0x7ff, %ecx
	cmpl	$0x7ff, %ecx	/* B ��������Ȃ�, */
	jge	retZ		/*   ���ʂ� 0 */
	subl	%ecx, %edi
	addl	$0x3ff, %edi
	movl	8(%ebp), %eax	/* A �̉��������o�� */
	shldl	$11, %eax, %edx
	shll	$11, %eax
	orl	$0x80000000, %edx
	movl	16(%ebp), %ecx	/* B �̉��������o�� */
	shldl	$11, %ecx, %ebx
	shll	$11, %ecx
	orl	$0x80000000, %ebx

/* h.yama���̃A���S���Y�����g�p����B
	(A+a)/(B+b) -> (A+a)/B * 1/(1 + b/B) �����, (A+a)/B * (1 - b/B) �Ƌߎ�
	�����, A/B + a/B - Ab/BB - ab/BB �ł��邪�C�Ō�̍����ȗ����C
	A/B + a/B - Ab/BB -> {A + (a - Ab/B)}/B �Ƃ��Čv�Z����B

	���m�ɂ́C A/B + (a/B - Aa/BB) - (ab/BB - Abb/BBB) + ....
	�ł���C��L�̋ߎ��� 3���ȉ����ȗ����Ă���B�������C A+a, B+b�����K��
	����Ă���΁C3���ȉ��́C2**-61�ȉ��̊�^�ł���C�[���Ȑ��x�ł���B
*/
	cmpl	%edx, %ebx	/* A+a < B+b �Ƃ���, �I�[�o�t���[������� */
	ja	ldiv0
	shrdl	$1, %edx, %eax
	shrl	$1, %edx
	incl	%edi
ldiv0:	movl	%edi, -8(%ebp)	/* �w�����Z�[�u */
	movl	%edx, %edi	/* edx��ޔ� */
	movl	%eax, %esi
	movl	%edx, %eax	/* A * b */
	mull	%ecx
	divl	%ebx		/* Ab / B */
	subl	%eax, %esi	/* a - Aa/B */
	sbbl	$0, %edi	/* A + (a - Aa/B) */
	movl	%esi, %eax
	movl	%edi, %edx
	divl	%ebx		/* {A + (a-Aa/B)} / B */
	movl	%eax, %edi	/* �����Z�[�u */
	xorl	%eax, %eax	/* ��]������, ���̌������߂� */
	divl	%ebx
	movl	%edi, %edx	/* ��̌���߂� */
	jmp	norm





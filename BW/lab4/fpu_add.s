	.globl	fpu_add
	.type	fpu_add, @function
fpu_add:
	pushq	%rbp
	movq	%rsp, %rbp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	fldl	-8(%rbp)
	faddl	-16(%rbp)
	fstpl	-24(%rbp)
	movsd	-24(%rbp), %xmm0
	popq	%rbp
	ret

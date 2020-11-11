	.globl	fpu_add
	.type	fpu_add, @function
fpu_add:
	pushq	%rbp
	movq	%rsp, %rbp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	fldl	-8(%rbp) #obnizam wskaznik stosu i laduje tam  xmm0
	faddl	-16(%rbp) # dodaje xmm0 = xmm0 + xmm1
	fstl	(%rdi)
	fstpl	-24(%rbp) # wklada do -24(.) ST(0) i popuje
	movsd	-24(%rbp), %xmm0 #przerzucamy wynik do xmm0
	popq	%rbp
	ret

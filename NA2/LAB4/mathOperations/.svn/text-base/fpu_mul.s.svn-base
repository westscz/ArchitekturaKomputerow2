	.globl	fpu_mul
	.type	fpu_mul, @function
fpu_mul:
	pushq	%rbp
	movq	%rsp, %rbp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	fldl	-8(%rbp) #obnizam wskaznik stosu i laduje tam  xmm0
	fmull	-16(%rbp) # odejmuje xmm0 = xmm0 - xmm1
	fstpl	-24(%rbp) # wklada do -24(.) ST(0) i popuje
	movsd	-24(%rbp), %xmm0 #przerzucamy wynik do xmm0
	popq	%rbp
	ret

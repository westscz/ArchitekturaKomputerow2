	.globl	fpu_div
	.type	fpu_div, @function
fpu_div:
	pushq	%rbp
	movq	%rsp, %rbp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	fldl	-8(%rbp) #obnizam wskaznik stosu i laduje tam  xmm0
	fdivl	-16(%rbp) # odejmuje xmm0 = xmm0 - xmm1
	fstpl	-24(%rbp) # wklada do -24(.) ST(0) i popuje
	movsd	-24(%rbp), %xmm0 #przerzucamy wynik do xmm0
	popq	%rbp
	ret

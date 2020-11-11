.globl integrate	
	.type	integrate, @function
integrate:
	pushq	%rbp
	movq	%rsp, %rbp
	movsd	%xmm0, -8(%rbp)
	movsd	%xmm1, -16(%rbp)
	mov	%rdi,  -24(%rbp)
#	finit
	fldl	 -8(%rbp) #a -st1
	fldl	-16(%rbp) #b -st0
	
	mov		$0, %rcx
	fsub	%st(1), %st
	fild	-24(%rbp)
	fdivrp	%st, %st(1)
	fldz
		
loop:

	fldz

	fldz	
	fadd	%st(3),%st
	faddp	%st,%st(4)	

	fadd	%st(2),%st
	fdiv	%st(3),%st
	faddp	%st,%st(1)

	add		$1, %rcx
	cmp		%rcx,%rdi
	je endOfLoop
	jmp loop
	
endOfLoop:

	fstpl  -32(%rbp)
	movsd  -32(%rbp),%xmm0
	faddp
	faddp
	faddp
	popq	%rbp
	ret

    .globl	get_fpu
	.type	get_fpu, @function
get_fpu:
	pushq	%rbp
	movq	%rsp, %rbp
	fstcw	-8(%rbp)
    movw    -8(%rbp), %ax
	popq	%rbp
	ret

    .globl	get_fpu
	.type	get_fpu, @function
get_fpu:
	pushq	%rbp
	movq	%rsp, %rbp
	fstcw	-8(%rbp) # laduje control word do -8(.)
    	movw    -8(%rbp), %ax # control word do ax
	popq	%rbp
	ret

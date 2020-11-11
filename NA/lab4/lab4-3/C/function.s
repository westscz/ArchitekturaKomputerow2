	.file	"function.c"
	.text
	.globl	multiply
	.type	multiply, @function
multiply:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	popq	%rbp
	ret
	.size	multiply, .-multiply
	.ident	"GCC: (Ubuntu 4.8.2-19ubuntu1) 4.8.2"
	.section	.note.GNU-stack,"",@progbits

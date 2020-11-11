	.file	"test.c"
.globl dupa
	.bss
	.align 4
	.type	dupa, @object
	.size	dupa, 4
dupa:
	.zero	4
	.text
.globl main
	.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	dupa(%rip), %eax
	addl	$1, %eax
	movl	%eax, dupa(%rip)
	movl	dupa(%rip), %eax
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.4.3-4ubuntu5) 4.4.3"
	.section	.note.GNU-stack,"",@progbits

.section .rodata
output:
	.string "Your number is %d\n"
input:
	.string "%d"
number:
	.int 0
.text
.globl main
main:
	#get number 
	pushq %rbp
	movq %rsp, %rbp
	
	subq $16, %rsp
	movl $input, %eax
	leaq -4(%rbp), %rdx
	movq %rdx, %rsi
	movq %rax, %rdi
	movl $0, %eax
	call __isoc99_scanf
	movl -4(%rbp), %edx
	
	
	
	
	
	#print number
	movl $output, %eax
	movl %edx, %esi
	movq %rax, %rdi
	movl $0, %eax
	call printf
	
	movl $0, %eax
	call exit

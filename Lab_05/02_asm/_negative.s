	.file	"_negatyw.c"
	.text
	.globl	_negative
	.type	_negative, @function
_negative:
	pushq	%rbp			#allocate stack
	movq	%rsp, %rbp		#---
	# rdi - bitmap
	# esi - size
	movq $0, %r10 			#i = 0
	jmp afterloop
loop:
	movq %rdi, %r11			#copy bitmap's address to r11
	addq %r10, %r11			#add program counter to address
	movq (%r11), %mm0		#move 8bits under calculated address to %mm0
	pcmpeqw %mm4, %mm4		#fill %mm4 register with 1's
	pxor %mm4, %mm0			#effectively - NOT the %mm0 register
	movq %mm0, (%r11)		#move negated values back to memory

	addq $8, %r10 #increment i

afterloop:
	movq %r10, %rax			#move i to eax
	cmpl %esi, %eax 		#for loop condition
	jb loop
	popq %rbp				#deallocate stack
	ret

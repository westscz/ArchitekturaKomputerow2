#include <stdio.h>
#include <stdlib.h>

.file "lab.s"
.section .rodata
RadString:
	.string "x = %f\n"
ResultString:
	.string "Result: %f\n"
InitialInfo:
	.string "Degree: %f, steps: %d\n"
InputPrompt:
	.string "Podaj [kat] sinusa i [k] liczbe krokow\n"
InputFormat:
	.string "%d %d"
DegToRad:
	.float 0.0174532925

.section .bss
Rads:
	.float 0 

	.text
	.globl main
	.type main, @function
main:
	#get
	nop
	#prompt user to input 2 numbers
	movl $0, %eax				#eax has to be zeroeds
	movq $InputPrompt, %rdi		#pass format string address as first argument
	call printf					#call C function printf
	
	#get user input using C function - scanf
	movq %rsp, %rbp				#save current stack pointer to base pointer
	subq $8, %rsp				#allocate space for 2 integers
	movq $InputFormat, %rdi 	#pass input format as first argument
	movq $0, -4(%rbp)			#clear stack
	movq $0, -8(%rbp)			#---
	leaq -8(%rbp), %rsi			#pass first 4 allocated bits address as second argument
	leaq -4(%rbp), %rdx			#pass next 4 allocated bits address as third argument
	movl $0, %eax				#eax has to be zeroed
	call scanf					#call C function scanf

	initializations:
	movq -4(%rbp), %r13			#number of steps
	fild -8(%rbp)				#load degrees to floating point register stack
	fmul DegToRad				#change degrees to rads
	
	movq %rsp, %rbp				#allocate stack
	subq $16, %rsp				#---
	

	fstl 8(%rsp)				#copy rads to stack
	fldl 8(%rsp)				#copy again to floating stack for future use as POWER
	fldl 8(%rsp)				#copy again to floating stack for future use as SUM
	addq $16, %rsp

	more_inits:
	movq $1, %r10				#factorial
	movq $1, %r11				#highestSoFar
	movq $1, %r12				#i counter

	cmp %r12, %r13
	je afterLoop
	loop:
	#multiply POWER 2 times
	fxch %st(2)					#take x to the top of the stack
	fmul %st(0), %st(1)			#power*=x
	fmul %st(0), %st(1)			#power*=x
	fxch %st(2)					#take x back to place

	#increase factorial
	movq %r10, %rax				#move factorial to rax
	inc %r11					#highestSoFar++
	mulq %r11					#rax*=highestSoFar
	inc %r11					#highestSoFar++
	mulq %r11					#rax*=highestSoFar
	movq %rax, %r10				#factorial back to r10

	lol:
	#partial sum
	fldz						#load 0 to top of stack
	fadd %st(2)					#partialSum+=power
	subq $16, %rsp				#make space on stack	
	movq %r10, (%rsp)			#load factorial on stack
	fidiv (%rsp)				#partialSum/=factorial
	addq $16, %rsp				#free the stack

	#i%2==0?
	movq %r12, %rax			
	CDQ							#sign-extend rax to rdx
	movq $2, %rbx
	divq %rbx					#i/2
	cmp $0, %rdx				#i%2==0
	cmp:
	jne odd
	even:
	faddp %st(0), %st(1)		#sum+=partialSum and pop partialSum
	jmp loopEnding
	odd:
	fsubrp %st(0), %st(1)		#sum-=partialSum and pop partialSum
	jmp loopEnding

	loopEnding:
	inc %r12					#i++
	cmp %r12, %r13				#i<steps
	jne loop

	afterLoop:

	movq %rsp, %rbp				#allocate stack
	subq $16, %rsp				#---
	

	fstl 8(%rsp)				#copy rads to stack
	movsd 8(%rsp), %xmm0		#move rads to xmm0 reg
	movq $1, %rax				#tell printf to accept 1 arg from xmm regs
	movq $ResultString, %rdi		#move RadString format address to rdi
	call printf					#print given input in rads
	addq $16, %rsp


	movl $0, %eax
	call exit

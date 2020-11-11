#LAB 2-1 
#The program reads a number from the standard input and return
#it as base_3 number

.data
SYSREAD = 0
SYSWRITE = 0
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.bss
.comm user_input, 512, 1
.comm inverted_output, 512, 1
.comm output, 512, 1

.text
.globl _start

_start:
nop

#Get user input
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $user_input, %rsi
movq $512, %rdx
syscall

movq %rax, %r10		#length of input
dec %r10			#skip '\n'
movq %r10, %rcx		#initialize decreasing counter
dec %ecx			#we're counting from 0

movq $0, %r15 		#to store final number

#Convert the string to decimal
#Iterate the string 
_toint:
	movl user_input(,%ecx,1), %ebx

	sub $'0', %ebx	#match ascii code to the actual value

	#calculate current positon in base_10
	#(length-2)-counter
	push %r10
	sub $1, %r10
	sub %rcx, %r10

	#caluclate the 10 multiplier 10^%r10
	_multiplier:
		mov $1, %eax	#start with 0
		cmp $0, %r10
		je	_after_multiplier	#edge case for position 0
		push %rbx
		movl $10, %ebx
		mul %ebx
		pop %rbx
		dec %r10
		cmp $0, %r10
		jne _multiplier
		#the final multiplier is in eax now
	
	_after_multiplier:
	mul %ebx	#multiply the number by multiplier
	add %eax, %r15D	#add the result to final number

	pop %r10
	dec %ecx
	cmp $0, %ecx
	jge _toint


_after:
#System exit on sucess
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

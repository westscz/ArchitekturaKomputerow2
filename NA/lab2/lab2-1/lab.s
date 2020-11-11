.data 
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.bss
.comm user_input, 512
.comm inverted, 512
.comm output, 512
.word number

.text
.global _start

_start:
#empty command for gdb to work
nop


#Get user input
movq $SYSREAD, %rax
movq $STDIN, %rdi 
movq $user_input, %rsi
movq $512, %rdx
syscall

movq %rax,%r10			#length of input
dec %r10				#decrease by 1 to skip '\n'
movq $0, %r11			#initialize counter
movq $0, %r15			#to store number

#Iterate the string, and convert it to decimal
_toint:
	movzbq user_input(,%r11,1), %r12

	sub $'0', %r12			#substract value of '0' in order to normalize number to 0

	push %r10
	push %r11
	
	#which position are we on?
	sub %r11, %r10
	sub $1, %r10
	
	#10^%r10
	movq %r12, %r11	#start with 1
	cmp $0, %r10
	je _lastdigit
	
	_power:
		xor %rax, %rax
		movl $10, %eax
		mul %r11			#multiply by 10
		movq %rax, %r11 	#move result to register
		dec %r10 			#decrease the counter
		cmp $0, %r10		#if exponent still bigger/equal 0 start over
		jne _power
		jmp _afterpower

	#The edge case for 10^0=1
	_lastdigit:
		add %r11, %r12
		

	_afterpower:
	add %r11, %r15
	pop %r11
	pop %r10
	
	
	add $'0', %r12

	movq %r12, output(,%r11,1)	#move the processed letter to the output buffer
	inc %r11					#decrease the counter
	cmp %r10, %r11				#check for loop's ending condition (every char literated)
	jne _toint					#if not met - jump to the beginning


#converted number is in %r15

#horner's method
movq $0, %r10 					#counter
xor %rax, %rax
xor %rdx, %rdx
movq %r15, %rax
_horner:
	CDQ							#sign-extend eax to edx
	movq $3, %rbx
	div %rbx					#divide the number by 3
	movl %edx, inverted(,%r10,1) #the remainder is part of converted number
	inc %r10
	cmp $0, %eax
	jne _horner

_ah:
#now, the inverted buffer stores inverted final result

#take inverted back to ascii chars
xorq %r11, %r11
#iterate each char
_toascii:
	xorq %r12, %r12
	mov inverted(,%r11,1), %r12
	add $'0', %r12					#add '0' value to code the number
	mov %r12, inverted(,%r11,1)
	inc %r11
	cmp %r11, %r10
	jne _toascii

#invert back to normal
xorq %r11, %r11			#the increasing counter
movq %r10, %r13			#the decreasing counter
sub $1, %r13
_invert:

	xor %r12, %r12
	mov inverted(,%r13,1), %r12		#take char iterating from back...
	mov %r12, output(,%r11,1)		#...and put it back, iterating from beginning
	inc %r11
	dec %r13
	cmp %r10, %r11
	
	
	jl _invert


_after:


movq $'\n', output(,%r10,1)		#append newline char at the end of the output

#Print result on screen
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $output, %rsi
movq $512, %rdx
syscall

#System exit on sucess
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

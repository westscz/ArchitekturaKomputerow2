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
.globl _start

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
#Iterate the string, and convert
_toint:
	movzbq user_input(,%r11,1), %r12


	sub $'0', %r12			#substract value of '0' in order to normalize number to 0
	#get multiplier
	push %r10
	push %r11
	
	#which position?
	sub %r11, %r10
	sub $1, %r10
	
	#10^%r10
	movq %r12, %r11	#start with 1
	cmp $0, %r10
	je _lastdigit
	
	_power:
		xor %rax, %rax
		movl $10, %eax
		mul %r11	#multiply by 10
		movq %rax, %r11 #move result to register
		dec %r10 	#decrease the counter
		cmp $0, %r10	#if still bigger/equal 0 start over
		jne _power
		jmp _afterpower

	_lastdigit:
		add %r11, %r12
		

	_afterpower:
	add %r11, %r15
	pop %r11
	pop %r10
	
	
	add $'0', %r12

	movq %r12, output(,%r11,1)	#move the processed letter to the output buffer
	inc %r11					#decrease the counter
	cmp %r10, %r11			#check for loop's ending condition (every char literated)
	jne _toint					#if not met - jump to the beginning


#converted number in %r15!!!

#horner's method
movq $0, %r10 #counter
xor %rax, %rax
xor %rdx, %rdx
movq %r15, %rax
_horner:
	CDQ
	movq $3, %rbx
	div %rbx
	movl %edx, inverted(,%r10,1) #move remainder
	inc %r10
	cmp $0, %eax
	jne _horner

_ah:



#invert inverted
movq $0, %r11
movq %r10, %r13
sub $1, %r13
_invert:

	xor %r12, %r12
	movq inverted(,%r13,1), %r12
	movq %r12, output(,%r11,1)
	inc %r11
	dec %r13
	cmp %r10, %r11
	
	
	jne _invert


_after:

inc %r10									#increase to point to next char after last char
movq $'\n', output(,%r10,1)		#append newline char at the end of the output

#Print result on screen
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $inverted, %rsi
movq $512, %rdx
syscall

#System exit on sucess
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

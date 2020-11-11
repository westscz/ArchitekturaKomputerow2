.data 
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.bss
.comm user_input, 512
.comm output, 512

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

#iterate the string
_convert:
	xorl %eax, %eax
	movzbl user_input(,%r11,1), %eax

	cmp $'9', %eax		#we're assuming correct input 
	jle _number
	jg _letter

	_number:
		subl $'0', %eax	#convert ascii to int
		jmp _after
	_letter:
		subl $'A', %eax #convert ascii to int
		addl $10, %eax	#A = 10, B = 11 and so on
		jmp _after
	_after:

	#calculate output write position
	push %r11
	push %rax
	movl $2, %eax		#output_position is input_position*2
	mul %r11
	movl %eax, %r11D
	pop %rax

	CDQ					#sign extend eax to edx
	movl $4, %ebx		#to convert to base 4
	div %ebx
	add $'0', %eax		#back to ASCII
	movl %eax, output(,%r11,1)	#quoitient is older bytye
	inc %r11
	add $'0', %edx 		#back to ASCII
	movl %edx, output(,%r11,1)	#remainder is lower byte

	pop %r11
	inc %r11
	cmp %r11, %r10
	jne _convert 


movl $2, %eax
mul %r10
movl %eax, %r10D
inc %r10
movb $'\n', output(,%r10,1)


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

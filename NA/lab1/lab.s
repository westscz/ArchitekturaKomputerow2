.data 
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
SHIFT = 1
ALPHABET = 26

.bss
.comm user_input, 512
.comm output, 512

.text
.globl _start

_start:
#empty command for gdb to work
nop
movq $SHIFT, %r15
movq $ALPHABET, %r13

#Get user input
movq $SYSREAD, %rax
movq $STDIN, %rdi 
movq $user_input, %rsi
movq $512, %rdx
syscall

movq %rax,%r10			#length of input
dec %r10				#decrease by 1 to skip '\n'
movq $0, %r11			#initialize counter

#Iterate the string, and cipher each letter
_caesar:
	movzbq user_input(,%r11,1), %r12

	#check if within letter-range
	cmp $'A', %r12d		#if less than 'A', than definitely not a letter
	jl _other
	cmp $'z', %r12d		#the same if bigger than 'z'
	jg _other

	#mind the gab between lower and uppercase letters
	cmp $'Z', %r12d 	#if less/equal 'Z' - uppercase letter
	jle _upper
	cmp $'a', %r12d 	#if greater/equal - lowercase letter
	jge _lower
	jmp _other			#char inside the gap

	_upper:
		sub $'A', %r12			#substract value of 'A' in order to normalize number to 0
		add %r15, %r12			#add shift
		movl %r12d, %eax		#move dividend to eax
		CDQ						#/Dividend is edx:eax where edx are older bytes. This command 
								#sign-extends 32bit eax to 64bit number stored in eax and edx/
		div %r13				#divide the number by number of letters in the alphabet
		movl %edx, %r12d		#retreive the remainder
		add $'A', %r12			#take it back to place (denormalization)
		jmp _after
	_lower:
		sub $'a', %r12			#substract value of 'A' in order to normalize number to 0
		add %r15, %r12			#add shift
		movl %r12d, %eax		#move dividend to eax
		CDQ						#/Dividend is edx:eax where edx are older bytes. This command 
								#sign-extends 32bit eax to 64bit number stored in eax and edx/
		div %r13				#divide the number by number of letters in the alphabet
		movl %edx, %r12d		#retreive the remainder
		add $'a', %r12			#take it back to place (denormalization)
		jmp _after

	_other:
		nop    					#do nothing for non-letters

	_after:
		movq %r12, output(,%r11,1)	#move the processed letter to the output buffer
		inc %r11					#increase the counter
		cmp %r11, %r10				#check for loop's ending condition (every char literated)
		jne _caesar					#if not met - jump to the beginning

movq $'\n', output(,%r11,1)		#append newline char at the end of the output

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

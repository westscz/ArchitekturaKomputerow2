.data 
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0


.bss
.comm user_input, 512


.text
.globl _start

_start:
#read user input
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi 
movq $user_input, %rsi
movq $512, %rdx
syscall

#---Change letters size---
#lower to uppercase
#uppercase to lowercase


movq %rax, %rdx			#save user's input lenght to rdx
dec %rdx			#we have to decrease lenght by 1, so we skip '\n'
movq $0, %rbx			#rbx will be our counter - let's initialize it wth 0


_startLoop:				#The loop
mov user_input(,%rbx,1), %rax		#move current letter to rax

cmp $0x20, %al
je _nospace
xor $0x20, %rax				#change letter case with xor binary operation
_nospace:


mov %rax, user_input(,%rbx,1)		#take the letter back to it's place in buffer
inc %rbx				#increase counter
cmp %rdx, %rbx 				#check ending condition
jl _startLoop				#if not met - repeat loop
#---Change letters size---


#return user's input after modification
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $user_input, %rsi
movq $512, %rdx
syscall

#exit program on sucess
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

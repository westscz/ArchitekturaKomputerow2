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
.globl _start

_start:
#read user input
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi 
movq $user_input, %rsi
movq $512, %rdx
syscall

dec %rax
movl $0, %edi

_loop:
movb user_input(,%edi,1), %bh
movb $0x20, %bl
xor %bh, %bl
movb %bl, output(,%edi,1)
inc %edi
cmp %eax, %edi 
jl _loop

movb $'\n', output(,%edi,1)


#return user's input after modification
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $output, %rsi
movq $512, %rdx
syscall

#exit program on sucess
movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

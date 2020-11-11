.data 
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

message: .ascii "Hello, world\n"
message_len = .-message

.bss
.comm user_input, 512


.text
.globl _start

_start:
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi 
movq $user_input, %rsi
movq $512, %rdx
syscall


movq %rax, %rdx
dec %rdx
movq $0, %rbx
_reverse:
mov user_input(,%rbx,1), %rax
cmp  $0x20, %rax
je _nospace
xor $0x20, %rax
_nospace:
mov %rax, user_input(,%rbx,1)
inc %rbx
cmp %rbx, %rdx
jne _reverse




movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $user_input, %rsi
movq $512, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

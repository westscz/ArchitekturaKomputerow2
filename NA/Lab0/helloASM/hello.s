.data 
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

message: .ascii "Hello, world\n"
message_len = .-message

.text
.globl _start

_start:
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $message, %rsi
movq $message_len, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

SYSCALL32 = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1

.data
komunikat: .ascii "Hello World\n"
rozmiar = . - komunikat

.text

.globl _start
_start:         movl    $rozmiar, %edx
                movl    $komunikat, %ecx
                movl    $STDOUT, %ebx
                movl    $WRITE, %eax
                int     $SYSCALL32
                movl    $EXIT, %eax
                int     $SYSCALL32

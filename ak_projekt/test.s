SYSCALL32 = 0x80
EXIT = 1
WRITE = 4
STDOUT = 1
.data
komunikat: .ascii "Hello\n"
rozmiar = . - komunikat

.macro write_info text size
movl \size, %edx
movl \text, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL32
.endm

.text
.globl _start
_start:
write_info $komunikat $rozmiar
movl $EXIT, %eax
int $SYSCALL32

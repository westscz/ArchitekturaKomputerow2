EXIT = 1
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL = 0X80
ERROR = 0

.data #Sekcja zmiennych

.bss #Sekcja bufora 

#Stałe#
.text

END_OF_LINE = 10
LENGTH = 256

#Main#
.global _start #uzywane przez linker LD aby oznaczyc gdzie rozpoczyna się program
_start:

 mov $'A', %eax

 push %eax
 call xor_func
 pop %ecx

 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL

xor_func:
 push %ebp
 mov %esp, %ebp
 mov 8(%ebp),%ebx
 
 xor $0b00100000, %ebx

 mov %ebx, 8(%ebp)
 mov %ebp, %esp
 pop %ebp
 ret


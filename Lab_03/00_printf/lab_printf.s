EXIT = 1
SYSCALL = 0X80
ERROR = 0

.data

string: .ascii "%s %d\n\0"
txt: .ascii "Laboratorium\0"
number: .long 4

.text

.global main
main:
pushl number
pushl $txt
pushl $string
call printf
mov $EXIT, %eax
mov $ERROR, %ebx
int $SYSCALL


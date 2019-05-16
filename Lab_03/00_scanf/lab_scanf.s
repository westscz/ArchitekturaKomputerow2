EXIT = 1
SYSCALL = 0X80
ERROR = 0

.data
info: .ascii "Napisz cos (max 10 znakow): \0"
string_in: .ascii "%s"
string: .space 11
string_out: .ascii "Napisales: %s\n\0"

.text

.global main
main:

pushl $info
call printf

pushl $string
pushl $string_in
call scanf

pushl $string
pushl $string_out
call printf

mov $EXIT, %eax
mov $ERROR, %ebx
int $SYSCALL


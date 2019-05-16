EXIT = 1
SYSCALL = 0X80
ERROR = 0

.data
string: .ascii "Wynik dodawania = %d\n\0"
number: .long

.text
.globl main
main:
 pushl $64
 pushl $32
 call add 	#Wynik w %eax
stop:
 pushl %eax
 pushl $string
 call printf 


mov $EXIT, %eax
mov $ERROR, %ebx
int $SYSCALL


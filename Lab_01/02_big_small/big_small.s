#Kody#
EXIT = 1
READ = 3
WRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0X80
ERROR = 0

#Zmienne#
.data 

in: .space LENGTH
out: .space LENGTH

#Stałe#
.text

END_OF_LINE = 10
LENGTH = 256
DISTANCE = 'a' - 'A'

#Main#
.global _start
_start:

 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL


movl $0, %esi
sign:
 mov $0, %ecx
 movb in(,%esi,1), %cl
 sub $'A', %ecx

function:
 inc %esi
 movb in(,%esi,1), %al
 cmp $END_OF_LINE, %al
 je end

 cmp $'A', %al
 jl notaLetter
 cmp $'z', %al
 jg notaLetter
 cmp $'Z', %al
 jle isBig

isSmall:
 sub $DISTANCE, %al
 movb %al, out(,%esi,1)
 jmp function

isBig:
 add $DISTANCE, %al
 movb %al, out(,%esi,1)
 jmp function

notaLetter:
 movb %al, out(,%esi,1)
 jmp function

end:
 movb %al, out(,%esi,1)
 movl $WRITE, %eax
 movl $STDOUT, %ebx
 movl $out, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL

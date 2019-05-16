# CODES_SECTION
EXIT = 1
READ = 3
WRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0X80
ERROR = 0

# VARIABLES_SECTION
.data

in: .space LENGTH
out: .space LENGTH

# GLOBALS_SECTION
.text

END_OF_LINE = 10
LENGTH = 256
DISTANCE = 'a' - 'A'

# MAIN
.global _start
_start:

 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL


movl $0, %esi

function:
 movb in(,%esi,1), %al
 cmp $END_OF_LINE, %al
 je end
 cmp $'Z', %al
 jle big
 sub $DISTANCE, %al
 movb %al, out(,%esi,1)
 inc %esi
 jmp function

big:
 add $DISTANCE, %al
 movb %al, out(,%esi,1)
 inc %esi
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

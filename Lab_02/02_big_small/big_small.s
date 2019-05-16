EXIT = 1
READ = 3
WRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0X80
ERROR = 0

.data #Sekcja zmiennych

.bss #Sekcja bufora
in: .space LENGTH
out: .space LENGTH

.text #Sekcja programu

END_OF_LINE = 10
LENGTH = 256
DISTANCE = 'a' - 'A'

.global _start #Symbol dla linkera, odtad zaczyna sie egzekucja programu
_start:

 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

 mov $0, %esi
 xor %eax, %eax

loop:
 movb in(,%esi,1), %al
 push $out
 push %eax
 call change_size
 pop %eax
 pop %ebx
 inc %esi
 cmp $END_OF_LINE, %al
 jne loop

 mov $WRITE, %eax
 mov $STDOUT, %ebx
 mov $out, %ecx
 mov $LENGTH, %edx
 int $SYSCALL

 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL

change_size:
 push %ebp
 mov %esp, %ebp
 mov 8(%ebp), %eax
 mov 12(%ebp), %ebx
 cmp $END_OF_LINE, %al
 je lineEnd
 cmp $'A', %al
 jl notaLetter
 cmp $'z', %al
 jg notaLetter
 cmp $'Z', %al
 jle isBig

isSmall:
 sub $DISTANCE, %al
 movb %al, (%ebx,%esi,1)
 jmp change_size_end

isBig:
 add $DISTANCE, %al
 movb %al, (%ebx,%esi,1)
 jmp change_size_end

notaLetter:
 movb %al, (%ebx,%esi,1)
 jmp change_size_end

lineEnd:
 movb %al, (%ebx,%esi,1)

change_size_end:
 mov %al, 8(%ebp)
 mov %ebp, %esp
 pop %ebp
 ret 

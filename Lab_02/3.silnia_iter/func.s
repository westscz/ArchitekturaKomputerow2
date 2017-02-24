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

 mov $READ, %eax
 mov $STDIN, %ebx
 mov $in, %ecx
 mov $LENGTH, %edx
 int $SYSCALL

 mov $0 ,%esi
 xor %eax ,%eax
 xor %ecx, %ecx

 mov $in, %ebx

AsciiDec:
 movb (%ebx,%esi,1), %cl
 cmp $END_OF_LINE, %cl
 je EndAsciiDec
 mov $10, %edx
 mul %edx
 sub $'0', %cl
 add %ecx, %eax
 inc %esi
 jmp AsciiDec
EndAsciiDec:

 mov %eax, %ebx
 mov $1, %eax
 mov $0, %ecx
Silnia:
 inc %ecx
 mul %ecx
 cmp %ebx, %ecx
 jne Silnia

 mov $LENGTH, %esi
 dec %esi
 movb $END_OF_LINE, out(,%esi,1)
 dec %esi

DecAscii:
 mov $10, %ebx
 xor %edx, %edx
 div %ebx
 add $'0', %edx
 movb %dl, out(,%esi,1)
 dec %esi
 cmp $0, %eax
 jne DecAscii

 mov $WRITE, %eax
 mov $STDIN, %ebx
 mov $out, %ecx
 mov $LENGTH, %edx
 int $SYSCALL

 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL

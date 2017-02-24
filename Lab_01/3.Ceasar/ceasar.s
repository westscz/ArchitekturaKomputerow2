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
text: .space LENGTH
out: .space LENGTH

#Stałe#
.text

END_OF_LINE = 10
LENGTH = 256
DISTANCE = 'a' - 'A'
LETTERS = 'z' - 'a' + 1
NUMBER = '0' + 1

#Main#
.global _start
_start:

movl $READ, %eax
movl $STDIN, %ebx
movl $text, %ecx 
movl $LENGTH, %edx
int $SYSCALL

TextRework:
 movl $0, %esi
 movl $0, %edi
 movl $0, %ecx
trFunction:
 movb text(,%esi,1), %cl
 cmp $END_OF_LINE, %cl
 je trEnd
 cmp $'0', %cl
 jl trSave
 cmp $'9', %cl
 jg trSave

trNumberStart:
 movb $'X', in(,%edi,1)
 inc %edi

trNumber:
 subb $NUMBER, %cl
 addb $'A', %cl
 movb %cl, in(,%edi,1)
 inc %esi
 inc %edi

trNumberNext:
 movb text(,%esi,1), %cl
 cmp $END_OF_LINE, %cl
 je trEnd
 cmp $'0', %cl
 jl trSave
 cmp $'9', %cl
 jg trSave
 jmp trNumber

trSave:
 movb %cl, in(,%edi,1)
 inc %esi
 inc %edi
 jmp trFunction
trEnd:
 movb %cl, in(,%edi,1)


movl $0, %esi

Sign:
 mov $0, %ecx
 movb in(,%esi,1), %cl

 cmp $'A', %cl
 jl end
 cmp $'z', %cl
 jg end
 cmp $'Z', %cl
 jle Decryption

Encryption:
 sub $'a', %ecx
eFunction:
 inc %esi
 movb in(,%esi,1), %al
 cmp $END_OF_LINE, %al
 je end
 
 cmp $'A', %al
 jl eNotLetter
 cmp $'z', %al
 jg eNotLetter
 cmp $'Z', %al
 jle eIsBig

eIsSmall:
 sub $DISTANCE, %al
eIsBig:
 addb %cl, %al
 cmp $'Z', %al
 jle eEnd
 subb $LETTERS, %al
eEnd:
 movb %al, out(,%esi,1)
 jmp eFunction
eNotLetter:
 movb %al, out(,%esi,1)
 jmp eFunction

Decryption:
 sub $'A', %ecx

dFunction:
 inc %esi
 movb in(,%esi,1), %al
 cmp $END_OF_LINE, %al
 je end
 
 cmp $'A', %al
 jl dNotLetter
 cmp $'z', %al
 jg dNotLetter
 cmp $'Z', %al
 jle dIsBig

dIsSmall:
 sub $DISTANCE, %al
dIsBig:
 subb %cl, %al
 cmp $'A', %al
 jge dEnd
 add $LETTERS, %al
dEnd:
 movb %al, out(,%esi,1)
 jmp dFunction
dNotLetter:
 movb %al, out(,%esi,1)
 jmp dFunction

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

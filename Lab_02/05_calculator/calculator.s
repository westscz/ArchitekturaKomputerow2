#Kody--------------------------------------------------#
EXIT = 1
READ = 3
WRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0X80
ERROR = 0
BADSIGNERROR = 1

#Zmienne------------------------------------------------#
.data 

in: .space LENGTH
temp: .space LENGTH
out: .space LENGTH

#Stałe--------------------------------------------------#
.text

LENGTH = 13
DEC = 10
HEX = 16

SPACE = 32
ENTER = 10

NUM = '0'
LETTER = 'A'

NULL = 0
FIRST = 1

RESULT=0

ADD='+'
SUB='-'
MUL='*'

OPADD=1
OPSUB=2
OPMUL=3

.global _start
_start:

Cin:
 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

 push $0
 push $0
 push $0
 push $in
 call FromAsciiConverter
 add $4, %esp

 push $0
 call Calculator
 push %eax
 add $12, %esp

 push %eax
 push $out
 push $temp
 call ToAsciiHexConverter

Stop:
 nop
 nop

Cout:
 movl $WRITE, %eax
 movl $STDOUT, %ebx
 movl $out, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

Exit:
  mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL


Warning:
 mov $EXIT, %eax
 mov $BADSIGNERROR, %ebx
 int $SYSCALL

#*****************************START**************************
FromAsciiConverter:
#************************************************************
 push %ebp
 mov %esp, %ebp
 movl 8(%ebp), %ecx
 xorl %esi, %esi

StartDec:
 mov $0, %eax
Dec:
 movb (%ecx,%esi,1), %bl
 sub $NUM, %bl
 cmp $0, %eax
 je First
 mov $10, %edx
 mul %edx 
First:
 add %ebx, %eax
 inc %esi
 mov (%ecx, %esi, 1), %bl
 cmp $SPACE, %bl
 jne Dec
EndDec:
 movl %eax, 12(%ebp)

StartSign:
 inc %esi
 movb (%ecx, %esi, 1), %bl
 cmp $ADD, %bl
 je SetAdd
 cmp $SUB, %bl
 je SetSub
 cmp $MUL, %bl
 je SetMul
 jmp Warning
SetAdd:
 movl $OPADD, 16(%ebp)
 jmp EndSign
SetSub:
 movl $OPSUB, 16(%ebp)
 jmp EndSign
SetMul:
 movl $OPMUL, 16(%ebp)
EndSign:
 add $2, %esi

StartSecondDec:
 mov $0, %eax
SecondDec:
 movb (%ecx,%esi,1), %bl
 sub $NUM, %bl	
 cmp $0, %eax
 je SecondFirst
 mov $10, %edx
 mul %edx 
SecondFirst:
 add %ebx, %eax
 inc %esi
 mov (%ecx, %esi, 1), %bl
 cmp $ENTER, %bl
 jne SecondDec
EndSecondDec:
 mov %eax, 20(%ebp)

EndFromAsciiConverter:
 mov %ebp, %esp
 pop %ebp
ret
#******************************END***************************


#*****************************START**************************
Calculator:
#************************************************************
 push %ebp
 mov %esp, %ebp

 mov 12(%ebp), %ebx
 mov 16(%ebp), %edx
 mov 20(%ebp), %eax

StartCalculator:
 cmp $OPADD, %dl
 je Adder
 cmp $OPSUB, %dl
 je Suber
 cmp $OPMUL, %dl
 je Muller

Adder:
 add %ebx, %eax
 jmp EndCalculator

Suber:
 sub %ebx, %eax
 jmp EndCalculator

Muller:
 mul %ebx
 jmp EndCalculator

EndCalculator:
 mov %eax, 8(%ebp)
 mov %ebp, %esp
 pop %ebp
ret

#******************************END***************************


#*****************************START**************************
ToAsciiHexConverter:
#************************************************************
 push %ebp
 mov %esp, %ebp
 
 movl 8(%ebp), %ecx
 movl 16(%ebp), %eax 
 xorl %esi, %esi

StartToAsciiHexConverter:
 movl $HEX, %ebx
Convert:
 mov $0, %edx
 div %ebx
Hex:
 cmp $DEC, %dl
 jl Number
 jmp Letter

Number:
 add $NUM, %dl
 movb %dl, (%ecx,%esi,1)
 jmp EndHex

Letter:
 sub $DEC, %dl
 add $LETTER, %dl
 movb %dl, (%ecx,%esi,1)

EndHex:
 inc %esi
 cmp $NULL, %eax
 je StartTurn
 jmp Convert

StartTurn:
 xorl %edi, %edi
 dec %esi
Turn:
 movl 12(%ebp), %edx
 movb (%ecx,%esi,1), %al
 movb %al, (%edx,%edi,1)
 cmp $NULL, %esi
 je EndToAsciiHexConverter
 dec %esi
 inc %edi
 jmp Turn
EndToAsciiHexConverter:
 mov %ebp, %esp
 pop %ebp
ret
#******************************END***************************



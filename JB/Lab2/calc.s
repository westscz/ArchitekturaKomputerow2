# OPIS

#Kody--------------------------------------------------#
EXIT = 1
READ = 3
WRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0X80
ERROR = 0

#Zmienne------------------------------------------------#
.data 

in: .space LENGTH
out: .space LENGTH

#Stałe--------------------------------------------------#
.text

LENGTH = 256
DEC = 10
HEX = 16

NUM = '0'
LETTER = 'A'

NULL = 0
FIRST = 1

OPADD=1
OPSUB=2
OPMUL=3

#Main---------------------------------------------------#
.global main
main:

 call Cin	

#********************
CheckOperationType:
#********************
 movb in(,%esi,1), %al
 cmp $'+', %al
 je OperationAdd
 cmp $'-', %al
 je OperationSub
 cmp $'*', %al
 je OperationMul
 
OperationAdd:
 push $OPADD
 jmp CheckOperationTypeEnd
OperationSub:
 push $OPSUB
 jmp CheckOperationTypeEnd
OperationMul:
 push $OPMUL
 jmp CheckOperationTypeEnd

CheckOperationTypeEnd:
#*************************

 call Cin
 call AsciiToDecConverter
 push %ebx 
 nop
 call Cin
 call AsciiToDecConverter

 pop %eax

#*************************
Calculator:
#*************************
 pop %edx
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
#*************************

ToHex:
xorl %esi, %esi

mov %eax, %ebx
mov $HEX, %ecx

mov $NULL, %edx
div %ecx
push %eax
mov %ecx, %edx
mul %ecx


sub %eax, %ebx
movb %bl, in(,%esi,1)

pop %eax
inc %esi
cmp $HEX, %eax
jl EndToHex
jmp ToHex
EndToHex:
movb %al, in(,%esi,1)


xorl %edi, %edi
Hex:
movb in(,%esi,1), %al
cmp $DEC, %al
jl Number
jmp Letter

Number:
add $NUM, %al
movb %al, out(,%edi,1)
jmp EndHex

Letter:
sub $DEC, %al
add $LETTER, %al
movb %al, out(,%edi,1)

EndHex:
cmp $NULL, %esi
je Cout
inc %edi
dec %esi
jmp Hex



#------------------------------------------
AsciiToDecConverter:
#-------------------
 mov $0, %ecx
 mov $0, %ebx		# Wartość decymalna

Length:
 mov %eax, %esi
 sub $2, %esi

Dec:
 mov $0, %eax
 movb in(,%esi,1), %al
 sub $'0', %al
 cmp $0, %edi
 je FirstDigit

 push %eax	# Zachowaj aktualną cyfre
 push %edi
 mov $1, %eax	# 

Pierwiastek:
 mov $DEC, %edx	# przenieś 10 do edx
 mul %edx	# 10*eax
 dec %edi
 cmp $0, %edi
 je Next
 jmp Pierwiastek
 
Next:
 pop %edi
 pop %edx
 mul %edx	# cyfra * 10^

FirstDigit:
 add %eax, %ebx
 cmp $0, %esi
 je EndDec
 dec %esi
 inc %edi 
 jmp Dec
EndDec:
ret


#********************
# Wczytanie zmiennej
#********************
Cin:

 xorl %esi, %esi						#Czyszczenie rejestru esi
 xorl %edi, %edi

 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL
 ret

#********************
# Wyświetlenie zmiennej 
#********************
Cout:
 movl $WRITE, %eax
 movl $STDOUT, %ebx
 movl $out, %ecx
 movl $LENGTH, %edx
 int $SYSCALL
 ret
#********************
# Zakonczenie programu
#********************
Exit:
 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL

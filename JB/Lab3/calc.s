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

RESULT=0

OPADD=1
OPSUB=2
OPMUL=3

##########################################################
#######################   MAIN   #########################
##########################################################
.global main
main:
	
#CIN
 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

#*****************************START**************************
CheckOperationType:
#************************************************************
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
#******************************END***************************

#CIN
 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

#*****************************START**************************
AsciiToDecConverter:
#************************************************************
 sub $2, %eax		# Liczba znakow w liczbie
 xorl %esi, %esi	# Rejestr zliczający od końca
 xorl %edi, %edi	# Rejestr zliczający od początku
 mov %eax, %esi

 mov $0, %ecx		# Zerowanie | 
 mov $0, %ebx		# Zerowanie | Wartość decymalna

Dec:
 mov $0, %eax		# Zerowanie rejestru
 movb in(,%esi,1), %al
 sub $NUM, %al		# Odjęcie znaku cyfry 0
 cmp $0, %edi		# Jeśli to pierwszy znak
 je FirstDigit
 push %eax		# Zachowaj aktualną cyfre
 push %edi		# Zachowaj aktualną pozycje

 mov $1, %eax		# przenieś 1 do eax
Base:
 mov $DEC, %edx		# przenieś 10 do edx
 mul %edx		# 10*eax
 dec %edi
 cmp $0, %edi
 je Next
 jmp Base
 
Next:
 pop %edi		# Przywróć aktualną pozycje
 pop %edx		# Cyfra do edx
 mul %edx		# cyfra * 10^

FirstDigit:
 add %eax, %ebx		# Dodaj liczbę do wyniku
 cmp $0, %esi		# Sprawdz czy to koniec
 je EndDec		
 dec %esi
 inc %edi 
 jmp Dec
EndDec:
#******************************END***************************
 push %ebx
	
#CIN
 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

#*****************************START**************************
AsciiToDecConverter2:
#************************************************************
 sub $2, %eax			# Liczba znakow w liczbie
 xorl %esi, %esi	# Rejestr zliczający od końca
 xorl %edi, %edi	# Rejestr zliczający od początku
 mov %eax, %esi

 mov $0, %ecx		# Zerowanie | 
 mov $0, %ebx		# Zerowanie | Wartość decymalna

Dec2:
 mov $0, %eax		# Zerowanie rejestru
 movb in(,%esi,1), %al
 sub $NUM, %al		# Odjęcie znaku cyfry 0
 cmp $0, %edi		# Jeśli to pierwszy znak
 je FirstDigit2
 push %eax		# Zachowaj aktualną cyfre
 push %edi		# Zachowaj aktualną pozycje

 mov $1, %eax		# przenieś 1 do eax
Base2:
 mov $DEC, %edx		# przenieś 10 do edx
 mul %edx		# 10*eax
 dec %edi
 cmp $0, %edi
 je Next2
 jmp Base2
 
Next2:
 pop %edi		# Przywróć aktualną pozycje
 pop %edx		# Cyfra do edx
 mul %edx		# cyfra * 10^

FirstDigit2:
 add %eax, %ebx		# Dodaj liczbę do wyniku
 cmp $0, %esi		# Sprawdz czy to koniec
 je EndDec2		
 dec %esi
 inc %edi 
 jmp Dec2
EndDec2:
#******************************END***************************


 push %ebx
  call Calculator
 add $8, %esp


#*****************************START**************************
ToHex:
#************************************************************
 pop %eax
 xorl %esi, %esi
 
 mov %eax, %ebx
 mov $HEX, %ecx
 mov $NULL, %edx
 div %ecx
 push %eax

 movb %dl, in(,%esi,1)

 pop %eax
 inc %esi
 cmp $HEX, %eax
 jl EndToHex
 jmp Hex
EndToHex:
 movb %al, in(,%esi,1)
 xorl %edi, %edi
Hex:
 movb in(,%esi,1), %dl
 cmp $DEC, %dl
 jl Number
 jmp Letter

Number:
add $NUM, %dl
movb %dl, out(,%edi,1)
jmp EndHex

Letter:
sub $DEC, %dl
add $LETTER, %dl
movb %dl, out(,%edi,1)

EndHex:
cmp $NULL, %esi
je Cout
inc %edi
dec %esi
jmp Hex
#******************************END***************************


Cout:
 movl $WRITE, %eax
 movl $STDOUT, %ebx
 movl $out, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

# Zakonczenie programu
 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL


##########################################################
####################FUNCTIONS BLOCK#######################
##########################################################

#*****************************START**************************
Calculator:
#************************************************************
 push %ebp
 mov %esp, %ebp

 mov 8(%ebp), %ebx
 mov 12(%ebp), %eax
 mov 16(%ebp), %edx
 
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
 mov %eax, 16(%ebp)	# Wyprowadzenie wyniku
 mov %ebp, %esp
 pop %ebp
ret

#******************************END***************************



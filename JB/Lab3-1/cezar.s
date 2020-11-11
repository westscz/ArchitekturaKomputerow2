# OPIS
# Program ma przyjmować ciąg znaków w którym pierwszy znak jest kodem przesuniecia
# W przypadku dużych liter przesuniecie ma następowac w przod
# W przypadku malych liter przesunienie ma nastepowac w tyl

# Rejestry
# %al - Wartość przesunięcia
# %bl - Aktualnie szyfrowany znak

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

END_OF_LINE = 10
LENGTH = 256
DISTANCE = 'z' - 'a' + 1
LETTER_SMALL = 'a' - 1
LETTER_BIG = 'A' - 1

#Main---------------------------------------------------#
.global main
main:

 xorl %esi, %esi						#Czyszczenie rejestru esi

#********************
# Wczytanie zmiennej
#********************
Cin:
 movl $READ, %eax
 movl $STDIN, %ebx
 movl $in, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

 push $in

#********************
# Wykrywanie kierunku szyfrowania
#********************
LeterSize:
 movb in(,%esi,1), %al
 cmp $'Z', %al
 jle LetterBig
 cmp $'z', %al
 jle LetterSmall

LetterBig:
 cmp $'A', %al
 jge Encryption

LetterSmall:
 cmp $'a', %al
 jge Decryption

#********************
# Szyfrowanie
#********************
Encryption:
 subb $LETTER_BIG, %al

NextEn:
 incl %esi
 movb in(,%esi,1), %bl
 cmpl $END_OF_LINE, %ebx
 je Cout
 and $0b11011111, %bl
 
 cmp $'A', %bl
 jl NextEn
 cmp $'Z', %bl
 jg NextEn

 add %al, %bl
 cmp $'Z', %bl
 jg DownScale
 jmp BackEn

DownScale:
 sub $DISTANCE, %bl
 jmp BackEn

BackEn:
 movb %bl, out(,%edi,1)
 incl %edi
 cmpl %ebx, %edi
 jle NextEn

#********************
# Deszyfrowanie
#********************
Decryption:
 subb $LETTER_SMALL, %al

NextDe:
 incl %esi
 movb in(,%esi,1), %bl
 cmpl $END_OF_LINE, %ebx
 je Cout
 and $0b11011111, %bl				# 0b 1101 1111
 cmp $'A', %bl
 jl NextDe
 cmp $'Z', %bl
 jg NextDe
 subb %al, %bl
 cmp $'A', %bl
 jl UpScale
 jmp BackDe

UpScale:
 add $DISTANCE, %bl
 jmp BackDe

BackDe:
 movb %bl, out(,%edi,1)
 incl %edi
 cmpl %ebx, %edi
 jle NextDe

#********************
# Wyświetlenie zmiennej 
#********************
Cout:
 movl $WRITE, %eax
 movl $STDOUT, %ebx
 movl $out, %ecx
 movl $LENGTH, %edx
 int $SYSCALL

#********************
# Zakonczenie programu
#********************
Exit:
 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL


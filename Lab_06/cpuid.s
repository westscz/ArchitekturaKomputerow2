EXIT = 1
READ = 3
WRITE = 4

STDIN = 0
STDOUT = 1

SYSCALL = 0X80
ERROR = 0

.data #Sekcja zmiennych

.bss #Sekcja bufora

.text #Sekcja programu

LENGTH = 32

.global _start #Symbol dla linkera, odtad zaczyna sie egzekucja programu
_start:

 mov $2, %eax
 cpuid
 
 mov $EXIT, %eax
 mov $ERROR, %ebx
 int $SYSCALL

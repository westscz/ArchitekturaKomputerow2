SYSCALL32 = 0x80
EXIT = 1
STDIN = 0
STDOUT = 1
READ = 3
WRITE = 4

BUF_SIZE = 254
DISTANCE = 'z' - 'a'+1
COMPL = 'z'+'a'

.data
TEXT_SIZE: .long 0
BUFOR: .space BUF_SIZE


.text
.globl _start
_start:

movl $READ, %eax
movl $STDIN, %ebx
movl $BUFOR, %ecx
movl $BUF_SIZE, %edx
int $SYSCALL32

movl %eax, TEXT_SIZE

call ENCRYPT

movl $WRITE, %eax
movl $STDOUT, %ebx
movl $BUFOR, %ecx
movl $TEXT_SIZE, %edx
int $SYSCALL32

ENCRYPT:
movl $0, %edi
movb BUFOR(,%edi,1), %bl
or $0x40, %bl
cmpb $'z', %bl
jbe szyfruj
subb $COMPL, %bl
negb %bl
szyfruj:
incl %edi
movb BUFOR(,%edi,1), %al
orb $0x20, %al
cmpb $'Z', %al
ja error
subb $'A', %al
jb error
addb %bl, %al
cmpb $'Z', %al
jbe cykl
subb $DISTANCE, %al
cmpl TEXT_SIZE, %edi
jbe cykl
ret
error:
ret

SYSEXIT      = 1
SYSREAD      = 3
SYSWRITE     = 4
STDIN        = 0
STDOUT       = 1
EXIT_SUCCESS = 0

.align 32

.data
  .comm tekst, 50000
  tekst_len = 50000

.global _start
_start:
  mov $0,%edi

loop_read:
  mov $SYSREAD, %eax
  mov $STDIN, %ebx
  mov $tekst, %ecx
  add %edi, %ecx
  mov $tekst_len, %edx
  int $0x80

  add %eax, %edi
  cmpl $1,%eax
  je write
  jmp loop_read

write:
  add $-2,%edi
  add $tekst,%edi
  movb $0,1(%edi)
  mov $0, %esi
  
petlawrite:
  cmpl $tekst,%edi
  je powrite
  
  add $-1,%edi
  add $1, %esi
  cmpb $10,(%edi)
  jne petlawrite
  
  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov %edi, %ecx
  add $1, %ecx
  mov %esi, %edx
  mov $0,%esi
  int $0x80

  jmp petlawrite
powrite:

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov $tekst, %ecx
  mov %esi, %edx
  int $0x80


  mov $SYSEXIT, %eax
  mov $EXIT_SUCCESS, %ebx
  int $0x80

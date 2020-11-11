SYSEXIT      = 1
SYSREAD      = 3
SYSWRITE     = 4
STDIN        = 0
STDOUT       = 1
EXIT_SUCCESS = 0

.align 32

.data

msg_tekst: .ascii "       \n"
msg_tekst_len = . - msg_tekst

.text

.global _start

_start:
  mov $SYSREAD, %eax
  mov $STDIN, %ebx
  mov $msg_tekst, %ecx
  mov $msg_tekst_len, %edx
  int $0x80

  mov $SYSWRITE, %eax
  mov $STDOUT, %ebx
  mov $msg_tekst, %ecx
  mov $msg_tekst_len, %edx

  int $0x80

  mov $SYSEXIT, %eax
  mov $EXIT_SUCCESS, %ebx
  int $0x80

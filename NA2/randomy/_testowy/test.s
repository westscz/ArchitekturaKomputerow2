.text
  buf: .ascii "Hello!\n"
.global _start

_start:
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $7, %rdx
	syscall
_break:
	mov $60, %rax
	mov $0, %rdi
	syscall

.data
	buf: .ascii "0"
.text
	A: .quad 15
	B: .quad 30
.global _start
_start:
	mov $A, %rax
	mov $B, %rbx
	call add
	mov %rax, %r8

loop:
	mov $0, %rdx
	mov %r8, %rax
	mov $10, %rcx
	div %rcx
	mov %rax, %r8
	movb %dl, (buf)
	addb $48, (buf)
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall

	cmp $0, %r8
	jne loop
	movb $0xA, (buf)
	mov $1, %rax
	mov $1, %rdi
	mov $buf, %rsi
	mov $1, %rdx
	syscall

	mov $60, %rax
	mov $0, %rdi
	syscall

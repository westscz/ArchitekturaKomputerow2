.global add
add:
	mov %rsi, %rcx
	mov $0, %rax
add_loop:
	dec %rcx
	pushf #wrzucenie flagi na stos
	add (%rdi, %rcx, 8), %rax
	popf #zrzucamy flagi
	jnz add_loop
	ret

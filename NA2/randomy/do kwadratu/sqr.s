.global sqr
sqr:
	mov %rdi, %r15
	mov %rsi, %r14
	mov %rsi, %rax
	mov $0, %rdx
	mov $4096, %rcx
	div %rcx
	inc %rax
	mov $4096, %rcx
	mul %rcx #mnozenie
#mmap
	mov %rax, %rsi
	mov $9, %rax
	mov $0, %rdi
	mov $0x3, %rdx
	mov $0x22, %r10
	mov $0, %r8
	mov $0, %r9
	syscall
	
	mov %r14, %rcx
	
sqr_loop:
	dec %rcx
	pushf # zrzut flag na stos
	push %rax #zrzut wskaznika z rax na stos
	mov (%r15, %rcx, 8), %rax
	mov %rax, %rbx
	mul %rbx
	mov %rax, %rbx
	pop %rax
	mov %rbx, (%rax, %rcx, 8)
	popf
	jnz sqr_loop
	ret

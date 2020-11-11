.global add
add:
	mov (%rax), %rax
	add (%rbx), %rax
	ret

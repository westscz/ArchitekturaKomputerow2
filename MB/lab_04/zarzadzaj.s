.data
	dane: .word
.global zarzadzaj
.text

zarzadzaj:
	mov %rdi, %rax
	shl $8, %rax
	or $0xff, %al
	mov %ax, dane
	fldcw dane
exit:
	ret

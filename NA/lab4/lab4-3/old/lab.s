.align 16

.section .rodata
format:
	.string "%s %s %s %s %s %s %s\n"
hello:
	.string "hello"
world:
	.string "world"
ty:
	.string "ty"
kurwo:
	.string "kurwo"
hehe:
	.string "hehe"
beniz:
	.string "beniz"

	.size skytower, 9
skytower:
	.string "skytower"
wroclaw:
	.string "wroclaw"

.text
.globl main


main:
	movq %rsp, %rbp
	subq $32, %rsp
	movl $format, %edi
	movl $hello, %esi
	movl $world, %edx
	movl $ty, %ecx
	movl $kurwo, %r8d
	movl $hehe, %r9d

	movl $skytower, 8(%rsp)
	movl $beniz, (%rsp)
	

	movl $0, %eax
	call printf

	movl $0, %eax
	call exit
	

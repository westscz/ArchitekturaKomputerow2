.data
.global urdtsc
.text

urdtsc:
	cmp $0, %rdi
	jne else
prawda:	
	CPUID
	RDTSC
	shl $32, %rdx
	add %rdx, %rax
	jmp exit
else:
	RDTSCP
	shl $32, %rdx
	add %rdx, %rax
exit:
	ret

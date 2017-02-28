.data
.global urdtsc
.text

urdtsc:
	RDTSC
	movl $0, %ebx
	RDTSC
	ret

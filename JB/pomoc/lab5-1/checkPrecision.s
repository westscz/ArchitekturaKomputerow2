.file "checkPrecision.s"

.bss
.align 4
result:
	.zero 2

.text
.globl checkPrecision

checkPrecision:
	xorq %rax, %rax

	fstcw result		#load fpu status word
	movw result, %ax
	_afterLoad:

	xorq %rcx, %rcx		#zeroe the rcx register
	movw $0x0300, %cx	#use as mask for 8 and 9 bit
	andw %cx, %ax		#mask the status word
	_masked:
	shr $8, %ax
	_shifted:
	ret

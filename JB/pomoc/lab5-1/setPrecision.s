.file "setPrecision.s"

.bss
.align 4
result:
	.zero 2

.text
.globl setPrecision

setPrecision:
	xorq %rax, %rax

	fstcw result		#load fpu status word
	movw result, %ax
	_afterLoad:

	xorq %rcx, %rcx		#zeroe the rcx register
	
	#zeroe the 8th and 9th bits
	movw $0xfcff, %cx
	andw %cx, %ax
	xorq %rcx, %rcx


	movw %di, %cx		#use as mask for 8 and 9 bit
	_bfSh:
	shl $8, %cx
	_afSh:
	xorw %cx, %ax		#mask the status word
	
	movw %ax, result
	fldcw result
	ret

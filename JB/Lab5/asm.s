.data
precision: .ascii "Utrata precyzji\n\0"	#5
underflow: .ascii "Wartosc za mala\n\0"	#4
overflow: .ascii "Wartosc jest za duza\n\0"#3
zero: .ascii "Dzielenie przez zero\n\0"	#2
denormalized: .ascii "Liczba zdenormalizowana\n\0"#1

#div zero
#num1: .float 0.0
#num2: .float 5.0

#add utrata precyzji
#num1: .float 99999999999999999999999999999.9
#num2: .float 9.9999999999999999999

# zdenormalizowana
num1: .float 0.0
num2: .int 1

.text
.globl main
	
main:
	fld num1
	fld num2

	xor %eax, %eax
	fstsw %ax
	fwait

checkPrecision:
	movl $0x20, %ebx
	test %eax, %ebx
	jnz showMsgPrec
checkUnderflow:
	movl $0x10, %ebx
	test %eax, %ebx
	jnz showMsgUnderflow
checkOverflow:
	movl $0x8, %ebx
	test %eax, %ebx
	jnz showMsgOverflow
checkZero:
	movl $0x4, %ebx
	test %eax, %ebx
	jnz showMsgZero
chechDenormalized:
	movl $0x2, %ebx
	test %eax, %ebx
	jnz showMsgDenormalized
end:
	mov $1, %eax
	mov $0, %ebx
	int $0x80

showMsgPrec:
	pushl %eax
	pushl $precision
	call printf
	add $4, %esp
	pop %eax
	jmp checkUnderflow
showMsgUnderflow:
	pushl %eax
	pushl $underflow
	call printf
	add $4, %esp
	pop %eax
	jmp checkOverflow
showMsgOverflow:
	pushl %eax
	pushl $overflow
	call printf
	add $4, %esp
	pop %eax
	jmp checkZero
showMsgZero:
	pushl %eax
	pushl $zero
	call printf
	add $4, %esp
	pop %eax
	jmp chechDenormalized
showMsgDenormalized:
	pushl %eax
	pushl $denormalized
	call printf
	add $4, %esp
	pop %eax
	jmp exit

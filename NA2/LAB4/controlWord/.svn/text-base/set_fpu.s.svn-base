.global set_fpu

.type set_fpu, @function

set_fpu:
	pushq %rbp
	movq %rsp, %rbp
	fnstcw -8(%rbp)
	
	movw -8(%rbp), %ax
	or $0x0F00, %ax

	cmp $1, %rdi
	je singleDown

	cmp $2, %rdi
	je singleUp

	cmp $3, %rdi
	je singleNearest

	cmp $4, %rdi
	je singleZero
	
	cmp $5, %rdi
	je doubleDown

	cmp $6, %rdi
	je doubleUp
	
	cmp $7, %rdi
	je doubleNearest

	cmp $8, %rdi
	je doubleZero 

singleDown:
	and $0xf4ff, %ax
	jmp end
singleUp:
	and $0xf8ff, %ax
	jmp end
singleNearest:
	and $0xf0ff, %ax
	jmp end
singleZero:
	and $0xfCff, %ax
	jmp end
doubleDown:
	and $0xf6ff, %ax
	jmp end
doubleUp:
	and $0xfAff, %ax
	jmp end
doubleNearest:
 	and $0xf2ff, %ax
	jmp end
doubleZero:
	and $0xfEff, %ax
	jmp end

end:
	movw %ax, -8(%rbp)
	fldcw -8(%rbp)

	popq %rbp	




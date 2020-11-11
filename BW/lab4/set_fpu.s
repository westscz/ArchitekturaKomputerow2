	/*
		8 i 9 bit odpowiadają za precyzje (Precision Control)
		Poszczególne oznaczenia:
		00 - single precision(24bits)
		01 - zarezerwowany (cokolwiek to znaczy)
		10 - double precision(53bits)
		11 - double extended precision (64 bits)
		
		10 i 11 odpowiadaja za zaokraglenia (Round Control)
		Poszcegolne oznaczenia:
		00 - zaokrąglij do najbliższej
		01 - zaokraglij do -inf
		10 - zaokraglij do +inf
		11 - utnij
		12 bit jest dla kompatybilności z poprzednia wersja
	*/
	
	
	.globl	set_fpu
	.type	set_fpu, @function
set_fpu:
	pushq %rbp
	movq %rsp,%rbp
	fstcw -16(%rbp)
	mov -16(%rbp),%rbx
	and $0xf3ff,%rbx	
	orw %rdi,%rbx
	mov %rbx,-16(%rbp)
	fldcw -16(%rbp)
	popq %rbp
	ret
	
.text
.globl add
add:
 push %ebp
 mov %esp, %ebp
 movl 8(%ebp), %eax	#Argument 1
 movl 12(%ebp), %ebx	#Argument 2

 add %ebx, %eax

 movl %eax, 8(%ebp)	#Wynik
 mov %ebp, %esp
 pop %ebp
ret
	

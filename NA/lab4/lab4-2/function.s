.file "function.s"

.text
.globl multiply

multiply:
	pushq %rbp				#save whatever is in rbp
	movq %rsp, %rbp			#set new stack frame
	movl %edi, -4(%rbp)		#move first argument to stack
	movl %esi, -8(%rbp) 	#move second argument to stack
	movl -4(%rbp), %eax		#move first number to eax
	imull	-8(%rbp), %eax	#multiply numbers
	popq %rbp				#restore rbp value
	ret 					#return function
	
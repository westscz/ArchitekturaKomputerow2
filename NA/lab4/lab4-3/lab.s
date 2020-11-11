.section .rodata

InputPrompt:
	.string "Podaj dwie liczby calkowite do przemnozenia\n"
InputFormat:
	.string "%d %d"
OutputFormat:
	.string "Wynik: %d\n"


.text
.globl main
main:
	#prompt user to input 2 numbers
	movl $0, %eax				#eax has to be zeroeds
	movq $InputPrompt, %rdi		#pass format string address as first argument
	call printf					#call C function printf

	#get user input using C function - scanf
	movq %rsp, %rbp				#save current stack pointer to base pointer
	subq $8, %rsp				#allocate space for 2 integers
	movq $InputFormat, %rdi 	#pass input format as first argument
	leaq -8(%rbp), %rsi			#pass first 4 allocated bits address as second argument
	leaq -4(%rbp), %rdx			#pass next 4 allocated bits address as third argument
	movl $0, %eax				#eax has to be zeroed
	call scanf					#call C function scanf

	#use remote function to multiply numbers
	#move read numbers addresses to appropiate registers
	movq -8(%rbp), %rdi				#first argument
	movq -4(%rbp), %rsi 			#second argument
	bfmult:
	call multiply				#call custom C function
								#the result has been stored in eax register

	afmult:
	#print the result 
	movq $OutputFormat, %rdi	#pass OutputFormat string address as first argument
	movl %eax, %esi 			#pass multiply result as second address
	movq $0, %rax				#rax has to be zeroed
	call printf


	#exit program with status 0
	movl $0, %eax
	call exit

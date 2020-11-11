.text
	filename: .ascii "plik.txt\0"
.global _start
_start:
#open pliku
	mov $2, %rax
	mov $filename, %rdi
	mov $02, %rsi
	syscall
#map
	mov %rax, %r8 
	mov $9, %rax
	mov $0, %rdi
	mov $4096, %rsi
	mov $0x3, %rdx
	mov $0x1, %r10
	mov $0, %r9	
	syscall

	mov $0, %rcx
#zamiana liter na wielkie
loop:
	mov (%rax,%rcx,1), %r8b #przenoszenie literek
	inc %rcx
	cmp $0, %r8b #sprawdzamy, czy nie skonczylismy juz przenoszenia literek
	je exit
	cmp $97, %r8b #wieksi od malej a
	jl loop
	cmp $122, %r8b #mniejsi od malej z
	jg loop
	sub $32, %r8b
	mov %r8b, -1(%rax, %rcx,1) #umieszczamy spowrotem tam gdzie byly
	jmp loop

exit:
#unmap
	mov %rax, %rdi
	mov $11, %rax
	mov $4096, %rsi
	syscall
	mov $60, %rax
	mov $0, %rdi	
	syscall

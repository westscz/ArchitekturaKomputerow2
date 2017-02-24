.global _adding #Symbol dla linkera, odtad zaczyna sie egzekucja programu
_adding:
 pushq %rbp
 movq %rsp, %rbp
 
 mov $0, %rcx
 mov (%rdi, %rcx, 8), %rax

 movq %rbp, %rsp
 pop %rbp
ret


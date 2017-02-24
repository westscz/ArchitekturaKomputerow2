.text #Sekcja programu
.globl silnia #Symbol dla linkera, odtad zaczyna sie egzekucja programu
silnia:
 pushq %rbp
 movq %rsp, %rbp
 movq %rdi, %rbx  
 
 mov $1, %eax
 mov $0, %ecx
Silnia_func:
 inc %ecx
 mul %ecx
 cmp %ebx, %ecx
 jne Silnia_func

 movq %rbp, %rsp
 pop %rbp
ret

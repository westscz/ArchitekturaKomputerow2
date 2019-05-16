# program_section
.text

# symbol for linker, here starts function
.globl silnia
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

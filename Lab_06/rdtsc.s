.global _rdtsc #Symbol dla linkera, odtad zaczyna sie egzekucja programu
_rdtsc:
 pushq %rbp
 movq %rsp, %rbp

 rdtsc

 movq %rbp, %rsp
 pop %rbp
ret


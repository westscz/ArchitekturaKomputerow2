.data
controlword: .short
.text
.globl get_control_word
get_control_word:
  push %rbp
  movq %rsp, %rbp

  fstcw	controlword
  fwait
  mov	controlword, %ax
  

  movq %rbp, %rsp
  pop %rbp
ret



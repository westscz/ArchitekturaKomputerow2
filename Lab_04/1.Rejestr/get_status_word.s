.data
statusword: .short 0
err_precision: .ascii "Blad - Utrata precyzji\n"
err_overflow: .ascii "Blad - Nadmiar\n"
err_underflow: .ascii "Blad - Niedomiar\n"
err_divide: .ascii "Blad - Dzielenie przez zero\n\0"
err_denormal: .ascii "Blad - Liczba zdenormalizowana\n"
err_operation: .ascii "Blad - Niepoprawna operacja\n"

.text
.globl get_status_word
get_status_word:
  push %rbp
  movq %rsp, %rbp

  fld1
  fldz
  fdivrp

  fstsw	statusword
  fwait
  mov	statusword, %bx

  mov $1, %cl
  and $0, %rax
check_operation:
  shr %rbx
  jnc check_denormal
  leaq err_operation, %rdi
  call printf

check_denormal:
  shr %rbx
  jnc check_divide
  leaq err_denormal, %rdi
  call printf

check_divide:
  shr %rbx
  jnc check_overflow
  leaq err_divide, %rdi
  call printf

check_overflow:
  shr %rbx
  jnc check_underflow
  leaq err_overflow, %rdi
  call printf

check_underflow:
  shr %rbx
  jnc check_precision
  leaq err_underflow, %rdi
  call printf

check_precision:
  shr %rbx
  jnc return_status
  leaq err_precision, %rdi
  call printf

return_status:
  mov statusword, %ax
  and $0x000000FF, %eax

  movq %rbp, %rsp
  pop %rbp
ret



.data
controlword: .short
prec24: .ascii "Precyzja 24 bitowa\n\0" #00
precerr: .ascii "Blad precyzji\n\0"	#01
prec53: .ascii "Precyzja 53 bitowa\n\0"	#10
prec64: .ascii "Precyzja 64 bitowa\n\0"	#11

roundnear: .ascii "Zaokraglenie do najblizszego\n\0"	#00
rounddown: .ascii "Zaokraglenie w dol\n\0"		#01
roundup: .ascii "Zaokraglenie w gore\n\0"		#10
truncate: .ascii "Bez reszty\n\0"			#11

.text
.globl get_control_word
get_control_word:
  push %rbp
  movq %rsp, %rbp

  fstcw	controlword
  fwait
  mov	controlword, %bx

precision:
  mov $8, %cl
  shr %rbx
  jnc precision_bit_zero
precision_bit_one: 
  mov $1, %cl
  shr	%rbx
  jc precision_64
precision_err:
  leaq precerr, %rdi
  call printf
  jmp round
precision_64:
  leaq prec64, %rdi
  call printf
  jmp round
precision_bit_zero:
  mov $1, %cl
  shr	%rbx
  jnc precision_24
precision_53:
  leaq prec53, %rdi
  call printf
  jmp round
precision_24:
  leaq prec24, %rdi
  call printf

round:
  shr %rbx
  jnc round_bit_zero

round_bit_one: 
  mov $1, %cl
  shr %rbx
  jc round_truncate
round_down:
  leaq rounddown, %rdi
  call printf
  jmp exit
round_truncate:
  leaq truncate, %rdi
  call printf
  jmp exit

round_bit_zero:
  mov $1, %cl
  shr %rbx
  jnc round_near
round_up:
  leaq roundup, %rdi
  call printf
  jmp exit
round_near:
  leaq roundnear, %rdi
  call printf

exit:
  movq %rbp, %rsp
  pop %rbp
ret



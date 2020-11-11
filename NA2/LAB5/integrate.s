.globl integrate	
.type  integrate, @function

.data
range:
	.float 0.0
#zmiennaDebug:
#	.float 0.0
from:
	.float 0.0
iter:
	.int 0

	.align 16
vec:
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0
vec4:
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0
result:
	.float 0.0
	.float 0.0
	.float 0.0
	.float 0.0
.text

integrate:
	pushq	%rbp
	movq	%rsp, %rbp

#-------------------------------------#
# Parametry: od / do / ilosc iteracji #
#-------------------------------------#	
	movsd	%xmm0,  -8(%rbp) 	
	movsd	%xmm1, -16(%rbp) 
	mov		%rdi,  -24(%rbp)

#--------------------------------#
# Obliczenie dlugosci przedziału #
#--------------------------------#
	fldl	 -8(%rbp) 	#od
	fst from			#od
	fldl	-16(%rbp) 	#do
	fsubp	%st(1)		#do-od
	fild	-24(%rbp)	#iter
	fdivrp	%st(1)		#(do-od)/iter
	fstp  range			#(do-od)/iter

	movss range, %xmm7	#(do-od)/iter
	movss range, %xmm6	#(do-od)/iter
	addss from,  %xmm6	#a+(do-od)/iter
#		movss %xmm6, zmiennaDebug

#------------------------------------#
# inicjalizacja wektorow i zmiennych #
#------------------------------------#
	mov $0, %rsi
	movss %xmm6, vec(,%rsi,4)
#		movss %xmm6, zmiennaDebug
	mov $1, %rsi
	addss range, %xmm6
	movss %xmm6, vec(,%rsi,4)
#		movss %xmm6, zmiennaDebug
	mov $2, %rsi
	addss range, %xmm6
	movss %xmm6, vec(,%rsi,4)
#		movss %xmm6, zmiennaDebug
	mov $3, %rsi
	addss range, %xmm6
	movss %xmm6, vec(,%rsi,4)
#		movss %xmm6, zmiennaDebug

	movaps vec, %xmm1

	addss range, %xmm7
	addss range, %xmm7
	addss range, %xmm7
	mov $0, %rsi
	movss %xmm7, vec4(,%rsi,4)
#		movss %xmm7, zmiennaDebug
	mov $1, %rsi
	movss %xmm7, vec4(,%rsi,4)
#		movss %xmm7, zmiennaDebug
	mov $2, %rsi
	movss %xmm7, vec4(,%rsi,4)
#		movss %xmm7, zmiennaDebug
	mov $3, %rsi
	movss %xmm7, vec4(,%rsi,4)
#		movss %xmm7, zmiennaDebug

	movaps vec4, %xmm2

	mov $0, %rsi
	mov $4, %ecx
	div %ecx
	mov %eax, %edi	#iter/4 poniewaz dodajemy po 4 wektory
	
loop:
	rcpps %xmm1, %xmm3
#		movss %xmm3, zmiennaDebug
	addps %xmm3, %xmm4
#		movss %xmm4, zmiennaDebug
	addps %xmm2, %xmm1	
#		movss %xmm1, zmiennaDebug

	add $1, %rsi	
	cmp %rsi, %rdi
	je end
	jmp loop
end:
	movaps %xmm4, result	
	
	mov $0, %rsi
	movss result(,%rsi,4), %xmm5
	mov $1, %rsi
	addss result(,%rsi,4), %xmm5
	mov $2, %rsi
	addss result(,%rsi,4), %xmm5	
	mov $3, %rsi
	addss result(,%rsi,4), %xmm5
	
	mulss  range,%xmm5
	movaps %xmm5,%xmm0

	popq	%rbp
	ret

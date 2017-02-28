/*
    Dodawanie duzych liczb w pamieci z przeniesieniem

    GDB PODSTAWA! Nie ogarniesz GDB = nie ogarniesz jak to dobrze "usadzić" w pamięci!
*/

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
MAX_ROZM_WYNIKU = 1024
.align 32
.data
	liczba1: .quad 0x0102030405060708, 0x0910111213141516, 0x1718192021222324, 0x2526272829303132, 0xf2ffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0x0000000000000011
	l1_rozm = .-liczba1
	liczba2: .quad 0x0102030405060708, 0xff10111213141516, 0x1718192021222324, 0x2526272829303132, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff
	l2_rozm = .-liczba2
	wynik: .space MAX_ROZM_WYNIKU
.text
.global main
main:
	xor %r9, %r9
	mov $l1_rozm, %r15
	mov $l2_rozm, %r14
	cmp %r14, %r15
	jg l1_wieksze
	mov $l2_rozm, %r10
	jmp wczytywanie_l1

l1_wieksze:
	mov $l1_rozm, %r10
	
wczytywanie_l1:
	xor %rax, %rax
	cmp $0, %r15
	je wczytywanie_l2
	sub $8, %r15
	mov liczba1(,%r15, 1), %rax

wczytywanie_l2:
	xor %rbx, %rbx
	cmp $0, %r14
	je dodawanie
	sub $8, %r14
	mov liczba2(,%r14, 1), %rbx


dodawanie:
	cmp $1, %r9
	je ustal_carry
	clc

dodawanie_dalej:
	adc %rbx, %rax
	jc zapisz_carry
	xor %r9, %r9
zapisz_do_pamieci:
	cmp $MAX_ROZM_WYNIKU, %r10
	jg exit
	sub $8, %r10
	mov %rax, wynik(,%r10,1) 
	cmp $0, %r10
	je exit

	jmp wczytywanie_l1

ustal_carry:
	stc
	jmp dodawanie_dalej

zapisz_carry:
	mov $1, %r9
	jmp zapisz_do_pamieci

exit:
	mov $SYSEXIT, %rax
wynik_break:
	mov $EXIT_SUCCESS, %rbx
	int $0x80

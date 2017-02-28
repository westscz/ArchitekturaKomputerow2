.data
	jedeng: .word 1
	xg: .float 2.0
.global gx
.text

gx:
	movsd %xmm0, xg
	fld xg
	fld %st(0)
	fmulp
	mov $1, %rax
	mov %ax, jedeng
	fild jedeng
	faddp
	fsqrt
	fild jedeng
	faddp
	fld xg
	fld %st(0)
	fmulp
	fdivp
	fst xg
wyjscieg:
	movsd (xg), %xmm0
	ret

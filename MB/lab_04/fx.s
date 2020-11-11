.align 32
.data
	jeden: .word 1
	x: .float 2.0
.global fx
.text

fx:
	movsd %xmm0, x
	fld x
	fld %st(0)
	fmulp
	fild jeden
	faddp
	fsqrt
	fild jeden
	fxch
	fsubp
	fst x
wyjscie:
	movsd (x), %xmm0
	ret

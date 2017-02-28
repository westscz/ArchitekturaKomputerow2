.data
	wynik: .float 0, 0
	przesuniecie: .float 0.0, 0.5
	mnoznik: .float 0.5, 0.5
	x: .float 0, 0
.global szybciej
.text

szybciej:
	movss %xmm0, x
	movss %xmm0, x+4
	movss %xmm1, przesuniecie+4
	movss %xmm1, mnoznik
	movss %xmm1, mnoznik+4

mmxy:
	movq x, %xmm0
	movq przesuniecie, %xmm1
	addps %xmm1, %xmm0
	movq %xmm0, wynik
	
po_dzialaniach:

	fld wynik
	fsin
	fabs
	fstp wynik

	fld wynik+4
	fsin
	fabs
	fstp wynik+4

mmxy2:
	movq wynik, %xmm0
	movq mnoznik, %xmm1
	mulps %xmm1, %xmm0
	movq %xmm0, wynik

dodawanie:
	fld wynik
	fld wynik+4
	faddp
	fstp wynik
exit:
	movd wynik, %xmm0 


	ret

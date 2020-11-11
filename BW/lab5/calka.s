	.align 32
	.globl calka
	.data
		zmienna1: .float 0.0
		zmienna2: .float 0.0
		zmienna3: .float 0.0
		zmienna4: .float 0.0
		zwiekszenie1: .float 0.0
		zwiekszenie2: .float 0.0
		zwiekszenie3: .float 0.0
		zwiekszenie4: .float 0.0
		dzielna1: .float 1.0
		dzielna2: .float 1.0
		dzielna3: .float 1.0
		dzielna4: .float 1.0
		dlugoscSkoku1: .float 0.0
		dlugoscSkoku2: .float 0.0
		dlugoscSkoku3: .float 0.0
		dlugoscSkoku4: .float 0.0
		iloscOperacjiWykonywanychNaRaz: .word 4
		wynik: .float 0.0,0.0,0.0,0.0
		od: .float 0.0
		do: .float 0.0
		iloscKrokow: .long 0
		aktualnyNumerPetli: .long 0
	.type calka, @function
	.text
calka:
	movsd %xmm0,od
	movsd %xmm1, do
	mov %rdi,iloscKrokow
	/*obliczam dlugosc skoku*/
obliczSkok:	
	fld od					/*laduje do rejestru wartosc poczatku calki*/
	fld do					/*laduje do rejestru wartosc koncowa calki*/
	fsubp					/*odejmuje je*/
	fildl iloscKrokow		/*do rejestru wrzucam ile krokow ma byc zrobione*/	
	fdivrp 					/*dziele aby otrzymac jaka ma byc dlugosc skoku*/
ustawDlugosciSkoku:
	fst dlugoscSkoku1
	fst dlugoscSkoku2
	fst dlugoscSkoku3
	fstp dlugoscSkoku4		/*przenosze do zmiennej dlugosc skoku*/
	shr $2,%rdi				/*petle wykonam szybciej poniewaz bede pakowal bo dwie liczby do rejestru*/
obliczRozniceZmiennych:	
	movsd %xmm0,zmienna1
	fld od
	fld dlugoscSkoku1
	faddp
	fst zmienna2
	fld dlugoscSkoku1
	faddp
	fst zmienna3
	fld dlugoscSkoku1
	faddp
	fstp zmienna4
obliczPrzesuniecie:	
	fld dlugoscSkoku1
	fild iloscOperacjiWykonywanychNaRaz
	fmulp
	fst zwiekszenie1
	fst zwiekszenie2
	fst zwiekszenie3
	fstp zwiekszenie4
zaladujDane:
	movups zwiekszenie1,%xmm1
	movups zmienna1,%xmm0
	movups dlugoscSkoku1,%xmm4
	movups dzielna1,%xmm2
	mov %edi,%eax
petla:
	dec %eax
	cmp $0,%eax
	je koniec
	movaps %xmm2,%xmm6		/*kopiuje zawartosc xmm0 gdzie sa aktualne poczatku X*/
	divps %xmm0,%xmm6		/*wykonuje operacje 1/x*/
	mulps %xmm4,%xmm6		/*mnoze aby obliczyc pole*/
	addps %xmm6,%xmm5		/*dodaje pole do wyniku*/
	addps %xmm1,%xmm0		/*przechodze na nastepne X*/
	jmp petla
koniec:	
	haddps %xmm5,%xmm5		/*zsumuj dane*/
	haddps %xmm5,%xmm5		/*ponownie zsumuj dane tak aby otrzymac wynik w jednej zmiennej rozszerzenia wektorowego*/
	movsd %xmm5,%xmm0		/*przenies wynik do rejestru wynikowego*/
	ret
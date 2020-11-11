	.align 32
	.globl calka
	.data
		dzielna: .word 1
		wynik: .float 0.0
		od: .float 0.0
		do: .float 0.0
		iloscKrokow: .long 0
		dlugoscSkoku: .float 0.0
		aktualnyNumerPetli: .long 0
	.type calka, @function
	.text
calka:
	movsd %xmm0,od
	movsd %xmm1, do
	mov %rdi,iloscKrokow
obliczSkok:
	fld od					/*laduje do rejestru wartosc poczatku calki*/
	fld do					/*laduje do rejestru wartosc koncowa calki*/
	fsubp					/*odejmuje je*/
	fildl iloscKrokow		/*do rejestru wrzucam ile krokow ma byc zrobione*/	
	fdivrp 					/*dziele aby otrzymac jaka ma byc dlugosc skoku*/
	fstp dlugoscSkoku		/*przenosze do zmiennej dlugosc skoku*/
	mov iloscKrokow,%eax	/*eax jako licznik petli*/
	mov %eax,aktualnyNumerPetli
	inc %eax
petla:
	dec %eax
	cmp $0,%eax				/*sprawdzam czy koniec wykonywania*/
	je koniec				/*jezeli koniec to wychodze z petli*/
	movl %eax,aktualnyNumerPetli/*przenosze aktualna wartosc eax do zmiennej bo do rejestrow fpu musze wrzucac z pamieci*/
	fildl aktualnyNumerPetli	
	fld dlugoscSkoku		/*wrzucam dlugosc skoku*/
	fmulp					/*mnoze dlugosc skoku razy aktulny numer petli aby obliczyc x*/
	fld od					/*wrzucam przsuniecie o wartosc poczatkowa calki*/
	faddp					/*dodaje przedzial poczatkowy calki oraz otrzymany x */
	fild dzielna			/*wrzucam dzielna*/
	fdivp					/*obliczam wartosc 1/x we wczesniej obliczonym punkcie*/
	fld dlugoscSkoku		
	fmulp					/*obliczam pole w obliczonym punkcie x*/
	fld wynik				
	faddp					/*dodaje aktualny wynik do poprzedniej wartosci*/
	fstp wynik				/*zdejmuje go do zmiennej */
	jmp petla
koniec:
	movsd wynik,%xmm0		/*przenosze wynik do rejestru ktory zostanie zwrocony z funkcji*/
	ret
	

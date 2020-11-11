;*********************************************
;**    Zad 1; pierwiastkowanie II st.       **  **
;** Dawid Najgiebauer          Inf sem III  **	**
;**    Opole, 17.03.2005  Politech. Opolska **	**
;*********************************************	**
;  ***********************************************

.model small 
jumps  ; likwiduje problem dalekich warunkowych skokow
.stack 512
.data
	dana DB ?
	wynik DB ?
	ekran DB 'L - wprowadz dana',10,13,'W - wyswietl wynik',10,13,'Enter - zatwierdz dana',10,13,'0,1 - do wprowadzania danej',10,13,'BACKSPACE - kasowanie',10,13,'ESC - wyjscie',10,13,10,13,'DANA:  [        ]',10,13,'WYNIK: [        ]','$'
	pole DB  '        ','$'    ; 8 x '0' (jesli wypelniac zerami) lub spacji (bez nieznaczacych zer)
	blad DB ' !BLAD! ','$'
.code
	;inicjalizacja (okreslenie segmentu danych)
	mov AX,SEG dana
	mov DS,AX
	
	;wyczyszczenie ekranu
	mov AH,06h ;numer funkcji
	mov AL,0   ;liczba dodanych pustych lini( 0 to caly ekran pusty )
	mov BH,7  ;atrybuty pustych lini (kolory; 7-szary; 15-bialy)
	mov CL,0   ;kolumna lewego gornego rogu
	mov CH,0   ;wiersz lewego gornego rogu
	mov DL,80  ; kolumna prawego dolnego rogu
	mov DH,25  ; wiersz prawego dolnego rogu
	int 10h
	
	;ustawienie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,0  ;wiersz 0
	mov DL,0  ;kolumna 0
	int 10h
	
	;wyswietlenie MENU
	mov AH,09h
	mov DX,OFFSET ekran
	int 21h
	
	menu:
	;ukrycie kursora
	mov AH,02h
	mov BH,0   ; numer strony graficznej
	mov DH,25  ; numer wiersza,a 25 to ukrycie kursora
	int 10h
	
	;czytanie znaku
	mov AH,08h
	int 21h
	
	;czy to jest L
	cmp AL,'l'
	je wprowadz_dana
	cmp AL,'L'
	je wprowadz_dana
	
	;czy to jest W
	cmp AL,'w'
	je wyswietl_wynik
	cmp AL,'W'
	je wyswietl_wynik
	
	;czy to jest ESC
	cmp AL,27
	je koniec
	jmp menu
	
	
	wprowadz_dana:
		mov dana,0   ;wyczyszczenie danej
		mov CL,0     ;w CL jest liczba wprowadzonych znakow
		
		;ustawienie kursora
		mov AH,02h
		mov BH,0  ;numer strony
		mov DH,7  ;wiersz 7
		mov DL,8  ;kolumna 8
		int 10h
		
		;wyczyszczenie pola
		mov AH,09h
		mov DX,OFFSET pole
		int 21h
		
		wprowadz_dana_czytaj:
		
		;ustawienie kursora
		mov AH,02h
		mov BH,0  ;numer strony
		mov DH,7  ;wiersz 7
		mov DL,15  ;kolumna 15
		int 10h
		
		;czytanie znaku
		mov AH,08h
		int 21h
		
		;czy CL jest rowne 8 (nie mozna czytac wiecej cyfr)
		cmp CL,8
		je czy_enter
		
		;czy to jest 0
		cmp AL,'0'
		je nacisnieto_0
		
		;czy to jest 1
		cmp AL,'1'
		je nacisnieto_1
		
		;czy to jest ENTER
		czy_enter:
		cmp AL,13
		je menu
		
		;czy CL jest 0
		cmp CL,0
		je wprowadz_dana_czytaj
		
		;czy to jest BS
		cmp AL,8
		je nacisnieto_BS
		jmp wprowadz_dana_czytaj
		
	nacisnieto_0:
		SHL dana,1   ;przesuniecie w lewo o 1
		INC CL
		jmp wyswietl_dana_2
		
	nacisnieto_1:
		SHL dana,1   ;przesuniecie w lewo o 1  abc => abc0
		INC dana    ; zwiekszanie o 1         abc0 => abc1
		INC CL
		jmp wyswietl_dana_2
		
	nacisnieto_BS:
		SHR dana,1
		DEC CL
		jmp wyswietl_dana_2
		
		jmp wprowadz_dana_czytaj
		
	wyswietl_dana_2:
		;ustawienie kursora
		mov AH,02h
		mov BH,0  ;numer strony
		mov DH,7  ;wiersz 7
		mov DL,8  ;kolumna 8
		int 10h
		
		;wyczyszczenie pola
		mov AH,09h
		mov DX,OFFSET pole
		int 21h
		
		;jezeli brak wpisanych znakow, to nie probuj wyswietlac bin
		cmp cl,0
		je wprowadz_dana_czytaj
	
		;w dalszej czesci wykorzystywana jest petla LOOP 
		;ktora bazuje na rejestrze CX i zmienia go
		;dlatego aby nie stracic wartosci w CL ktora sobie wykorzystujemy
		;odkladamy tymczasowo CX na stos
		PUSH CX  
		MOV CH,0  ;petla bazuje na CX, CL mamy ustawiony wiec trzeba wyzerowac CH
		MOV BL,00000001b   ; maska bo od prawej bedziemy wyciagac bity-bit po bicie
		mov dl,16	;pozycja kolumny kursora gdzie ma zostac wypisany bit,wypisujemy od prawej	
		petla:
			;ustawienie kursora
			mov AH,02h
			mov BH,0  ;numer strony
			mov DH,7  ;wiersz 7
			dec DL  ;kolumna 
			int 10h
			push dx ;odkladamy aby nie stracic wartosci w DL ktory bedzie uzywany
			
			mov al,dana
			and al,bl
			
			cmp al,0
			je petla_pisz_0
			;pisz1
			mov dl,'1'
			mov ah,2h
			int 21h
			jmp petla_koniec
			
			petla_pisz_0:
			mov dl,'0'
			mov ah,2h
			int 21h
			
			petla_koniec:
			pop dx
			shl bl,1
			
		LOOP petla
		
		POP CX
		jmp wprowadz_dana_czytaj
	
	wyswietl_wynik:
	cmp dana,0
	jl wynik_blad
	cmp dana,1
	jl wynik_0
	cmp dana,4
	jl wynik_1
	cmp dana,9
	jl wynik_2
	cmp dana,16
	jl wynik_3
	cmp dana,25
	jl wynik_4
	cmp dana,36
	jl wynik_5
	cmp dana,49
	jl wynik_6
	cmp dana,64
	jl wynik_7
	cmp dana,81
	jl wynik_8
	cmp dana,100
	jl wynik_9
	cmp dana,121
	jl wynik_10
	jmp wynik_11
	
	wynik_blad:
	         ;ustawienie kursora
		mov AH,02h
		mov BH,0  ;numer strony
		mov DH,8  ;wiersz 8
		mov DL,8  ;kolumna 8
		int 10h
		
		mov ah,09h
		mov dx,OFFSET blad
		int 21h
	jmp menu
	wynik_0:
	mov wynik,0
	jmp wyswietl_wynik_bin
	wynik_1:
	mov wynik,1
	jmp wyswietl_wynik_bin
	wynik_2:
	mov wynik,2
	jmp wyswietl_wynik_bin
	wynik_3:
	mov wynik,3
	jmp wyswietl_wynik_bin
	wynik_4:
	mov wynik,4
	jmp wyswietl_wynik_bin
	wynik_5:
	mov wynik,5
	jmp wyswietl_wynik_bin
	wynik_6:
	mov wynik,6
	jmp wyswietl_wynik_bin
	wynik_7:
	mov wynik,7
	jmp wyswietl_wynik_bin
	wynik_8:
	mov wynik,8
	jmp wyswietl_wynik_bin
	wynik_9:
	mov wynik,9
	jmp wyswietl_wynik_bin
	wynik_10:
	mov wynik,10
	jmp wyswietl_wynik_bin
	wynik_11:
	mov wynik,11
	
	 wyswietl_wynik_bin:
	         ;ustawienie kursora
		mov AH,02h
		mov BH,0  ;numer strony
		mov DH,8  ;wiersz 8
		mov DL,8  ;kolumna 8
		int 10h
		
		mov AH,02h
		mov DL,'0'
		int 21h
		int 21h
		int 21h
		int 21h
		
		mov AL,wynik
		AND AL,1000b
		SHR AL,3
		mov DL,AL
		ADD DL,'0'
		mov AH,02h
		int 21h
		
		mov AL,wynik
		AND AL,100b
		SHR AL,2
		mov DL,AL
		ADD DL,'0'
		mov AH,02h
		int 21h
		
		mov AL,wynik
		AND AL,10b
		SHR AL,1
		mov DL,AL
		ADD DL,'0'
		mov AH,02h
		int 21h
		
		mov AL,wynik
		AND AL,1b
		mov DL,AL
		ADD DL,'0'
		mov AH,02h
		int 21h
		
	jmp menu
	
	;zakonczenie
	koniec:
	mov AH,4ch
	int 21h
	
end
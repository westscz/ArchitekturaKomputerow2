;*********************************************
;**    Zad 2; odejmowanie BCD               **  **
;** Dawid Najgiebauer          Inf sem III  **	**
;**    Opole, 17.03.2005  Politech. Opolska **	**
;*********************************************	**
;  ***********************************************

.model SMALL
jumps  ; likwiduje problem dalekich warunkowych skokow
.STACK 512
.DATA
	dana1 DB 5 DUP(?)
	dana2 DB 5 DUP(?)
	wynik DB 5 DUP(?)
	hex DB 5 DUP(?)
	ekran DB 'L - wprowadz dana1',10,13,'P - wprowadz dana2',10,13
		DB 'W - wyswietl wynik',10,13
		DB 'ESC - wyjscie',10,13,10,13
		DB 'DANA1: [          ] HEX: [          ]',10,13
		DB 'DANA2: [          ] HEX: [          ]',10,13
		DB 'WYNIK: [          ] HEX: [          ]','$'
	pole DB  '          ',8,8,8,8,8,8,8,8,8,8,'$' ;zmienna do czyszczenia pola
	blad DB '**********',7,'$'
	
.CODE

BCD_to_HEX:
	;BX - liczba
	PUSH BX
	MOV BX,OFFSET hex
	call wyczysc
	POP BX
	
	;zmiena hex zostanie tymczasowo potraktowana, jako kopia konwenterowanej liczby
	;wynik konwersji bedzie odkladany na stos
	
	MOV CX,5
	kopiuj:
		MOV SI,CX
		DEC SI
		MOV AL,[BX+SI]
		MOV hex[SI],AL
	LOOP kopiuj
	;skasowanie znaku liczby:
	AND hex[0],1111b
	
	MOV CX,40
	konwersja:
		MOV AL,0
		SHR hex[4],1
		;zapamietanie tego, co wypada po przesunieciu
		ADC AL,0
		PUSH AX ;i odlozenie na stos
		
		;sprawdzanie koniecznosci korekty na 4 starszych
		MOV AL,hex[4]
		AND AL,1000b
		CMP AL,0
		JE bez_korekty0
		SUB hex[4],3
		
		bez_korekty0:
		
		PUSH CX ;dla petli wewnetrznej
		MOV CX,4
		konwersja_przesuwanie:
			MOV SI,CX
			DEC SI
			
			MOV AL,0
			SHR hex[SI],1
			ADC AL,0
			;sprawdzanie korekty na 4 pozycji
			MOV AH,hex[SI]
			AND AH,1000b
			CMP AH,0
			JE bez_korekty1
			SUB hex[SI],3

			bez_korekty1:
			SHL AL,7
			ADD hex[SI+1],AL
			
			;sprawdanie korekty na 7 (najstarszej) pozycji
			CMP AL,0
			JE bez_korekty2
			SUB hex[SI+1],0110000b ;(-3 na 4 starszych)
			bez_korekty2:
		LOOP konwersja_przesuwanie
		POP CX
	LOOP konwersja
	
	PUSH BX
	MOV BX,OFFSET hex
	call wyczysc
	POP BX

	MOV CX,40
	;odczytanie ze stosu
	odczyt_konwersji:
		SHL hex[0],1
		
		SHL hex[1],1
		ADC hex[0],0
		
		SHL hex[2],1
		ADC hex[1],0
		
		SHL hex[3],1
		ADC hex[2],0
		
		SHL hex[4],1
		ADC hex[3],0
		
		POP AX
		ADD hex[4],AL
	LOOP odczyt_konwersji
	
	koniec_konwersji:
		;ustawienie znaku:
		MOV AL,[BX]
		AND AL,11110000b
		ADD hex[0],AL
RET

wyczysc_pole:
	mov AH,9h
	mov dx,OFFSET pole
	int 21h
ret

zamien_dane:
	MOV CX,5
	zamien_dane_petla:
		MOV SI,CX
		DEC SI
		MOV AL,dana1[SI]
		MOV AH,dana2[SI]
		MOV dana1[SI],AH
		MOV dana2[SI],AL
	LOOP zamien_dane_petla
ret

wyczysc:
	mov AH,0
	mov CX,5
	wyczysc_petla:
		mov SI,CX
		DEC SI
		mov [BX+SI],AH
	LOOP wyczysc_petla
ret

wprowadz:
	call wyczysc
	mov CX,0
	
	wprowadz_czytaj:
	; czytanie znaku
	mov AH,08h
	int 21h
	
	cmp AL,'0'
	jb wprowadz_czytaj
	cmp AL,'9'
	ja wprowadz_czytaj
	cmp CL,0
	jne niepierwsza
	cmp AL,'1'
	ja wprowadz_czytaj
	
	niepierwsza:
	INC CL
	mov DL,AL
	;wyswietl na ekranie
	mov AH,2h
	int 21h
	SUB DL,'0'
	mov AL,CL
	AND AL,1b
	cmp AL,0
	je parzysta
	SHL DL,4
	
	parzysta:
	mov SI,CX
	SHR SI,1
	mov AH,0
	ADD SI,AX
	DEC SI
	ADD [BX+SI],DL
	cmp CX,10
	jne wprowadz_czytaj
	
ret

oblicz:
	;schematy odejmowania w zaleznosci od znakow liczb
	; (-l1) - (-l2) => l2 - l1
	; (-l1) - (+l2) => - (l1+l2)
	; (+l1) - (-l2) => + (l1+l2)
	; (+l1) - (+l2) => l1 - l2
	
	;jesli do czynienia z odejmowaniem, to:
	;l1-l2 -> l1>=l2 => +(l1-l2)
	;         l1< l2 => -(l2-l1)
	
	MOV BX,OFFSET wynik
	CALL wyczysc
	
	;czy przeciwne znaki liczb (wtedy dodawanie)
	MOV AL,dana1[0]
	AND AL,11110000b
	SHR AL,4
	MOV AH,dana2[0]
	AND AH,11110000b
	SHR AH,4
	ADD AL,AH
	CMP AL,1
	JE oblicz_dodawanie
	CMP AL,0
	JE obie_dodatnie
	
	CALL zamien_dane ;(jesli obie ujemne, to wykonujemy, jak dla dodatnich, ale zamieniamy ich kolejnosc)
	
	obie_dodatnie:
	MOV DL,0
	;sprawdzanie, czy l2>l1 - jesli tak, to zamieni dane
	MOV CX,5
	MOV SI,0
	oblicz_ktora_wieksza:
		MOV AL,dana1[SI]
		MOV AH,dana2[SI]
		CMP AH,AL
		JB oblicz_odejmowanie
		JA oblicz_odejmowanie_zamien
		INC SI
	LOOP oblicz_ktora_wieksza
	JMP oblicz_odejmowanie
	
	oblicz_odejmowanie_zamien:
	CALL zamien_dane
	MOV DL,1
	
	oblicz_odejmowanie:
		MOV CX,5
		CLC
		oblicz_odejmowanie_petla:
			MOV SI,CX
			DEC SI
			
			MOV AL,dana1[SI]
			MOV AH,dana2[SI]
			SBB AL,AH
			
			DAS ;korekcja po odejmowaniu
			MOV wynik[SI],AL
		LOOP oblicz_odejmowanie_petla
		
		SHL DL,4
		ADD wynik[0],DL
		SHR DL,4
		CMP DL,0
		JE nie_zamieniaj_danych
		CALL zamien_dane
	nie_zamieniaj_danych:
	JMP oblicz_koniec
	
	oblicz_dodawanie:
		MOV CX,5
		CLC
		oblicz_dodawanie_petla:
			MOV SI,CX
			DEC SI

			MOV AL,dana1[SI]
			MOV AH,dana2[SI]
			
			ADC AL,AH
			DAA  ;korekcja dziesietna
			
			MOV wynik[SI],AL
			
		LOOP oblicz_dodawanie_petla
		
		oblicz_dodawanie_koniec:
			;sprawdzenie przepelnienia
			MOV AL,wynik[0]
			SHR AL,4
			CMP AL,1
			JA przepelnienie
			;ustawienie znaku
			MOV AL,wynik[0]
			AND AL,1111b
			MOV wynik[0],AL
			MOV AL,dana1[0]
			AND AL,11110000b
			ADD wynik[0],AL
			JMP oblicz_koniec
przepelnienie:
	STC
	JMP oblicz_koniec_2
oblicz_koniec:
	CLC
oblicz_koniec_2:
ret

wyswietl_BCD:
	JC wyswietl_przepelnienie
	mov CX,5
	MOV SI,0
	MOV AH,2
	wyswietl_petla:
		;starsza cyfra z bajtu
		MOV DL,wynik[SI]
		AND DL,11110000b
		SHR DL,4
		ADD DL,'0'
		INT 21h
		
		;mlodsza cyfra z bajtu
		MOV DL,wynik[SI]
		AND DL,1111b
		ADD DL,'0'
		INT 21h
		INC SI
	LOOP wyswietl_petla
	JMP wyswietl_koniec
	
	wyswietl_przepelnienie:
		MOV AH,9
		MOV DX,OFFSET blad
		INT 21h
wyswietl_koniec:
ret

wyswietl_HEX:
	mov CX,5
	MOV AH,2
	MOV SI,0
	wyswietl_hex_petla:
		;starsza cyfra z bajtu
		MOV DL,hex[SI]
		AND DL,11110000b
		SHR DL,4
		ADD DL,'0'
		CMP DL,'9'
		JBE nie_dodawaj1
		ADD DL,7
		nie_dodawaj1:
		INT 21h
		
		;mlodsza cyfra z bajtu
		MOV DL,hex[SI]
		AND DL,1111b
		ADD DL,'0'
		CMP DL,'9'
		JBE nie_dodawaj2
		ADD DL,7
		nie_dodawaj2:
		INT 21h
		
		INC SI
	LOOP wyswietl_hex_petla
	
ret


start:
	;inicjalizacja (okreslenie segmentu danych)
	mov AX,SEG dana1
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
	je wprowadz_dana1
	cmp AL,'L'
	je wprowadz_dana1

	;czy to jest P
	cmp AL,'p'
	je wprowadz_dana2
	cmp AL,'P'
	je wprowadz_dana2

	;czy to jest W
	cmp AL,'w'
	je wynik_menu
	cmp AL,'W'
	je wynik_menu

	;czy to jest ESC
	cmp AL,27
	je koniec
	jmp menu

	wprowadz_dana1:
	;ustawianie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,5  ;wiersz 0
	mov DL,8  ;kolumna 0
	int 10h
	
	call wyczysc_pole

	mov BX, OFFSET dana1
	call wprowadz
	CALL BCD_to_HEX
	;ustawianie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,5  ;wiersz 0
	mov DL,26  ;kolumna 0
	int 10h
	CALL wyswietl_HEX
	jmp menu
	
	wprowadz_dana2:
	;ustawienie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,6  ;wiersz 0
	mov DL,8  ;kolumna 0
	int 10h

	call wyczysc_pole

	mov BX, OFFSET dana2
	call wprowadz
	CALL BCD_to_HEX
	;ustawianie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,6  ;wiersz 0
	mov DL,26  ;kolumna 0
	int 10h
	CALL wyswietl_HEX
	jmp menu
	
	wynik_menu:
	;ustawienie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,7  ;wiersz 0
	mov DL,8  ;kolumna 0
	int 10h

	mov BX, OFFSET wynik
	call oblicz ;w przypadku przepelnienia zostanie zwrocone CF=1
	call wyswietl_BCD
	CALL BCD_to_HEX
	;ustawianie kursora
	mov AH,02h
	mov BH,0  ;numer strony
	mov DH,7  ;wiersz 0
	mov DL,26  ;kolumna 0
	int 10h
	CALL wyswietl_HEX
	jmp menu
	

	;zakonczenie
	koniec:
	mov AH,4Ch
	int 21h

END start

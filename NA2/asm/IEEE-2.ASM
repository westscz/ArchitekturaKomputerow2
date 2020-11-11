;potegowanie liczby IEEE 754 - kwadrat

.MODEL SMALL
.STACK 100h

.DATA
 liczba DB 4 dup(?)
 wynik DB 4 dup(?)
 cecha DB ?
 cecha_potega DW ? ;przechowuje ceche po spotegowaniu
 mantysa DB 3 dup (?)
 mantysa_potega DB 6 dup (?) ;przechowuje wynik mantysy po spotegowaniu
 
 komunikat_info DB 10,13,'Program oblicza kwadrat wprowadzonej liczby w standardzie IEEE 754',10,13,10,13
                DB       '<B>    - wprowadz liczbe binarnie',10,13
		DB	 '<ESC>  - wyjdz z programu',10,13
		DB	 'Przy wprowadzaniu: wypeˆnij wszystkie 32 pozycje; <BS> - kasowanie',10,13,'$'
 komunikat_wprowadz DB 10,13,'Podaj liczbe: _ ',8 dup('_'),' ',23 dup('_') ;wyswietla miejsce na wynik
 		    DB 10,13,'Wynik to:     _ ',8 dup('_'),' ',23 dup('_')
		    DB 10,13,'              S    C                 M','$'
 error DB 'Nastapil blad przepelnienia!',7,'$' ;7 to dzwiek


.CODE
wyswietl_IEEE: ;wyswietla zmienna IEEE spod adresu BX
	MOV CX,32 ;40 bitow do wyswietlenia
	wyswietl_loop:
		;na kroku 31 i 23 dokonuje skoku (dla rozdzielenia)
		CMP CX,31
		JE wyswietl_spacje
		CMP CX,23
		JE wyswietl_spacje
		JMP bez_spacji
		wyswietl_spacje:
			MOV AH,2
			MOV DL,' '
			INT 21h
		
		bez_spacji:
		;przesuwanie liczby o 1 w lewo od najmlodszej czesci
		SHL BYTE PTR BX[3],1 ;BYTE PTR wskazuje, ze zmienna jest 1-bajtowa
		RCL BYTE PTR BX[2],1 ;wstawi CF na najmlodsza, czyli to, co wypadlo z poprzedniego
		RCL BYTE PTR BX[1],1
		RCL BYTE PTR BX[0],1
		
		;w CF znajduje sie liczba z najsatrszej pozycji
		JC wyswietl_1 ;jescli bylo CF, to wyswietl 1
		;wyswetlo_0

		MOV DL,'0'
		JMP wyswietl
		
		wyswietl_1:
		ADD BYTE PTR BX[3],1 ;aby nie utracic zawartosci liczby to, co wyskoczylo z przodu dodaje na tyl
		MOV DL,'1'
		
		wyswietl:
		MOV AH,2
		INT 21h
		
	LOOP wyswietl_loop
RET

wprowadz: ;wprowadza 32 bity pod BX (od najstarszej)
	MOV CX,32 ;licznik wprowadzonych
	wprowadz_czytaj_znak:
		MOV AH,8h
		INT 21h
		
		CMP AL,8 ;klawisz kasowania
		JE wprowadz_kasuj
		CMP AL,'0'
		JB wprowadz_czytaj_znak
		CMP AL,'1'
		JA wprowadz_czytaj_znak
		
		;wypisz wprowadzony znak
		MOV DL,AL
		MOV AH,2
		INT 21h
		PUSH DX ;aby nie stracic
		;skok przy pozycjach 32 i 24
		CMP CX,32
		JE wprowadz_wyswietl_spacje
		CMP CX,24
		JE wprowadz_wyswietl_spacje
		JMP wprowadz_do_pamieci
		wprowadz_wyswietl_spacje:
			MOV AH,2
			MOV DL,' '
			INT 21h
		
		wprowadz_do_pamieci:
		;wprowadza znak do zmiennej
		POP DX
		SUB DL,'0' ;zamiana znaku na wartosc
		SHL BYTE PTR BX[3],1
		RCL BYTE PTR BX[2],1
		RCL BYTE PTR BX[1],1
		RCL BYTE PTR BX[0],1
		ADD BX[3],DL ;jesli bylo 1, to wprowadzi ta 1
		JMP wprowadz_loop_koniec
		
		wprowadz_kasuj:
		CMP CX,32 ;nie pozwol przesunac bardziej
		JE wprowadz_czytaj_znak
		
		;skasowanie - kursor w lewo, nadpisanie, kursor w lewo:
		;jesli odstep do zniweluj
		CMP CX,31
		JE kasuj_wiecej
		CMP CX,23
		JE kasuj_wiecej
		JMP kasuj_normalnie
		
		kasuj_wiecej:
		MOV DL,8
		MOV AH,2
		INT 21h
		
		kasuj_normalnie:
		MOV DL,8
		MOV AH,2
		INT 21h
		MOV DL,'_'
		INT 21h
		MOV DL,8
		INT 21h
		
		;cofniecie licznika
		INC CX
		INC CX
		
		;skasowanie ze zmienej
		SHL BYTE PTR BX[3],1
		RCL BYTE PTR BX[2],1
		RCL BYTE PTR BX[1],1
		RCL BYTE PTR BX[0],1
		
		wprowadz_loop_koniec:
	LOOP wprowadz_czytaj_znak
RET

oblicz:
	;deparsowanie liczby
	SHL BYTE PTR BX[0],1 ;wydobywa znak (i zapomina, bo wynik zawsze dodatni)
				;i ustawia w calym BX[0] ceche

	MOV AL,BX[0]
	MOV cecha,AL
	MOV AL,BX[1]
	SHR AL,7 ;ostatni znak cechy znajdowal sie w BX[1]
	ADD cecha,AL
	
	MOV AL,BX[1]
	OR AL,10000000b ;jako, ze formalnie mantysa to 1,xxx - dodaje owo 1 (na pozycje, w ktorej byl ostatni bit cechy)
	MOV mantysa[0],AL
	MOV AL,BX[2]
	MOV mantysa[2],AL
	MOV AL,BX[3]
	MOV mantysa[3],AL
	
	;obliczenia
	
	;licz ceche
	MOV AH,0
	MOV AL,cecha
	SUB AX,127 ;z takim nadmiarem napsiana cecha
	;mnozenie przez 2 to przesuniecie w lewo
	SHL AX,1
	SUB AX,23 ;jako, ze przy mnozeniu nie uwzgledniono przecinka, ktory trzeba rzesunac o 22 poz. b. w lewo
	MOV cecha_potega,AX
	
	;zerowanie mantysa_potega
	MOV CX,6
	MOV SI,0
	zeruj:
		MOV mantysa_potega[SI],0
		INC SI
	LOOP zeruj
	
	;mnozenie na petli
	MOV SI,2
	MOV DI,2
	
	oblicz_mnoz:
		MOV AH,mantysa[DI]
		MOV AL,mantysa[SI]
		MUL AH
		
		MOV BX,SI
		ADD BX,DI
		
		ADD mantysa_potega[BX+1],AL
		ADC mantysa_potega[BX],AH
		
		CMP SI,0
		JE zmniejsz_di
		DEC SI
		JMP oblicz_mnoz
		
		zmniejsz_di:
		CMP DI,0
		JE normalizowanie
		DEC DI
		MOV SI,2
		JMP oblicz_mnoz
	
	normalizowanie:
	;normalizowanie - przesuwanie mantysy i zmiana cechy
		;aby poprawna, musi by† 0,0,1,x,x,x
		;jako, ze byla dodana 1, to zawsze przesuwanie w prawo
		;na pierwszych 3 pozycjach - nadmiarowa
		CMP mantysa_potega[0],0
		JNE normalizowanie_przesun
		CMP mantysa_potega[1],0
		JNE normalizowanie_przesun
		CMP mantysa_potega[2],0
		JNE normalizowanie_przesun
		;w tym momencie oznacza, ze na 1 pozycji z [3] jest 1
		JMP sprawdz_wynik

		normalizowanie_przesun:
		MOV CX,6 ;przesuwa 6 bajtow
		MOV SI,0
		CLC ;musi dostawic 0 na poczatek
		normalizowanie_przesun_loop:
			RCR mantysa_potega[SI],1
			INC SI
		LOOP normalizowanie_przesun_loop
		;na koniec zmieniamy ceche
		INC cecha_potega
	JMP normalizowanie
			
	sprawdz_wynik:
	;powrot do normalnego zapisu cechy
	ADD cecha_potega,127
	;sprawdza na obecnosc nieskonczonosci
		CMP cecha_potega,00000h ;wskazuje, ze cecha ujemna i z zakresu -127..128; mniejsza to za mala
		JL tworz_zero
		CMP cecha_potega,000FFh ;wskazuje, ze cecha jest dodatnia i z zakresu -127..128; przekroczenie w gore to nieskonczonosc
		JA tworz_nieskonczonosc
	
	;tworzy liczbe
	MOV AL,mantysa_potega[3]
	AND AL,01111111b ;wyeliminuje 1,xxx, czyli zbedna jedynke
	MOV wynik[1],AL
	MOV AL,mantysa_potega[4]
	MOV wynik[2],AL
	MOV AL,mantysa_potega[5]
	MOV wynik[3],AL
	
	MOV AX,cecha_potega
	MOV wynik[0],AL ;wystarczy mlodsza czesc
	MOV AH,0 ;przygotowuje zmienna pomocniczna
	SHR wynik[0],1 ;pozostawia znak
	ADC AH,0 ;dodaje 1 jesli uciekla z wynik[0]
	SHL AH,7 ;przesuwa na wlasciwa pozycje
	ADD wynik[1],AH ;wstawia
RET
		
	tworz_nieskonczonosc: ;nieskonczonosc to 0111....
		MOV wynik[0],01111111b
		MOV wynik[1],0FFh
		MOV wynik[2],0FFh
		MOV wynik[3],0FFh
RET
	
	tworz_zero: ;zero to 000000......
		MOV wynik[0],0
		MOV wynik[1],0
		MOV wynik[2],0
		MOV wynik[3],0
RET
		
start:
;zainicjowanie segmentu danych
MOV AX,SEG liczba
MOV DS,AX
  
;wyczyszczenie ekranu
MOV AX,0600h
MOV BH,7
MOV CX,0000h
MOV DX,184Fh
INT 10h

;ustawienie kursora
MOV AH,2
MOV BH,0
MOV DX,0 ;(pozycja 0,0)
INT 10h

;wstep
MOV AH,9h
MOV DX,OFFSET komunikat_info
INT 21h

;czekanie na nacisniesie klawisza
menu:
	MOV AH,8
	INT 21h
	
	CMP AL,'b'
	JE menu_b
	CMP AL,27 ;klawisz ESC
	JE koncz_program
	
JMP menu

koncz_program:
MOV AX,4C00h
INT 21h

menu_b:
	;usawienie kursora
	MOV AH,2
	MOV BH,0
	MOV DH,6 ;wiersz
	MOV DL,0 ;kolumna
	INT 10h
	;wprowadz
	MOV AH,9h
	MOV DX,OFFSET komunikat_wprowadz
	INT 21h
	
	;usawienie kursora
	MOV AH,2
	MOV BH,0
	MOV DH,7 ;wiersz
	MOV DL,14 ;kolumna
	INT 10h
	
	MOV BX,OFFSET liczba
	CALL wprowadz

menu_oblicz:
;oblicz
CALL oblicz

;usawienie kursora
MOV AH,2
MOV BH,0
MOV DH,8 ;wiersz
MOV DL,14 ;kolumna
INT 10h

MOV BX,OFFSET wynik
CALL wyswietl_IEEE

JMP menu

END start
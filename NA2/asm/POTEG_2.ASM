;potegowanie liczby - kwadrat

.MODEL SMALL
.STACK 100h

.DATA
 liczba DB 5 dup(?)
 bufor_przepelnienia DB 5 dup (?) ;tu zapisuje to, co wyjdzie na minusowy indeks z wyniku
 wynik DB 5 dup(?)
 komunikat_info DB 10,13,'Program oblicza kwadrat wprowadzonej liczby',10,13,10,13
                DB       '<B>    - wprowadz dana binarnie',10,13
		DB	 '<ESC>  - wyjdz z programu',10,13
		DB	 'Przy wprowadzaniu: wypeˆnij wszystkie 40 pozycji; <BS> - kasowanie',10,13,'$'
 komunikat_wprowadz DB 10,13,'Podaj liczbe: ',40 dup('_'),'b = ',10 dup(' '),'h' ;wyswietla miejsce na wynik
 		    DB 10,13,'Wynik to:     ',40 dup(' '),'b = ',10 dup(' '),'h','$'
 error DB 'Nastapil blad przepelnienia!',7,'$' ;7 to dzwiek


.CODE
zeruj: ;zeruje 5 bajtow zaczynajac od BX (adres zmiennej)
	MOV CX,5
	MOV SI,0
	XOR AL,AL ;zerowanie AL
	zeruj_loop:
		MOV BX[SI],AL
		INC SI
		LOOP zeruj_loop
RET
	
wyswietl_bin: ;wyswietla 5-bajtowa zmienna spod adresu BX (bez zer poczatkowych)
	MOV CX,40 ;40 bitow do wyswietlenia
	MOV DH,0 ;zmienna pomocniczna - 0 -pomijac zera poczatkowe
	wyswietl_bin_loop:
		;przesuwanie liczby o 1 w lewo od najmlodszej czesci
		SHL BYTE PTR BX[4],1 ;BYTE PTR wskazuje, ze zmienna jest 1-bajtowa
		RCL BYTE PTR BX[3],1 ;wstawi CF na najmlodsza, czyli to, co wypadlo z poprzedniego
		RCL BYTE PTR BX[2],1
		RCL BYTE PTR BX[1],1
		RCL BYTE PTR BX[0],1
		
		;w CF znajduje sie liczba z najsatrszej pozycji
		JC wyswietl_1 ;jescli bylo CF, to wyswietl 1
		;wyswetlo_0
		CMP CX,1 ;ostatnie obowiazkowo 0
		JE wyswietl_0
		CMP DH,0 ;sprawdza, czy wyswietlic 0 czy spacje
		JNE wyswietl_0
		
		MOV DL,' ';
		JMP wyswietl
		
		wyswietl_0:
		MOV DL,'0'
		JMP wyswietl
		
		wyswietl_1:
		ADD BYTE PTR BX[4],1 ;aby nie utracic zawartosci liczby to, co wyskoczylo z przodu dodaje na tyl
		MOV DH,1 ;musi wyswietlic kolejne zera
		MOV DL,'1'
		
		wyswietl:
		MOV AH,2
		INT 21h
		
	wyswietl_bin_loop_koniec:	
	LOOP wyswietl_bin_loop
RET

wyswietl_hex: ;wyswietla 5-bajtowa zmienna spod adresu BX (bez zer poczatkowych)
	MOV CX,5 ;5 bajtow do wyswietlenia
	MOV SI,0
	wyswietl_hex_loop:
		MOV DL,BX[SI]
		SHR DL,4 ;pobiera starsze 4 bajty i przesuwa na mlodsze pozycje
		
		CMP DL,10
		JAE dodaj_A1 ;gdy liczba wieksza niz 10 dodaje A
		
		ADD DL,'0'
		JMP wyswietl_hex1
		
		dodaj_A1:
		ADD DL,'A'-10
		
		wyswietl_hex1:
		MOV AH,2
		INT 21h
		
		MOV DL,BX[SI]
		AND DL,1111b ;pozostawi tylko 4 najmlodsze bajty
		
		CMP DL,10
		JAE dodaj_A2 ;gdy liczba wieksza niz 10 dodaje A
		
		ADD DL,'0'
		JMP wyswietl_hex2
		
		dodaj_A2:
		ADD DL,'A'-10
		
		wyswietl_hex2:
		MOV AH,2
		INT 21h
		
		INC SI
	LOOP wyswietl_hex_loop
RET

wprowadz_b: ;wprowadza 40 bitow pod BX (od najstarszej)
	MOV CX,40 ;licznik wprowadzonych
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
		
		;wprowadza znak do zmiennej
		SUB DL,'0' ;zamiana znaku na wartosc
		SHL BYTE PTR BX[4],1
		RCL BYTE PTR BX[3],1
		RCL BYTE PTR BX[2],1
		RCL BYTE PTR BX[1],1
		RCL BYTE PTR BX[0],1
		ADD BX[4],DL ;jesli bylo 1, to wprowadzi ta 1
		JMP wprowadz_loop_koniec
		
		wprowadz_kasuj:
		CMP CX,40 ;nie pozwol przesunac bardziej
		JE wprowadz_czytaj_znak
		
		;skasowanie - kursor w lewo, nadpisanie, kursor w lewo:
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
		SHR BYTE PTR BX[0],1
		RCR BYTE PTR BX[1],1
		RCR BYTE PTR BX[2],1
		RCR BYTE PTR BX[3],1
		RCR BYTE PTR BX[4],1
		
		wprowadz_loop_koniec:
	LOOP wprowadz_czytaj_znak
RET

oblicz:
	;sprawdza, czy wprowadzona liczba ujemna
	MOV AL,liczba[0]
	CMP AL,01111111b ;powyzej tej liczby to ujemna
	JA oblicz_zmien_znak ;skok gdy wiekszy
	JMP oblicz_nie_zmien_znak
	
	oblicz_zmien_znak: ;negacja i dodanie 1
		NOT liczba[4]
		NOT liczba[3]
		NOT liczba[2]
		NOT liczba[1]
		NOT liczba[0]
		ADD liczba[4],1 ;zwieksz o 1
		ADC liczba[3],0 ;przeniesienia CF na starsze pozycje
		ADC liczba[2],0
		ADC liczba[1],0
		ADC liczba[0],0
		
		;sprawdz, czy nie nastapilo przepelnienie
		MOV AL,liczba[0]
		CMP AL,01111111b ;powyzej tej liczby to ujemna
		JA oblicz_przepelnienie ;skok gdy wiekszy
		
	oblicz_nie_zmien_znak:
	MOV BX,OFFSET wynik[-5]
	CALL zeruj
	MOV BX,OFFSET wynik
	CALL zeruj
	
	;mnozenie na petli
	MOV SI,4
	MOV DI,4
	
	oblicz_mnoz:
		MOV AH,liczba[DI]
		MOV AL,liczba[SI]
		MUL AH
		
		MOV BX,SI
		ADD BX,DI
		
		ADD wynik[BX-4],AL
		ADC wynik[BX-5],AH
		
		CMP SI,0
		JE zmniejsz_di
		DEC SI
		JMP oblicz_mnoz
		
		zmniejsz_di:
		CMP DI,0
		JE oblicz_mnoz_koniec
		DEC DI
		MOV SI,5
		JMP oblicz_mnoz
	
	oblicz_mnoz_koniec:
	;sprawdzenie przepelnienia
	MOV AL,wynik[-1]
	CMP AL,0
	JNE oblicz_przepelnienie
	MOV AL,wynik[-2]
	CMP AL,0
	JNE oblicz_przepelnienie
	MOV AL,wynik[-3]
	CMP AL,0
	JNE oblicz_przepelnienie
	MOV AL,wynik[-4]
	CMP AL,0
	JNE oblicz_przepelnienie
	MOV AL,wynik[-5]
	CMP AL,0
	JNE oblicz_przepelnienie

	JMP oblicz_koniec
	
	oblicz_przepelnienie:
	STC ;bedzie informowac o bledzie
	RET
	
	oblicz_koniec:
	CLC
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
	CMP AL,'h'
	JE menu_h
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
	CALL wprowadz_b

	;usawienie kursora
	MOV AH,2
	MOV BH,0
	MOV DH,7 ;wiersz
	MOV DL,58 ;kolumna
	INT 10h
	
	MOV BX,OFFSET liczba
	CALL wyswietl_hex
	JMP menu_oblicz
menu_h:
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
	MOV DL,58 ;kolumna
	INT 10h

	MOV BX,OFFSET liczba
;	CALL wprowadz_h

menu_oblicz:
;oblicz
CALL oblicz

;usawienie kursora
MOV AH,2
MOV BH,0
MOV DH,8 ;wiersz
MOV DL,14 ;kolumna
INT 10h

JC wyswietl_blad

MOV BX,OFFSET wynik
CALL wyswietl_bin

;usawienie kursora
MOV AH,2
MOV BH,0
MOV DH,8 ;wiersz
MOV DL,58 ;kolumna
INT 10h

MOV BX,OFFSET wynik
CALL wyswietl_hex

JMP menu

wyswietl_blad:
MOV AH,9h
MOV DX,OFFSET error
INT 21h
JMP menu

END start
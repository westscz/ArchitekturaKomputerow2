;potegowanie liczby - szescian

.MODEL SMALL
.STACK 100h

.DATA
 liczba DB 5 dup(?)
 wynik DB 10 dup(?) ;przy mnozeniu wynik moze miec 10 pozycji
 bufor DB 5 dup(?) ;zmienna pomocnicza
 info DB 'Program oblicza szescian wprowadzonej liczby',10,13,'$'
 podaj_liczbe DB 10,13,  'Wpisz liczbe:          [',40 dup (' '),']',8,'$' ;40 dup (' ') przesunie kursor na koniec
 wyswietl_wynik DB 10,13,'Szescian liczby wynosi: $'
 pytanie_czy_koniec DB 10,13,10,13,'Czy wyjsc z programu? (T/N)','$'
 blad DB 'DUZO :) [wynik za duzy]',7,'$' ;7 to dzwiek


.CODE
wyczysc_zmienna: ;zeruje 5 bajtow zaczynajac od BX (adres zmiennej)
	MOV CX,5
	zeruj_petla:
		MOV SI,CX
		MOV BYTE PTR BX[SI-1],0 ;BYTE PTR okresla, ze dana pod adresem BX jest 1-bajtowa
	LOOP zeruj_petla
RET

kopiuj_do_bufora: ;kopiuje 5 bajtow poczawszy od BX do zmiennej "bufor"
	MOV CX,5
	kopiuj_petla:
		MOV SI,CX
		MOV AL,BX[SI-1]
		MOV bufor[SI-1],AL
	LOOP kopiuj_petla
RET
		
	
wyswietl_bin: ;wyswietla 5-bajtowa zmienna spod adresu BX (bez zer poczatkowych)
	CALL kopiuj_do_bufora ;kopiuje liczbe do bufora, aby wyswietlic
	
	MOV CX,40 ;40 bitow do wyswietlenia
	MOV DH,0 ;zmienna pomocniczna - 0 -pomijac zera poczatkowe
	wyswietl_bin_petla:
		PUSH CX ;odklada licznik na potrzeby petli wewnetrznej
		MOV CX,5
		CLC ;zeruje CF
		wyswietl_przesun:
			MOV SI,CX
			RCL bufor[SI-1],1
		LOOP wyswietl_przesun
		POP CX
		
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
		MOV DH,1 ;musi wyswietlic kolejne zera
		MOV DL,'1'
		
		wyswietl:
		MOV AH,2
		INT 21h
	LOOP wyswietl_bin_petla
RET

czytaj_liczbe: ;wprowadza 40 bitow do zmiennej liczba
	;wyswietlenie liczby
	;cofniecie o 40 znakow w celu ustawienia kursora:
	MOV CX,40
	MOV AH,2h
	MOV DL,8 ;cofa kursor o 1
	cofnij_kursor:
		INT 21h
	LOOP cofnij_kursor

	MOV BX,OFFSET liczba
	CALL wyswietl_bin ;wyswietli liczbe

	pobierz_znak:
		MOV AH,8h
		INT 21h ;wczytanie znaku z klawiatury
		
	CMP AL,13 ;klawisz ENTER konczy wpisywanie
	JE zakoncz_czytanie
	CMP AL,8 ;klawisz kasowania
	JE nacisnieto_kasowanie
	
	;uniemozliwia prowadzenie wiekszej ilosci liczb
	CMP liczba[0],10000000b ;1najstarsze - nie mozna wiece wprowadzic
	JAE pobierz_znak
	
	CMP AL,'0'
	JE nacisnieto_dobra
	CMP AL,'1'
	JE nacisnieto_dobra
	
	JMP pobierz_znak
	
	zakoncz_czytanie:
	RET
	
	nacisnieto_dobra:
	;uaktualnienie zmiennej:
	MOV CX,5
	CLC ;czysci CF
	dopisz_do_liczby:
		MOV SI,CX
		RCL liczba[SI-1],1
	LOOP dopisz_do_liczby
	SUB AL,'0' ;zamieni znak na wartosc
	ADD liczba[4],AL
	
	JMP czytaj_liczbe
	
	nacisnieto_kasowanie:
	;usun ze zmiennej ostatnia pozycje
	MOV CX,5
	MOV SI,0
	CLC
	usun_z_liczby:
		RCR liczba[SI],1 ;usuwanie od najstarszej pozycji
		INC SI ;DEC nie nadpisuje CF!
	LOOP usun_z_liczby
	
	JMP czytaj_liczbe

zmien_znak_liczby: ;zmienia znak liczby spod BX (5 bajtow)
	;neguj
	MOV CX,5
	zmien_znak_petla:
		MOV SI,CX
		NOT BYTE PTR BX[SI-1] ;traktuj jako bajt
	LOOP zmien_znak_petla
	;dodaj 1
	MOV CX,5
	STC ;aby dodac 1 do najmlodszego
	zmien_znak_petla2:
		MOV SI,CX
		ADC BYTE PTR BX[SI-1],0 ;to przenosi "do gory" CF
	LOOP zmien_znak_petla2
RET

mnoz_liczba_przez_bufor: ;mnozy zmienne liczba i bufor zapisujac wynik w zmiennej wynik
			;przy wyjsciu funkca usatwia CF na 1 jesli nastapilo przepelnienie
	;czysc wynik (obie czesci)
	MOV BX,OFFSET wynik
	CALL wyczysc_zmienna
	MOV BX,OFFSET wynik[5]
	CALL wyczysc_zmienna
	
	;mnozenie na petli
	MOV SI,4
	MOV DI,4
	
	mnoz:
		MOV AH,liczba[DI]
		MOV AL,bufor[SI]
		MUL AH
		
		MOV BX,SI
		ADD BX,DI ;suma pozycji daje pozycje w wyniku-1
			;czyli dla mnozenia ostatnich - 4 i 4 - wynik bedzie na 8+1 i 8
		
		ADD wynik[BX+1],AL
		ADC wynik[BX],AH
		
		CMP SI,0
		JE zmniejsz_di ;jesli wskaznik SI osiagnal koniec - zmniejsz DI i ustaw SI ponownie na 4
		DEC SI
		JMP mnoz
		
		zmniejsz_di:
		CMP DI,0
		JE mnoz_koniec ;koniec mnozenia
		DEC DI
		MOV SI,5
		JMP mnoz
	
	mnoz_koniec:
	;sprawdzenie przepelnienia
	MOV CX,5
	sprawdz_przepelnienie: ;jakakolwiek czesc wyniku z zakresu [0]-[4] oznacza przepelnienie
		MOV SI,CX
		MOV AL,wynik[SI-1]
		CMP AL,0
		JNE mnozenie_przepelnienie
	LOOP sprawdz_przepelnienie
	JMP mnozenie_poprawnie

	mnozenie_przepelnienie:
		STC
		RET
	mnozenie_poprawnie:
		CLC
RET

poteguj:
	;sprawdza, czy wprowadzona liczba ujemna
	MOV AL,liczba[0]
	CMP AL,10000000b ;powyzej tej liczby to ujemna
	JAE liczba_jest_ujemna ;skok gdy wiekszy
	
	MOV DH,0 ; wskazuje, ze liczba byla dodatnia
	JMP liczba_jest_dodatnia
	
	liczba_jest_ujemna: ;wtedy zmien jej znak i sprawdz, czy nie przepelniono
		MOV DH,1 ;w DH zapamieta, ze liczba byla ujemna
		
		MOV BX,OFFSET liczba
		CALL zmien_znak_liczby
		;sprawdz, czy nie nastapilo przepelnienie
		MOV AL,liczba[0]
		CMP AL,10000000b ;powyzej tej liczby to ujemna
		JAE przepelnienie ;skok gdy wiekszy lub rowny
		
	liczba_jest_dodatnia:
	;skopiowanie liczby do zmiennej bufor (tak wymaga procedura mnozenia)
	MOV CX,5
	kopiuj_petla1:
		MOV SI,CX
		MOV AL,liczba[SI-1]
		MOV bufor[SI-1],AL
	LOOP kopiuj_petla1
	
	CALL mnoz_liczba_przez_bufor
	JC oblicz_koniec ;nie mnoz dalej jesli kwadrat dal przepelnienie
	
	;skopiowanie wyniku do bufora (do ponownego mnozenia przez liczbe)
	MOV CX,5
	kopiuj_petla2:
		MOV SI,CX
		MOV AL,wynik[SI+4] ;wlasciwy wynik zaczyna sie od wynik[5] i konczy na wynik[9]
		MOV bufor[SI-1],AL
	LOOP kopiuj_petla2
	
	CALL mnoz_liczba_przez_bufor
	JC oblicz_koniec
	
	;jesli byla potegowana ujemna - zmien znak wyniku
	CMP DH,0
	JE oblicz_koniec ;nie zmieniaj znaku jesli byla dodatnia
	
	MOV BX,OFFSET wynik[5]
	CALL zmien_znak_liczby
	CLC  ;przy ponownej zmianie znaku nie moze nastapic przepelnienie
	
	JMP oblicz_koniec
	
	przepelnienie:
		STC
	
	oblicz_koniec:
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
MOV DX,OFFSET info
INT 21h

;wprowadz
MOV DX,OFFSET podaj_liczbe
INT 21h

;wyczyszczenie liczby
MOV BX,OFFSET liczba
CALL wyczysc_zmienna

CALL czytaj_liczbe

;oblicz
CALL poteguj

;wyswietl wynik
MOV AH,9h
MOV DX,OFFSET wyswietl_wynik
INT 21h

JC wyswietl_blad

MOV BX,OFFSET wynik[5] ;wlasciwy wynik zaczyna sie od 5 bajtu
CALL wyswietl_bin
JMP kom_koniec

wyswietl_blad:
MOV AH,9h
MOV DX,OFFSET blad
INT 21h

kom_koniec:
MOV AH,09h
MOV DX,OFFSET pytanie_czy_koniec
INT 21h
czy_koniec:
	MOV AH,8h
	INT 21h
	CMP AL,'t'
	JE koncz_program
	CMP AL,'n'
	JNE czy_koniec
	JMP start

koncz_program:
MOV AX,4C00h
INT 21h

END start
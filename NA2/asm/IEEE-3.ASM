;podnoszenie liczby zmiennoprzecinkowej w standardzie IEEE 754 do 3 potegi

.MODEL SMALL
.STACK 100h

.DATA
 liczba DB 4 dup(?)
 znak DB ?
 cecha DB ?
 mantysa DB 3 dup(?)
 cecha_wynik DW ?;zmienna tymczasowa przechowujaca wartosc cechy po podniesieniu do potegi
 mantysa_wynik DB 9 dup (?);przechowa mantyse po podniesieniu do potegi
 		    ;9 bajtow, bo 3bajty*3bajty*3bajty moze dac 9 bajtow wyniku
 bufor_mnozenia DB 6 dup (?);przechowa wynik czesciowy po podniesieniu do kwadratu
 wynik DB 4 dup(?) ;liczba w IEEE 754 po podniesieniu do potegi 3

 info DB 'Program oblicza szescian wprowadzonej liczby w standardzie IEEE 754',10,13,'$'
 podaj_liczbe DB 10,13,  'Wpisz liczbe:          [',32 dup (' '),']','$'
 wyswietl_elementy DB 10,13,'   Znak:   [ ]'
 		   DB 10,13,'  Cecha: 2^[        ](U2)'
		   DB 10,13,'Mantysa: 1,[',23 dup (' '),']','$'
 wyswietl_wynik DB 10,13,10,13,'Szescian liczby wynosi: $'
 pytanie_czy_koniec DB 10,13,10,13,'Czy wyjsc z programu? (T/N)','$'

.CODE
odczytaj: ;powoduje wypelnienie zmiennych znak, cecha, mantysa na podstawie liczby spod [BX]
	  ;do mantysy dodawane jest od razu 1 na poczatek!
	;odczytanie znaku
	MOV AL,BX[0]
	SHR AL,7 ;1 bit staje sie ostatnim dla znaku
	MOV znak,AL
	
	;odczytanie cechy
	MOV AL,BX[0]
	MOV AH,BX[1]
	SHL AH,1
	RCL AL,1 ;w ten sposob odczytuje sie seche umieszczona na bitach 0-7 bajtu 0 i 8bicie bajtu 1
	MOV cecha,AL
	
	;odczytanie mantysy
	MOV AL,BX[1]
	OR AL,10000000b ;dodaje 1 na poczatek mantysy, aby bylo 1,----
	MOV mantysa[0],AL
	MOV AL,BX[2]
	MOV mantysa[1],AL
	MOV AL,BX[3]
	MOV mantysa[2],AL
RET

wyswietl_CF: ;wyswietla na ekranie wartosc CF i nie kasuje jej!
	PUSHF ;odklada na stos znaczniki, w tym CF, aby nie stracic
	PUSH AX ;bo wyswietl_CF zmienia
	PUSH DX
	
	JC wyswietl_1
	
	MOV DL,'0'
	JMP wyswietl
	
	wyswietl_1:
	MOV DL,'1'
	
	wyswietl:
	MOV AH,2
	INT 21h
	
	POP DX
	POP AX
	POPF ;sciaga ze stosu znaczniki
RET
	
wyswietl_bin: ;wyswietla 4-bajtowa zmienna spod adresu BX
	MOV CX,32 ;32 bity do wyswietlenia
	wyswietl_bin_petla:
		SHL BYTE PTR BX[3],1
		RCL BYTE PTR BX[2],1
		RCL BYTE PTR BX[1],1
		RCL BYTE PTR BX[0],1
		
		;w CF znajduje sie liczba z najsatrszej pozycji
		CALL wyswietl_CF
		ADC BYTE PTR BX[3],0 ;aby nie utracic liczby - wpisuje to co wyskoczylo na koniec
				;w ten sposob liczba "chodzi" w kolko
	LOOP wyswietl_bin_petla
RET

wyswietl_dane: ;wyswietla zawartosc zmiennych znak, cecha i mantysa (bez poczatkowej 1)
	CMP znak,0
	JE wyswietl_plus
	
	MOV DL,'-'
	JMP wyswietl_znak
	
	wyswietl_plus:
	MOV DL,'+'
	
	wyswietl_znak:
	MOV AH,2
	INT 21h
	
	;cofniecie kursora i opuszczenie
	MOV DL,10
	INT 21h
	MOV DL,8
	INT 21h
	
	;wyswietlenie cechy
	MOV CX,8
	MOV AL,cecha ;tymczasowo
	SUB AL,127 ;bo to nadmiar
	wyswietl_ceche_petla:
		SHL AL,1 ;to wyskoczy laduje w CF
		CALL wyswietl_CF
	LOOP wyswietl_ceche_petla

	;cofniecie kursora i opuszczenie
	MOV DL,10
	MOV AH,2
	INT 21h
	MOV DL,8
	MOV CX,8 ;cofniecie o 8 pozycji
	cofnij_kursor_petla:
		INT 21h
	LOOP cofnij_kursor_petla
	
	;wyswietlenie mantysy bez 1 na poczatku
	;niwelowanie 1 cyfry
	SHL mantysa[2],1
	RCL mantysa[1],1
	RCL mantysa[0],1
	ADC mantysa[2],0
	
	MOV CX,23
	wyswietl_mantyse_petla:
		SHL mantysa[2],1
		RCL mantysa[1],1
		RCL mantysa[0],1
		CALL wyswietl_CF
		ADC mantysa[2],0 ;aby nie stracic zawartosci zmiennej
	LOOP wyswietl_mantyse_petla
RET

czytaj_liczbe: ;wprowadza 32 bitow do zmiennej liczba
	MOV CX,32
	pobierz_znak:
		MOV AH,8h
		INT 21h ;wczytanie znaku z klawiatury
		
		CMP AL,8 ;klawisz kasowania
		JE nacisnieto_kasowanie
		CMP AL,'0'
		JE nacisnieto_dobra
		CMP AL,'1'
		JE nacisnieto_dobra
	JMP pobierz_znak
	
	nacisnieto_dobra:
	MOV DL,AL
	MOV AH,2
	INT 21h

	;uaktualnienie zmiennej:
	PUSH CX ;odlozenie na potrzeby petli wew.
	MOV CX,4
	MOV SI,3
	CLC ;czysci CF
	dopisz_do_liczby:
		RCL liczba[SI],1
		DEC SI ;nie zmienia CF
	LOOP dopisz_do_liczby
	SUB DL,'0' ;zamieni znak na wartosc
	ADD liczba[3],DL ;wstawia wprowadzona na pierwsza pozycje
	
	POP CX
	
	LOOP pobierz_znak
RET
	
	nacisnieto_kasowanie:
	CMP CX,31
	JA pobierz_znak ;nie pozwol kasowac za duzo
	
	;skauj na ekranie
	MOV DL,8
	MOV AH,2
	INT 21h
	MOV DL,' '
	INT 21h
	MOV DL,8
	INT 21h
	
	;usun ze zmiennej pierwsza
	PUSH CX ;odlozenie na potrzeby petli wew.
	MOV CX,4
	MOV SI,0
	CLC
	usun_z_liczby:
		RCR liczba[SI],1 ;usuwanie od najstarszej pozycji
		INC SI
	LOOP usun_z_liczby
	POP CX
	INC CX ;cofniecie liczby znakow
	
	JMP pobierz_znak ;nie zmieniono CX


mnoz_mantyse_przez_bufor: ;mnozy zmienne mantysa i bufor_mnozenia zapisujac wynik w zmiennej mantysa_wynik
	;czysc wynik
	MOV CX,9
	MOV SI,0
	wyczysc_mantysa_wynik_petla:
		MOV mantysa_wynik[SI],0
		INC SI
	LOOP wyczysc_mantysa_wynik_petla
	
	;mnozenie na petli
	MOV SI,5 ;indeksowanie bufor_mnozenia
	MOV DI,2 ;indeksowanie mantysa
	
	mnoz:
		MOV AH,mantysa[DI]
		MOV AL,bufor_mnozenia[SI]
		MUL AH
		
		MOV BX,SI
		ADD BX,DI ;suma pozycji daje pozycje w wyniku-1
		
		ADD mantysa_wynik[BX+1],AL
		ADC mantysa_wynik[BX],AH
		
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
RET

poteguj:
	;rozczytanie liczby
	MOV BX,OFFSET liczba
	CALL odczytaj
	
	;skopiowanie liczby do bufora (podniesienie do kwadratu)
	MOV AL,mantysa[2]
	MOV bufor_mnozenia[5],AL
	MOV AL,mantysa[1]
	MOV bufor_mnozenia[4],AL
	MOV AL,mantysa[0]
	MOV bufor_mnozenia[3],AL
	MOV AL,0
	MOV bufor_mnozenia[2],AL
	MOV bufor_mnozenia[1],AL
	MOV bufor_mnozenia[0],AL
	
	CALL mnoz_mantyse_przez_bufor
	
	;skopiowanie wyniku do bufora (do ponownego mnozenia przez liczbe)
	MOV CX,6
	kopiuj_petla2:
		MOV SI,CX
		MOV AL,mantysa_wynik[SI+2] ;wlasciwy wynik zaczyna sie od wynik[5] i konczy na wynik[9]
		MOV bufor_mnozenia[SI-1],AL
	LOOP kopiuj_petla2
	
	CALL mnoz_mantyse_przez_bufor ;teraz bedzie szescian
	
	;mnozenie cechy
	MOV AH,cecha
	SUB AH,127 ;czyli przejscie na wlasciwa wartosc
	MOV AL,3 ;przez tyle bedziemy mnozyc
	IMUL AH ;AX=AH*AL - mnozenie ze znakiem
	ADC AX,0
	MOV cecha_wynik,AX
	
	;przesuwanie mantysy - 1 musi znalezc sie na wlasciwej pozycji
	;na poczatek zawsze przesun o 23*2 pozycji
	MOV CX,46
	przesun0:
		SHR mantysa_wynik[0],1
		RCR mantysa_wynik[1],1
		RCR mantysa_wynik[2],1
		RCR mantysa_wynik[3],1
		RCR mantysa_wynik[4],1
		RCR mantysa_wynik[5],1
		RCR mantysa_wynik[6],1
		RCR mantysa_wynik[7],1
		RCR mantysa_wynik[8],1
	LOOP przesun0
	
	przesuwanie_mantysy:
		MOV CX,6 ;sprawdzi 6 pierwszych bajtow, ktore musza byc 0
		MOV SI,0
		przesuwanie_sprawdz:
			CMP mantysa_wynik[SI],0
			JNE przesun
			INC SI
		LOOP przesuwanie_sprawdz
		JMP tworz_wynik

		przesun:
		MOV CX,9 ;przesuwa 9 bajtow
		MOV SI,0
		CLC ;musi dostawic 0 na poczatek
		przesun_loop:
			RCR mantysa_wynik[SI],1
			INC SI
		LOOP przesun_loop
		;na koniec zmieniamy ceche
		INC cecha_wynik
	JMP przesuwanie_mantysy
	
	tworz_wynik:
	;na koniec powrod do cechy zgodnie ze standardem
	ADD cecha_wynik,127 ;47 bierze sie stad, ze mnozenie mantys nie uwzglednia przecinka
	
	;przede wszystkim cecha musi byc teraz w przdziale 0-255
	CMP cecha_wynik,00000h ;wskazuje, ze cecha ujemna i z zakresu -127..128; mniejsza to za mala
	JL wynik_zero
	CMP cecha_wynik,000FFh ;wskazuje, ze cecha jest dodatnia i z zakresu -127..128; przekroczenie w gore to nieskonczonosc
	JA wynik_nieskonczonosc
	
	;formowanie wyniku
	MOV AX,cecha_wynik ;wystarczy mlodsza pozycja
	MOV AH,0
	SHR AL,1 ;aby wstawic we wlasciwe miejsce
	RCR AH,1 ;dostawia ew. 1 z przeniesienia
	MOV wynik[0],AL
	MOV wynik[1],AH
	;dostawianie mantysy
	MOV AL,mantysa_wynik[6]
	AND AL,01111111b ;obcina 1 z przodu mantysy
	ADD wynik[1],AL
	MOV AL,mantysa_wynik[7]
	MOV wynik[2],AL
	MOV AL,mantysa_wynik[8]
	MOV wynik[3],AL
	
	JMP poteguj_koniec
	
	wynik_zero: ;tworzy zero
	MOV wynik[0],0
	MOV wynik[1],0
	MOV wynik[2],0
	MOV wynik[3],0
	JMP poteguj_koniec
	
	wynik_nieskonczonosc: ;jesli przekroczono zakres - stworz nieskonczonosc
	MOV wynik[0],011111111b
	MOV wynik[1],0FFh ;same jedynki
	MOV wynik[2],0FFh
	MOV wynik[3],0FFh
	
	poteguj_koniec:
	;znak niezaleznie od wyniku
	MOV AL,znak
	SHL AL,7
	OR wynik[0],AL ;wstawia ew. jedynke na poczatek
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

;ustawienia kolorow
MOV AH,6
MOV AL,0
MOV BH,0+16*14 ;czarny na zoltym tle
MOV CL,24
MOV CH,2
MOV DL,24
MOV DH,2
INT 10h
MOV BH,0+16*12 ;czarny na jasnoczerwonym tle
MOV CL,25
MOV DL,32
INT 10h
MOV BH,0+16*15 ;czarny na bialym tle
MOV CL,33
MOV DL,55
INT 10h

;ustawienie kursora
MOV AH,2
MOV BH,0
MOV DH,2 ;wiersz
MOV DL,24
INT 10h

;wczytanie liczby
CALL czytaj_liczbe

;wyswietlenie jej danych
MOV AH,9h
MOV DX,OFFSET wyswietl_elementy
INT 21h
MOV AH,2
MOV BH,0
MOV DL,12 ;kolumna
MOV DH,3
INT 10h ;ustawil kursor

MOV BX,OFFSET liczba
CALL odczytaj ;usupelnia zmienne skladowe
CALL wyswietl_dane ;wyswietla elementy liczby

;oblicz
CALL poteguj

;wyswietl wynik
MOV AH,9h
MOV DX,OFFSET wyswietl_wynik
INT 21h

;ustawienia kolorow
MOV AH,6
MOV AL,0
MOV BH,14 ;zolty
MOV CL,24
MOV CH,7
MOV DL,24
MOV DH,7
INT 10h
MOV BH,12 ;jasnoczerwony
MOV CL,25
MOV DL,32
INT 10h
MOV BH,15 ;bialy
MOV CL,33
MOV DL,55
INT 10h

MOV AH,2
MOV BH,0
MOV DL,24 ;kolumna
MOV DH,7
INT 10h ;ustawil kursor

MOV BX,OFFSET wynik
CALL wyswietl_bin

MOV AH,9h
MOV DX,OFFSET wyswietl_elementy

INT 21h
MOV AH,2
MOV BH,0
MOV DL,12
MOV DH,8
INT 10h ;ustawil kursor

MOV BX,OFFSET wynik
CALL odczytaj ;usupelnia zmienne skladowe
CALL wyswietl_dane ;wyswietla elementy liczby

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
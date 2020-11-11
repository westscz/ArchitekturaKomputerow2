;*********************************
;* Cwiczenie Nr 1 / Inf          *
;* Autor: Dawid Najgiebauer      *
;*    2005 Politechnika Opolska  *
;*********************************

.MODEL SMALL
JUMPS    	 ;eliminuje problem relatywnych skokow
.STACK 100h

.DATA
  menu DB 'L - wprowadz dane1',10,13,'P - wprowadz dane2',10,13,'W - wykonaj odejmowanie dana1-dana2',10,13,'0,1 - wprowadz dane',10,13,'BackSpace - kasuj',10,13,'B - akceptuj',10,13,'ESC - wyjscie',10,13,'$'
  puste8 DB '        ','$'
  wyniki DB 10,13,'dana1 = [        ]',10,13,'dana2 = [        ]',10,13,'wynik = [        ]','$'
  o_pre DB '0x$'
  dana1 DB 0
  dana2 DB 0
  wynik DB ?

.CODE
  ;zainicjowanie segmentu danych
  MOV AX,SEG menu
  MOV DS,AX
  
  ;wyczyszczenie ekranu
MOV AX,0600h
MOV BH,8
MOV CX,0000h
MOV DX,184Fh
INT 10h
;ustawienie kursora
MOV AH,2h
MOV BH,0
MOV DH,0
MOV DL,0
INT 10h
;wyswietlenie menu
MOV AH,9
MOV DX,OFFSET menu
INT 21h
MOV DX,OFFSET wyniki
INT 21h

  menu_label:
  	;wyswietlenie wartosci w kodzie osemkowym:
	MOV AH,2h
	MOV BH,0
	MOV DH,8
	MOV DL,20
	INT 10h
	MOV AH,9h
	MOV DX,OFFSET o_pre
	INT 21h
	MOV BH,10000000b
	MOV CX,8
	MOV DL,0
	dana1_8:
		MOV AH,dana1
		AND AH,BH
		CMP AH,0
		JE dana1_8_czypisz
		INC DL
		dana1_8_czypisz:
		CMP CX,7
		JE dana1_8_pisz
		CMP CX,4
		JE dana1_8_pisz
		CMP CX,1
		JE dana1_8_pisz
		JMP dana1_8_niepisz
		dana1_8_pisz:
			ADD DL,'0'
			MOV AH,2h
			INT 21h
			MOV DL,0
		dana1_8_niepisz:
		SHL DL,1
		SHR BH,1
	LOOP dana1_8
  	;wyswietlenie wartosci w kodzie osemkowym:
	MOV AH,2h
	MOV BH,0
	MOV DH,9
	MOV DL,20
	INT 10h
	MOV AH,9h
	MOV DX,OFFSET o_pre
	INT 21h
	MOV BH,10000000b
	MOV CX,8
	MOV DL,0
	dana2_8:
		MOV AH,dana2
		AND AH,BH
		CMP AH,0
		JE dana2_8_czypisz
		INC DL
		dana2_8_czypisz:
		CMP CX,7
		JE dana2_8_pisz
		CMP CX,4
		JE dana2_8_pisz
		CMP CX,1
		JE dana2_8_pisz
		JMP dana2_8_niepisz
		dana2_8_pisz:
			ADD DL,'0'
			MOV AH,2h
			INT 21h
			MOV DL,0
		dana2_8_niepisz:
		SHL DL,1
		SHR BH,1
	LOOP dana2_8
		
	;ukrycie kursora
	MOV AH,2
	MOV BH,0
	MOV DH,25
	INT 10h
	;oczekiwanie na klawisz
	MOV AH,8
	INT 21h
	;pokazanie kursora
	PUSH AX ;zeby nie zgubic odczytanego znaku
	MOV AH,2
	MOV DH,0
	POP AX
	;sprawdzenie klawisza zwroconego w AL
	CMP AL,'l'
	JE wprowadz_lewa
	CMP AL,'p'
	JE wprowadz_prawa
	CMP AL,'w'
	JE wykonaj
	CMP AL,27
	JE koniec
	JMP menu_label

  wprowadz_lewa:
  	MOV dana1,0000h
	MOV CL,00h ;licznik ilosci wprowadzonych znakow
	;ustawienie kursora
	MOV AH,2h
	MOV BH,0
	MOV DH,8 ;wiersz
	MOV DL,9 ;kolumna
	INT 10h
	;wyczyszczenie pola
	MOV AH,9
	MOV DX,OFFSET puste8
	INT 21h
	;ustawienie ponowne kursora
	MOV AH,2h
	MOV BH,0
	MOV DH,8 ;wiersz
	MOV DL,9 ;kolumna
	INT 10h
  	;czekaj na klawisz 0,1,BS,B
	wprowadz_lewa_czytaj:
		MOV AH,8
		INT 21h
		;sprawdz, czy nie koniec
		CMP CL,8
		JE wprowadz_lewa_BS
		wprowadz_lewa_zero:
			CMP AL,'0'
			JNE wprowadz_lewa_jeden
			;uwzglednij
			SHL dana1,1
			;wyswietl
			MOV DL,'0'
			MOV AH,2
			INT 21h
			INC CL
			JMP wprowadz_lewa_czytaj
		wprowadz_lewa_jeden:
			CMP AL,'1'
			JNE wprowadz_lewa_BS
			;uwzglednij
			SHL dana1,1
			INC dana1
			;wyswietl
			MOV DL,'1'
			MOV AH,2
			INT 21h
			INC CL
			JMP wprowadz_lewa_czytaj
		wprowadz_lewa_BS:
			CMP AL,8
			JNE wprowadz_lewa_B
			;czy mozna kasowac
			CMP CL,0
			JE wprowadz_lewa_B
			;uwzglednij
			SHR dana1,1
			;wyswietl
			MOV DL,8
			MOV AH,2
			INT 21h
			MOV DL,' '
			INT 21h
			MOV DL,8
			INT 21h
			DEC CL
			JMP wprowadz_lewa_czytaj
		wprowadz_lewa_B:
			CMP AL,'b'
			JNE wprowadz_lewa_czytaj
			JMP menu_label
  
  wprowadz_prawa:
  	MOV dana2,0000h
	MOV CL,00h ;licznik ilosci wprowadzonych znakow
	;ustawienie kursora
	MOV AH,2h
	MOV BH,0
	MOV DH,9
	MOV DL,9
	INT 10h
	;wyczyszczenie pola
	MOV AH,9
	MOV DX,OFFSET puste8
	INT 21h
	;ustawienie ponowne kursora
	MOV AH,2h
	MOV BH,0
	MOV DH,9 ;wiersz
	MOV DL,9 ;kolumna
	INT 10h
  	;czekaj na klawisz 0,1,BS,B
	wprowadz_prawa_czytaj:
		MOV AH,8
		INT 21h
		;sprawdz, czy nie koniec
		CMP CL,8
		JE wprowadz_prawa_BS
		wprowadz_prawa_zero:
			CMP AL,'0'
			JNE wprowadz_prawa_jeden
			;uwzglednij
			SHL dana2,1
			;wyswietl
			MOV DL,'0'
			MOV AH,2
			INT 21h
			INC CL
			JMP wprowadz_prawa_czytaj
		wprowadz_prawa_jeden:
			CMP AL,'1'
			JNE wprowadz_prawa_BS
			;uwzglednij
			SHL dana2,1
			INC dana2
			;wyswietl
			MOV DL,'1'
			MOV AH,2
			INT 21h
			INC CL
			JMP wprowadz_prawa_czytaj
		wprowadz_prawa_BS:
			CMP AL,8
			JNE wprowadz_prawa_B
			;czy mozna kasowac
			CMP CL,0
			JE wprowadz_prawa_B
			;uwzglednij
			SHR dana2,1
			;wyswietl
			MOV DL,8
			MOV AH,2
			INT 21h
			MOV DL,' '
			INT 21h
			MOV DL,8
			INT 21h
			DEC CL
			JMP wprowadz_prawa_czytaj
		wprowadz_prawa_B:
			CMP AL,'b'
			JNE wprowadz_prawa_czytaj
			JMP menu_label

  wykonaj:
  	MOV AH,dana1
	MOV AL,dana2
	ADD AH,AL
	MOV wynik,AH
  	;wyswietlenie wartosci w kodzie osemkowym:
	MOV AH,2h
	MOV BH,0
	MOV DH,10 ;wiersz
	MOV DL,20 ;kol
	INT 10h
	MOV AH,9h
	MOV DX,OFFSET o_pre
	INT 21h
	MOV BH,10000000b
	MOV CX,8
	MOV DL,0
	wynik_8:
		MOV AH,wynik
		AND AH,BH
		CMP AH,0
		JE wynik_8_czypisz
		INC DL
		wynik_8_czypisz:
		CMP CX,7
		JE wynik_8_pisz
		CMP CX,4
		JE wynik_8_pisz
		CMP CX,1
		JE wynik_8_pisz
		JMP wynik_8_niepisz
		wynik_8_pisz:
			ADD DL,'0'
			MOV AH,2h
			INT 21h
			MOV DL,0
		wynik_8_niepisz:
		SHL DL,1
		SHR BH,1
	LOOP wynik_8
	;wynik binarnie
	MOV AH,2h
	MOV BH,0
	MOV DH,10 ;wiersz
	MOV DL,9 ;kol
	INT 10h
	MOV BH,10000000b
	MOV CX,8
	wynik_2:
		MOV AH,wynik
		AND AH,BH
		CMP AH,0
		JE wynik_2_1
		MOV DL,'1'
		JMP wynik_2_dalej
		wynik_2_1:
		MOV DL,'0'
		JMP wynik_2_dalej
		wynik_2_dalej:
		MOV AH,2h
		INT 21h
		SHR BH,1
	LOOP wynik_2
  	JMP menu_label

  koniec:
  	;zamkniecie programu
	MOV AL,00h  ;kod bledu zwracany do systemu operacyjnego
	MOV AH,4Ch
	INT 21h
END
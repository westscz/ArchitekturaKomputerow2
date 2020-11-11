;*********************************
;* Cwiczenie Nr 3 / Inf          *
;* Autor: Dawid Najgiebauer      *
;*    2005 Politechnika Opolska  *
;*********************************

.MODEL SMALL
JUMPS    	 ;eliminuje problem relatywnych skokow
.STACK 100h

.DATA
 bufor DB 5 dup(?)
 liczba1 DB 5 dup(?)
 liczba2 DB 5 dup(?)
 buforBCD DB 13 dup (?)
 wynik DB 5 dup(?)
 fatal_error DB ' FATAL ERROR!',7,'$'
 fatal_error_txt_data DB ' Wystapil blad przy wprowadzaniu liczby, ktorego nie da sie skorygowac',10,13,9,'Nastapi ponowne uruchomienie programu',10,13,10,9,'      Nacisnij jakikolwiek klawisz, aby kontynuowac...','$'
 div_by_0_error DB ' Gdzie cholero przez 0!?',7,'$'
 gwiazdki DB '**********','$'
 press_any_key DB ' Jeszcze raz? (ESC=nie)','$'

.CODE
ramki: 	;CH - lewa gorna kolumna, CL - lewy gorny wiersz
	;DH - lewa dolna kolumna, DL - lewy dolny wiersz
	;BH - atrybuty
	
	;wyczyszczenie ekranu
	MOV AX,0600h
	INT 10h
	mov al,cl ;wiersz
	
	ramka_x:
		mov ah,ch ;kolumna
		ramka_y:
			push dx
			push ax
			;ustawienie kursora
			mov dh,ah
			mov dl,al
			mov ah,2h
			mov bh,0
			int 10h
			pop ax			
			pop dx
			
			;rysowanie znakow
			cmp ah,ch
			je wiersz
			cmp ah,dh
			je wiersz
			cmp al,cl
			je kolumna
			cmp al,dl
			je kolumna
			
			;czysc srodek
			push ax
			push dx
			mov ah,2h
			mov dl,' '
			int 21h
			pop dx
			pop ax
			jmp koniec_petli
			
			wiersz:
			push ax
			push dx
			mov ah,2h
			mov dl,'Í'
			int 21h
			pop dx
			pop ax
			jmp koniec_petli
			
			kolumna:
			push ax
			push dx
			mov ah,2h
			mov dl,'º'
			int 21h
			pop dx
			pop ax
			jmp koniec_petli
			
			koniec_petli:
		
			inc ah
			cmp ah,dh
			jbe ramka_y
		
		inc al
		cmp al,dl
		jbe ramka_x
	
	;narozniki
	push dx
	;ustawienie kursora
	mov dh,ch
	mov dl,cl
	mov ah,2h
	mov bh,0
	int 10h
	;wypisanie
	mov dl,'É'
	int 21h
	pop dx
	push dx
	;ustawienie kursora
	mov dh,ch ;kolumna pozostaje
	mov ah,2h
	mov bh,0
	int 10h
	;wypisanie
	mov dl,'»'
	int 21h
	pop dx
	push dx
	;ustawienie kursora
	mov dl,cl ;wiersz pozostaje
	mov ah,2h
	mov bh,0
	int 10h
	;wypisanie
	mov dl,'È'
	int 21h
	pop dx
	;ustawienie kursora (dx juz jest)
	mov ah,2h
	mov bh,0
	int 10h
	;wypisanie
	mov dl,'¼'
	int 21h
	
	;ustawienie kursora
	MOV AH,2h
	MOV BH,0
	MOV DH,CH
	INC DH
	MOV DL,CL
	INC DL
	INT 10h
	
	RET

czysc_bufor:
	;wyczysc bufor
	MOV CX,5
	MOV SI,0
	czyszczenie_bufora:
		MOV bufor[SI],0
		INC SI
		LOOP czyszczenie_bufora
	RET
czysc_buforBCD:
	;wyczysc bufor
	MOV CX,13
	MOV SI,0
	czyszczenie_buforaBCD:
		MOV buforBCD[SI],0
		INC SI
		LOOP czyszczenie_buforaBCD
	RET

czytaj_liczbe:
	CALL czysc_bufor
	MOV BL,'1' ;w BL przechowywane jest, czy bufor!=0 (aby nie wpisywac 0 na pocz - '1' - brak danych, '0' sa dane=mozna pisac zero)
	;czytaj
	czytaj:
		MOV AH,8h
		INT 21h
		
		CMP AL,13
		JE koniec_czytania
		CMP AL,BL
		JB czytaj
		CMP AL,'9'
		JA czytaj
		MOV BL,'0'
		
		;przepelnienie?
		CMP bufor[4],25
		JA czytaj
		
		;wypisanie (przygotowanie)		
		MOV DL,AL
		
		;przesuwanie bufora
		MOV CX,5
		wprowadz_do_bufora:
			MOV SI,CX
			DEC SI
			MOV AH,bufor[SI]
			MOV AL,10
			MUL AH
			INC SI
			CMP SI,5
			JE nie_przenos_ah
			ADD bufor[SI],AH
			nie_przenos_ah:
			DEC SI
			MOV bufor[SI],AL
		LOOP wprowadz_do_bufora
		SUB DL,'0'
		MOV SI,0
		ADD bufor[SI],DL
		;przeniesienia
		przeniesienia:
		JNC brak_przeniesien
		INC SI
		CMP SI,5
		JE overfull_error
		ADD bufor[SI],1
		JMP przeniesienia
	
	brak_przeniesien:
		;wypisanie
		ADD DL,'0'
		MOV AH,2h
		INT 21h
		
		JMP czytaj

	overfull_error:
		;ramki
		mov CL,30
		mov ch,2
		mov dl,45
		mov dh,4
		MOV BH,16*(8+4)+14 ;podswietlenie (zolty na czerwonym, migajacy)
		CALL ramki
		MOV ah,9h
		MOV DX,OFFSET fatal_error
		INT 21h
		STC
		JMP koniec_czytania_2
	koniec_czytania:
		CLC
	koniec_czytania_2:
	RET

przenies_bufor_do_zmiennej: ;adres w BX
	MOV CX,5
	MOV SI,0
	przenies_bufor:
		MOV AH,bufor[SI]
		MOV [BX+SI],AH
		INC SI
		LOOP przenies_bufor
	RET

wypisz_buforBCD:
	MOV CX,13
	MOV AH,2h
	MOV BL,0
	wypisz:
		MOV SI,CX
		DEC SI
		MOV DL,buforBCD[SI]
		CMP DL,BL
		JE wypisz_koniec_petli ;pominie nieznaczace zera
		ADD DL,'0'
		INT 21h
		MOV BL,10
	wypisz_koniec_petli:
	LOOP wypisz
	CMP BL,0
	JNE wypisz_koniec
	MOV DL,'0'
	INT 21h
	wypisz_koniec:
	RET
	
oblicz:
	CALL czysc_bufor
	CALL czysc_buforBCD
	;czy nie dziel przez 0
	MOV CX,5
	MOV SI,0
	czy_l2_0:
		CMP liczba2[SI],0
		JNE oblicz_sum0
		INC SI
	LOOP czy_l2_0
	JMP oblicz_div0_error
		
	oblicz_sum0:
	MOV CX,5
	MOV SI,0
	CLC
	oblicz_sum:
		MOV AL,bufor[SI]
		ADC AL,liczba2[SI]
		MOV bufor[SI],AL
		INC SI
	LOOP oblicz_sum
;	MOV SI,5
	oblicz_cmp:
		DEC SI
		MOV AL,bufor[SI]
		CMP AL,liczba1[SI]
		JA oblicz_koniec
		JB iloczyn_0
		CMP SI,0
		JNE oblicz_cmp 
	;faktyczne ilosc zmieszczenia
	iloczyn_0:
	MOV SI,0
	iloczyn:
		INC buforBCD[SI]
		CMP buforBCD[SI],10
		JNE iloczyn_nie ;to samo, co przeniesienie
		MOV buforBCD[SI],0
		INC SI
		JMP iloczyn

	iloczyn_nie:
		;zegar
		MOV CX,5
		MOV SI,0
		zegar_pomin:
			INC SI			
			CMP buforBCD[SI],0
			JNE oblicz_sum0 ;(oszczednosci w rysowaniu zegara)
		LOOP zegar_pomin
		MOV AH,2h
		CMP DL,'|'
		JE ukos_2
		CMP DL,'/'
		JE ukos_3
		CMP DL,'-'
		JE ukos_4
		ukos_1:	MOV DL,'|'
			JMP ukos_0
		ukos_2: MOV DL,'/'
			JMP ukos_0
		ukos_3: MOV DL,'-'
			JMP ukos_0
		ukos_4: MOV DL,'\'

		ukos_0:	INT 21h
		PUSH DX
		MOV DL,8
		INT 21h
		POP DX
		;-------EOZegar--------
	
	JMP oblicz_sum0
	
	oblicz_div0_error:
		STC
		JMP oblicz_koniec_no
		
	oblicz_koniec:
		CLC
	oblicz_koniec_no:
	RET

start:
;zainicjowanie segmentu danych
MOV AX,SEG bufor
MOV DS,AX
  
;wyczyszczenie ekranu
MOV AX,0600h
MOV BH,7
MOV CX,0000h
MOV DX,184Fh
INT 10h

start_2:
	;ramki
	mov CL,0
	mov ch,0
	mov dl,79
	mov dh,23
	MOV BH,16*2+15 ;podswietlenie (bialy na zielonym)
	CALL ramki
	
	mov CL,2
	mov ch,4
	mov dl,55
	mov dh,6
	MOV BH,16*1+7 ;podswietlenie (szary na niebieskim)
	CALL ramki
	
	CALL czytaj_liczbe
	JC fatal_error_txt
	
	MOV BX,OFFSET liczba1
	CALL przenies_bufor_do_zmiennej

	MOV DL,':'
	MOV AH,2h
	INT 21h
	
	CALL czytaj_liczbe
	JC fatal_error_txt

	MOV BX,OFFSET liczba2
	CALL przenies_bufor_do_zmiennej

	MOV DL,'='
	MOV AH,2h
	INT 21h

	CALL oblicz
	JC wypisz_gwiazdki

	CALL wypisz_buforBCD
	JMP wypisz_gwiazdki_pomin
	
	wypisz_gwiazdki:
		MOV AH,9h
		MOV DX,OFFSET gwiazdki
		INT 21h
		;ramki
		mov CL,30
		mov ch,2
		mov dl,56
		mov dh,4
		MOV BH,16*(8+4)+14 ;podswietlenie (zolty na czerwonym, migajacy)
		CALL ramki
		MOV ah,9h
		MOV DX,OFFSET div_by_0_error
		INT 21h

	wypisz_gwiazdki_pomin:
	;press any key...
	;ramki
	mov CL,30
	mov ch,18
	mov dl,56
	mov dh,20
	MOV BH,16*(1+8)+7
	CALL ramki
	MOV ah,9h
	MOV DX,OFFSET press_any_key
	INT 21h
	
	MOV AH,8h
	INT 21h
	CMP AL,27
	JNE start_2

koncz_program:
	MOV AX,4C00h
	INT 21h

fatal_error_txt:
	;ramki
	mov CL,2
	mov ch,10
	mov dl,75
	mov dh,16
	MOV BH,16*4+14 ;podswietlenie (zolty na czerownym)
	CALL ramki

	MOV DX,OFFSET fatal_error_txt_data
	MOV AH,9
	INT 21h
	MOV AH,8
	INT 21h
	JMP start_2

END start
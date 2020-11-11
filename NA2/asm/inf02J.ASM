;*********************************
;* Cwiczenie Nr 2 / Inf          *
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
 komunikat_koniec DB 'Czy zakonczyc prace programu? (T/N)','$'
 error DB '   !BLAD!','$'
 wynik DB 5 dup(?)


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

czytaj_liczbe:
	CALL czysc_bufor
	;czytaj
	MOV CX,10
	czytaj:
		MOV AH,8h
		INT 21h
		CMP CX,10 ;(minus lub plus)
		JE plus_minus 
		CMP AL,'0'
		JB zly_znak ;gdy mniejszy
		CMP AL,'9'
		JA zly_znak ; gdy wiekszy
		JMP dobry_znak
		plus_minus:
		CMP AL,'0'
		JE dobry_znak
		CMP AL,'1'
		JE dobry_znak
		zly_znak:
			JMP czytaj
		dobry_znak:
			MOV DL,AL
			SUB AL,'0'
			MOV SI,CX
			DEC SI
			SHR SI,1
			;czy przesunac
			MOV BX,CX
			AND BX,00000001b
			CMP BX,0
			JE bez_przesuniecia
			SHL bufor[SI],4
			bez_przesuniecia:
			ADD bufor[SI],AL
			MOV AH,2h
			INT 21h
			LOOP czytaj
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

wypisz_bufor:
	PUSHF
	MOV CX,5
	wypisz:
		MOV SI,CX
		DEC SI
		MOV AH,bufor[SI]
		AND AH,11110000b
		SHR AH,4
		MOV DL,AH
		ADD DL,'0'
		MOV AH,2h
		INT 21h
		MOV AH,bufor[SI]
		AND AH,1111b
		MOV DL,AH
		ADD DL,'0'
		MOV AH,2h
		INT 21h
		LOOP wypisz

		;przeprzelnienie w buforze:
		POPF
		JNC no_error
		;ramki
		mov CL,30
		mov ch,2
		mov dl,44
		mov dh,4
		MOV BH,16*(8+4)+14 ;podswietlenie (zolty na czerwonym, migajacy)
		CALL ramki
		MOV ah,9h
		MOV DX,OFFSET error
		INT 21h
		no_error:
	RET
	
oblicz:
	CALL czysc_bufor
	MOV BX,0
	oblicz_l2:
		MOV CX,0
		oblicz_l1:
			MOV SI,BX
			AND SI,1b
			CMP SI,0
			JE bez_przeniesienia_l2
			MOV SI,BX
			SHR SI,1
			MOV AL,liczba2[SI]
			AND AL,11110000b
			SHR AL,4
			JMP mnozenie_2
			bez_przeniesienia_l2:
			MOV SI,BX
			SHR SI,1
			MOV AL,liczba2[SI]
			AND AL,1111b
			
			mnozenie_2:
			;cyfra z liczby1
			MOV SI,CX
			AND SI,1b
			CMP SI,0
			JE bez_przeniesienia_l1
			MOV SI,CX
			SHR SI,1
			MOV AH,liczba1[SI]
			AND AH,11110000b
			SHR AH,4
			JMP mnozenie_3
			bez_przeniesienia_l1:
			MOV SI,CX
			SHR SI,1
			MOV AH,liczba1[SI]
			AND AH,1111b
			
			mnozenie_3:
			;wykonanie mnozenia z korekcja
			MUL AH
			AAM
			
			;zapisanie wyniku
			MOV SI,BX
			ADD SI,CX
			AND SI,1b
			CMP SI,0
			JE bez_przeniesienia_wynik
			MOV SI,BX
			ADD SI,CX
			SHR SI,1
			SHL AL,4

			CMP SI,4
			JA mnozenie_4
			
			ADD bufor[SI],AL
			MOV AL,bufor[SI]
			AND AL,11110000b
			SHR AL,4
			CMP AL,9
			JBE bez_korekcji_1
			SUB bufor[SI],0A0h
			ADD AH,1
			bez_korekcji_1:
			INC SI
			
			MOV AL,AH ;(na potrzeby overfull)
			
			CMP SI,4
			JA mnozenie_4
			
			ADD bufor[SI],AH
			JMP mnozenie_4
			bez_przeniesienia_wynik:
			MOV SI,BX
			ADD SI,CX
			SHR SI,1

			CMP SI,4
			JA mnozenie_4
			
			ADD bufor[SI],AL
			MOV AL,bufor[SI]
			AND AL,1111b
			CMP AL,9
			JBE bez_korekcji_2
			SUB bufor[SI],10
			ADD AH,1
			bez_korekcji_2:
			SHL AH,4
			ADD bufor[SI],AH
			
			mnozenie_4:
			
			CMP SI,4
			JNA mnozenie_5
			;czy overfull?
			CMP AL,0
			JNE overfull
			
			mnozenie_5:
			
			INC CX
			CMP CX,9
			JB oblicz_l1
		INC BX
		CMP BX,9
		JB oblicz_l2
		
		;sprawdzanie bledu przepelnienia
		MOV AL,bufor[4]
		AND AL,11110000b
		CMP AL,0
		JE bez_bledu
		
		overfull:
			STC
			RET
		
		bez_bledu:
		CLC
		;obliczanie znaku:
		MOV AH,liczba1[4]
		AND AH,11110000b
		MOV AL,liczba2[4]
		AND AL,11110000b
		XOR AL,AH
		ADD bufor[4],AL
		
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
mov dl,35
mov dh,6
MOV BH,16*1+7 ;podswietlenie (szary na niebieskim)
CALL ramki
CALL czytaj_liczbe
MOV BX,OFFSET liczba1
CALL przenies_bufor_do_zmiennej
MOV DL,'*'
MOV AH,2h
INT 21h
CALL czytaj_liczbe
MOV BX,OFFSET liczba2
CALL przenies_bufor_do_zmiennej
MOV DL,'='
MOV AH,2h
INT 21h
CALL oblicz
CALL wypisz_bufor

;ramki
mov CL,20
mov ch,7
mov dl,56
mov dh,9
MOV BH,16*1+15 ;podswietlenie (bialy na niebieskim)
CALL ramki
MOV AH,09h
MOV DX,OFFSET komunikat_koniec
INT 21h
czy_koniec:
	MOV AH,8h
	INT 21h
	CMP AL,'t'
	JE koncz_program
	CMP AL,'n'
	JNE czy_koniec
	JMP start_2

koncz_program:
MOV AX,4C00h
INT 21h
END start
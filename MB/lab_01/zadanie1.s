
/*
    Program ma za zadanie pobrac z klawiatury liczbe w postaci 16stkowej,
    a nastepnie przekonwertowac ja na wartosc binarna i zapisac w pamieci
    pod adresem &wynik.

    Do sprawdzenia poprawnosci programu trzeba uzyc `break brejk_przed_wysciem`
    a nastepnie podejrzec pamiec `x /x &wynik`
*/

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
BAJTY_LICZBY = 64

.align 32
.data
	bufor: .space BAJTY_LICZBY
	wynik: .space BAJTY_LICZBY
.text
.global main

main:
wczytywanie:
	mov $SYSREAD, %rax
	mov $STDIN, %rbx
	mov $bufor, %rcx
	mov $BAJTY_LICZBY, %rdx
	int $0x80


/*
	w r10 ilosc wprowadzonych znakow
	rax przygotowany na przetrzymywanie danych
	w r15 licznik do wyniku
*/
	xor %r10, %r10
	mov %rax, %r10
	xor %rax, %rax
  	xor %r15, %r15
czytaj_bufor: 
	dec %r10
	cmp $0, %r10
	je exit

	xor %rbx, %rbx
	movb bufor-1(,%r10,1), %bl
porownywanie:

/*
	sprawdzanie liczb
*/

	cmp $'f', %bl
	ja czytaj_bufor

	cmp $'a', %bl
	jae litera
	
	cmp $'F', %bl
	ja czytaj_bufor

	cmp $'A', %bl
	jae litera

	cmp $'9', %bl
	ja czytaj_bufor
	
	cmp $'0', %bl
	jae cyfra

	jmp czytaj_bufor

litera:
	add $9, %bl
cyfra:
	and $0x0f, %bl
zapisz:
	cmp $0, %rax
	jne polacz_cyfry
	mov %bl, %al
	jmp czytaj_bufor
/*
    Jako ze jedna liczba zabiera nam 4bity, a do pamieci mozemy odlozyc
    tylko dwie liczby na raz to laczymy cyfry w pary i dopiero odkladamy
*/
polacz_cyfry:
	shl $4, %bl
	add %al, %bl
	xor %rax, %rax
zapisz_bl:
	movb %bl, wynik(,%r15,1) 
	inc %r15

	jmp czytaj_bufor

al_do_bl_zapisz:
	mov $1, %r10
	mov %al, %bl
	xor %al, %al
	jmp zapisz_bl

exit:
	cmp $0, %al
	jnz al_do_bl_zapisz

brejk_przed_wyjsciem:
	mov $SYSEXIT, %rax
	mov $EXIT_SUCCESS, %rbx
	int $0x80

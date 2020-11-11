# program sortujacy liczby U2
# autor: Michal Malinka
# data: 26.03.2013

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.align 64

.bss
	.lcomm ilosc_liczb, 5
	.lcomm ilosc_bajtow, 5


.text
	nextline: .ascii "\n" ;
	dlug_nextline= .-nextline ;

.data
	tablica: .space 80000 ;
	dlug_tablica=.-tablica ;
	element1: .space 8 ;
	dlug_element1=.-element1 ;
	element2: .space 8 ;
	dlug_element2=.-element2 ;
	elementpom: .space 8 ;
	dlug_elementpom2=.-elementpom ;

.global _start ;
_start:

	mov $SYSREAD,		%eax ;
	mov $STDIN,		%ebx ;
	mov $tablica,		%ecx ;
	mov $dlug_tablica,	%edx ;
	int $0x80 ;

#####################################################
### przetworzenie dlugosci tablicy na ilosc liczb ###
#####################################################
	movl %eax ,		ilosc_bajtow ;
	movl $0 ,		%edx ;	# zabieg do dzielenia
	movl $8 ,		%ecx ;	# do podzielenia przez 8
	div %ecx ;			# dzielenie przez 8, bo typ danych to 64b
	mov %eax , ilosc_liczb ;	# dlugosc tablicy

##############################################
### sortowanie babelkowe tablicy liczb 64b ###
##############################################
	movl $1 ,	%esi ;	# dlatego 1, ze petla zewnetrzna musi dzialac do
				# elementu o 1 wiecej niz dlugosc tablicy
				# w 1 obiegu petli jest to odejmowane
petla_zewn:
	dec %esi ;		# redukcja do prawidlowej wartosci
	movl %esi ,	%edi ;	# licznik petli wewnetrznej
	inc %edi ;		# pierwszy element petli wewn jest o 1 wiekszy

petla_wewn:
	mov tablica(,%esi,8) ,	%rax ;	# skopiowanie wartosci z petli zewn
	mov tablica(,%edi,8) ,	%rbx ;	# wartosc z petli wewn
	mov %rax ,	element1 ;	# skopiowanie wartosci z petli zewn
	mov %rbx ,	element2 ;	# wartosc z petli wewn
	
	mov $0 ,	%ecx ;	#rejestr indeksujacy po elemencie z ktorego przenosimy
	mov $7 ,	%edx ;	#rejestr indeksujacy po elemencie przeniesionym
petla_elem1:	# petla zamieniajaca na czas sortowania kolejność bajtów w liczbie
	movb element1(,%ecx,1) ,	%al ;	# przekopiowanie kolejnego bajtu od 
						# początku indeksowane przez ecx
	movb %al ,	elementpom(,%edx,1) ;	# na miejsce indeksowane od konca
						# przez edx
	inc %ecx ;		# kolejny indeks będzie przepisywany
	dec %edx ;		# na kolejnym indeksie będzie zapisywany
	cmp $8 ,	%ecx ;	# sprawdzenie czy to niej est czasem ostatni bajt
	jb petla_elem1 ;	# jeśli nie to powtarzamy
	
	mov elementpom ,	%rax ;	# przeniesienie elementu odwróconego do rax żeby
					# potem porównać z tym co będzie w rbx

	mov $0 ,	%ecx ;	#rejestr indeksujacy po elemencie z ktorego przenosimy
	mov $7 ,	%edx ;	#rejestr indeksujacy po elemencie przeniesionym
petla_elem2:
	movb element2(,%ecx,1) ,	%bl ;	# przekopiowanie kolejnego bajtu od 
						# początku indeksowane przez ecx
	movb %bl ,	elementpom(,%edx,1) ;	# na miejsce indeksowane od konca
						# przez edx
	inc %ecx ;		# kolejny indeks będzie przepisywany
	dec %edx ;		# na kolejnym indeksie będzie zapisywany
	cmp $8 ,	%ecx ;	# sprawdzenie czy to niej est czasem ostatni bajt
	jb petla_elem2 ;	# jeśli nie to powtarzamy
	
	mov elementpom ,	%rbx ;	# przeniesienie elementu odwróconego do rax żeby
					# potem porównać z tym co będzie w rbx

	cmp %rax ,	%rbx ;	# porownanie czy zamienic ze sobą miejscami zmienne
	jle jesli_bez_zmiany ;	# jeśli nie to przeskakujemy poniższe instrukcje

	# jesli je zamieniamy, to przepisywane powynny byc odwrotnie
	mov tablica(,%esi,8) ,	%rax ;	# skopiowanie wartosci z petli zewn
	mov tablica(,%edi,8) ,	%rbx ;	# wartosc z petli wewn
	mov %rbx ,	tablica(,%esi,8) ;	# zamiana miejscami rozpatrywanych elementów
	mov %rax ,	tablica(,%edi,8) ;	# zamiana miejscami rozpatrywanych elementów
	
jesli_bez_zmiany:	# gdy nie powinny byc zamienione to zamiane omijamy

	inc %edi ;		# kolejna liczba z tablicy
	cmp ilosc_liczb , %edi ;# czy juz wszystkie liczby
	jb petla_wewn ;		# jesli nie to wracamy

	inc %esi ;		# kolejna liczba z tablicy
	inc %esi ;		# w celu sprawdzenia czy nie doszlismy do konca
	cmp ilosc_liczb , %esi ;	# sprawdzenie czy juz wszystkie liczby
	jb petla_zewn ;		# jesli nie to wracamy

# wypisanie
	movl $SYSWRITE,		%eax ;
	movl $STDOUT,		%ebx ;
	movl $tablica ,		%ecx ;
	movl ilosc_bajtow ,	%edx ;
	int $0x80 ;

	mov $SYSEXIT,		%eax ;
	mov $EXIT_SUCCESS,	%ebx ;
	int $0x80 ;


.align 32
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN=0
EXIT_SUCCESS = 0

.data
	msg_hello: .ascii ""
	.comm msg_hello_len,10
.text

.global _start

_start:
	#################################wczytywanie

	mov $SYSREAD, %eax  		#co chce 
	mov $STDIN, %ebx 		#jaka operacja
	mov $msg_hello, %ecx 		#gdzie
	mov $msg_hello_len, %edx 	#ile znakow
	int $0x80 			

	#################################przetwarzanie	

	mov $(-1),%eax			#przenosze -1 bo potem i tak to dodam w petli	

_loop:	
	inc %eax			#inkrementuje aktulna pozycje w tekscie
	movb msg_hello(%eax),%bl	#pobieram jeden znak do rejestru ebx
	cmp $0xA, %ebx			#czy mamy znak '\n'
	je _koniec			#jesli tak to konczymy

_czyWiekszeOd0:	
	cmp $0x30,%ebx			#sprawdzam czy jest wieksze od '0'
	jae _czyMniejszeOd9		#jesli jest to sprawdz czy mniejsze lub rowne '9'
	movb $0x20, msg_hello(%eax)	#w przeciwnym przypadku wklepuje spacje,gdyz napewno nie bedzie dozwolonym znakiem
	jmp _loop			#i zajmuje sie kolejna

_czyMniejszeOd9:
	cmp $0x39,%ebx			#sprawdzam czy jest mniejsze lub rowne '9'
	jbe _loop			#jesli jest cyfra to jest ok i zajmuje sie nastepnym znakiem, jesli nie jest cyfra to patrze czy nie jest moze litera		

_czyWiekszeOdDuzegoA:
	cmp $0x41,%ebx			#sprawdzam czy jest wieksza lub rowna 'A'
	jae _czyMniejszeOdDuzegoZ	#jesli tak to skacze sprawdzic czy jest mniejsz badz rowna Z
	movb $0x20, msg_hello(%eax)	#skoro jest mniejsza od A i nie jest cyfra to jest zla i zmieniam ja
	jmp _loop			#i zajmuje sie kolejna

_czyMniejszeOdDuzegoZ:
	cmp $0x5A,%ebx			#sprawdzam czy mniejsza lub rowna 'Z'  
	jbe _loop			#jesli tak to jest ok i zajmuje sie nastepne w przeciwnym wypadku sprawdzam czy moze jest mala litera

_czyWiekszaOda:	
	cmp $0x61,%ebx			#czy jest wieksza lub rowna 'a'
	jae _czyMniejszeOdMalegoz	#jesli tak to sprawdzamy czy jest mniejsza od 'z'
	movb $0x20, msg_hello(%eax) 	#jesli jest mniejsza od a i napewno wiemy ze nie jest liczba ani mala litera to trzeba ja zamienic	
	jmp _loop			#i zajmuje się kolejna
	
_czyMniejszeOdMalegoz:			
	cmp $0x7A,%ebx			#sprawdzam czy mniejsza lub rowna 'z'
	jbe _loop			#jesli tak to mnie nie interesuje i wracam do petli
	movb $0x20, msg_hello(%eax)	#w przeciwnym przypadku wklepuje spacje ,gdyz nie jest mozliwy inny znak alfanumeryczny
	jmp _loop			#i biore sie za kolejny element

	#################################wypis

_koniec:
	mov %eax,%edx			#zapamietuje ile bylo znakow przed \n zeby nie wypisywac na daremno za duzo
	mov $SYSWRITE, %eax 		#przygotowuje wszystko i wzywam system
	mov $STDOUT, %ebx 
	mov $msg_hello, %ecx 
	int $0x80	

	mov $SYSEXIT, %eax 		#znak sukcesu
	mov $EXIT_SUCCESS, %ebx
	
	int $0x80	

.align 32
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

.data
	ciag_wpisany: 
		.string ""
		.space 4096
	ciag_wpisany_len: 
		.word 4096
		.space 4
.data
	bufor:
		.string ""
		.space 16384
	bufor_len:
		.word 16384 
		.space 4
.data
	hex:
		.string ""
		.space 4096		
	hex_len:
		.word 4096
		.space 4 

.text

.global main
main:
	mov $SYSREAD, %eax 
	mov $STDIN, %ebx 
	mov $ciag_wpisany, %ecx 
	mov $ciag_wpisany_len, %edx 
	int $0x80
	
	mov $(-1),%ebx					/*ustawiam licznik na -1*/

_ileWpisano:
	inc %ebx						/*inkrementuje licznik*/
	movb ciag_wpisany(%ebx),%al		/*kopiuje aktualny znak*/
	cmp $10,%eax					/*sprawdzam czy jest to znak nowej linii*/
	jne _ileWpisano					/*jezeli to nie znak nowej linii to iteruj dalej*/
	
	/*znam dlugosc wpisanego slowa dlatego ustawiam dlugosci poszczegolnych stringow*/

_ustaw:	
	mov %ebx,ciag_wpisany_len		/*zmieniam dlugosc ciagu wpisanego*/
	mov %ebx,hex_len				/*zmieniam dlugosc slowa szesnastkowego*/
	shl $2,%ebx						
	mov %ebx,bufor_len				/*ustawiam dlugosc slowa binarnego*/
	
	mov $(-1),%ebx					/*ustawiam licznik na -1*/

_zamienASCIInaCyfry:
	inc %ebx						/*inkrementuje licznik*/
	cmp ciag_wpisany_len,%ebx		/*sprawdzam czy petla juz sie skonczyla*/
	je _ustawRejestryDoZamiany		/*jesli tak to skacze do instrukcji ustawienia rejestrow do zamiany*/
	movb ciag_wpisany(%ebx),%al		/*pobieram aktualny znak z ciagu wpisanego*/
	sub $0x30,%eax					/*odejmuje znak ASCII '0' od aktualnego znaku*/
	movb %al,ciag_wpisany(%ebx)		/*wysylam z powrotem zamieniony znak na cyfre*/
	jmp _zamienASCIInaCyfry			/*wykonuje ponownie petle*/

_ustawRejestryDoZamiany:
	mov $(-1),%ebx					/*ustawiam licznik na %ebx*/
	mov bufor_len,%ecx				/*licznik dla liczby binarnej*/
	jmp _sprawdzCzySaZera

_zamianaNaBinarny:
	dec %ecx						/*inkrementuje licznik do zamiany liczby binarnej*/
	movb %dl,bufor(%ecx)			/*wysylam aktulna reszte do bufora*/
	mov $(-1),%ebx					/*zeruje licznik*/

_sprawdzCzySaZera:					/*sprawdzam czy w wpisanym ciagu sa same zera*/
	inc %ebx						/*inkrementuje licznik*/
	cmp ciag_wpisany_len,%ebx		/*sprawdzam czy nie wyskocze poza ilosc wpisanych slow*/
	je _zamienNaHex					/*jezeli przeiterowalem wszystkie cyfry w wpisanym slowie tzn. ze sa same zera tzn. ze liczba zostala zamieniona*/
	movb ciag_wpisany(%ebx),%al		/*kopiuje wartosc aktualnej cyfry*/
	cmp $0,%eax						/*sprawdzam czy aktualna cyfra jest zerem*/
	jne _wykonajZamiane				/*jesli nie jest rowne tzn. ze nie zostala wykonana calkowita zamiana na binarny*/
	jmp _sprawdzCzySaZera			/*a jesli jest to sprawdzam czy dalej tez sa zera*/
	
_wykonajZamiane:	 
	mov $(-1),%edi					/*licznik dla liczby dziesietnej*/
	mov $0,%edx						/*rejestr z reszta poprzedniego dzielenia*/

_wykonajDzielenie:
	inc %edi						/*inkrementuje licznik*/
	cmp ciag_wpisany_len,%edi		/*sprawdzam czy nie wyskakuje poza obreb wpisanych danych*/
	je _zamianaNaBinarny			/*jesli rowne to skacze i wykonuje kolejna petle*/
	mov $10,%al						/*chce pomnozyc przez 10 zatem do rejestr %al przenosze 10*/
	movb %dl,%ah					/*aktulna reszte przenosze do rejestr %ah*/
	mul %ah							/*mnoze*/
	movb ciag_wpisany(%edi),%bl		/*sciagam cyfre*/
	add %bl,%al						/*dodaje aktulnie sciagnieta cyfre i poprzednia reszte pomnozona przez 10*/	
	mov $1,%edx						/*chce sie dowiedziec jaki jest ostatni bit aktualnej liczby*/
	and %eax,%edx					/*aby to zrobic wykonuje operacje and*/
	shr $1,%eax						/*dziele to przez 2*/
	movb %al,ciag_wpisany(%edi)		/*odsylam podzielona liczbe*/
	jmp _wykonajDzielenie
	
_zamienNaHex:
	mov $(-1),%eax					/*ustawiam licznik na %eax*/

_petlaZamianyNaHex:
	inc %eax						/*inkrementuje licznik*/
	cmp hex_len,%eax				/*sprawdzam czy nie wyskakuje poza*/
	je _zamienHexNaASCII			/*jesli wyskoczylem to zamieniam to co mam na znaki ASCII*/
	movb bufor(,%eax,4),%bl			/*w rejestrze %ebx przetrzymuje swoja aktualna liczbe a tutaj pobieram najstarzy bit*/
	shl $3,%ebx						/*jako ze to najstarszy bit to mnoze to razy 8*/
	mov $1,%edx
	movb bufor(%edx,%eax,4),%cl		/*pobieram mlodszy bit*/
	shl $2,%ecx						/*mnoze go razy 4*/
	add %ecx,%ebx					/*i dodaje do mojej liczby*/
	mov $2,%edx
	movb bufor(%edx,%eax,4),%cl		/*sciagam kolejny bit*/
	shl $1,%ecx						/*mnoze razy 2*/
	add %ecx,%ebx					/*dodaje*/
	mov $3,%edx
	movb bufor (%edx,%eax,4),%cl	/*sciagam najmlodszy bit*/
	add %ecx,%ebx					/*i dodaje*/
	movb %bl,hex(%eax)				/*i wysylam do bufora na liczby szesnastkowe*/
	jmp _petlaZamianyNaHex

_zamienHexNaASCII:
	mov $(-1),%eax					/*ustawiam licznik*/

_petlaZamianyHexNaASCII:
	inc %eax						/*inkrementuje licznik*/
	cmp hex_len,%eax				/*sprawdzam czy nie wyskakuje*/
	je _wypisz						/*jesli wyskakuje to wypisz */
	movb hex(%eax),%bl				/*sciagam aktulanie zamieniana liczbe*/
	cmp $10,%ebx					/*sprawdzam jak zapisac dana liczbe*/
	jb _jestCyfra					/*jesli jest mniejsza od 10 to znaczy ze jest cyfra*/
	sub $10,%ebx					/*jesli jest wieksza to odejmuje od niej 10*/
	add $0x41,%ebx					/*i dodaje kod ASCII litery A*/
	movb %bl,hex(%eax)				/*i wysylam z powrotem*/
	jmp _petlaZamianyHexNaASCII
	
_jestCyfra:		
	add $0x30,%ebx					/*skoro jest cyfra to dodaj do niej kod ASCII cyfry 0*/
	movb %bl,hex(%eax)				/*i wysylam z powrotem*/
	jmp _petlaZamianyHexNaASCII
			
_wypisz:
	mov $SYSWRITE, %eax 
	mov $STDOUT, %ebx 
	mov $hex, %ecx 
	mov $hex_len, %edx 
	
	int $0x80	

	mov $SYSEXIT, %eax 
	mov $EXIT_SUCCESS, %ebx
	
	int $0x80	

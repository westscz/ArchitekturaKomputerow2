/*funkcja zawiera dodawanie wraz z pętlą*/

/*void dodawanieZPetla(char* l1, char* l2, char* wynik)
{
	
}*/
/*funkcja zawiera samo dodawanie bez pętli
	pierwszy argument przekazany zostaje w rejestrze %rdi
	drugi argument przekazany zostaje w rejestrze %rsi
	trzeci argument przekazany zostaje w rejstrze %rdx*/
.align 32
.data
max_len: .word 1023
.text

.globl dodawanieZPetla
.type dodawanieZPetla,@function
dodawanieZPetla:
	mov max_len,%eax			/*licznik petli*/
	inc %eax	
	add max_len,%rdi			/*przechodze na koniec pierwszej liczby*/
	add max_len,%rsi			/*przechodze na koniec drugiej liczby*/
	add max_len,%rdx			/*przechodze na przedostatnia komorke wyniku*/
	inc %rdx					/*przechodze na ostatnia komorke wyniku*/
	mov $0,%rbx					/*czyszcze rejestry w ktorych bede przechowywal tymczasowe licbzy bo moga byc smieci*/	
	mov $0,%rcx
	mov $0,%r13					/*rejestr przetrzymujacy przeniesienie*/					
petlaDodawania:
	dec %rax					/*dekrementuje licznik*/
	cmp $(-1),%rax				/*sprawdzam czy jest zero*/
	je _koniec
	movb (%rdi),%bl				/*kopiuje aktualna cyfre do %rbx*/	
	dec %rdi					/*przesuwam sie w kierunku przodu pierwszej liczby*/
	movb (%rsi),%cl				/*kopiuje druga aktulna cyfre do %rcx */
	dec %rsi					/*przesuwam sie w kierunku przodu drugiej liczby*/
	add %rbx,%rcx				/*dodaje obie liczby*/
	add %r13,%rcx				/*dodaje ew przeniesienie z wyzszych pozycji*/
	mov $0,%r13					/*jezeli bylo przeniesienie to juz je uwzglednilem i usuwam*/
	cmp $10,%rcx				/*sprawdzam czy liczby nie jest wieksza od 10 bo wtedy musze ustawic przeniesienie*/
	jb zapis
	mov $1,%r13
	sub $10,%rcx
zapis:
	movb %cl,(%rdx)				/*zapisuje*/
	dec	%rdx
	jmp petlaDodawania
_koniec:
	movb %r13b,(%rdx)
	ret
	
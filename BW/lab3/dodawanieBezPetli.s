/*funkcja zawiera samo dodawanie bez pętli
	pierwszy argument przekazany zostaje w rejestrze %rdi
	drugi argument przekazany zostaje w rejestrze %rsi
	trzeci argument przekazany zostaje w rejstrze %rdx
	czwarty argument przekazany zostaje w rejestrze %r13*/

.text

.globl dodawanieBezPetli
.type dodawanieBezPetli,@function
dodawanieBezPetli:
		add %rdi,%rsi		/*dodaje dwie cyfry*/
		add %rdx,%rsi		/*dodaje przeniesienie*/
		cmp $9,%rsi			/*jesli wieksze od 9 to znaczy ze musze uwzglednic przeniesienie*/
		ja _przeniesienie
		mov %rsi,%rax
		movb %al,(%rcx)		/*do komórki wynikowej wysyłam wartość wyniku*/
		mov $0,%rax			/*do zwrócenia wysyłam 0 bo nie ma przeniesienia*/
		jmp _koniec
_przeniesienie:
		sub $10,%rsi		/*odejmuje 10*/
		mov %rsi,%rax
		movb %al,(%rcx)		/*reszte umieszczam w komórce wynikowej*/
		mov $1,%rax			/*przeniesienie umieszczam w zwracanym rejestrze*/
_koniec:     
        ret
		
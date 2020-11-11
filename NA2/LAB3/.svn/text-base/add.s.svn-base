.globl add
.type  add, @function

add:

clearCF: # ustawiam przeniesienie w r10 na 0
	mov $0, %r10b 

	cmp $0, %r8d # jesli dlugosci drugiego...
	je podrugim

	cmp $0, %ecx # jesli dlugosc pierwszego...
	je popierwszym

	add $-1, %r9d 
	add $-1, %r8d
	add $-1, %ecx

	jmp petla
	
setCF: # ustawiam przeniesienie w r10 na 0
	mov $1, %r10b 	
	cmp $0, %r8d # jesli dlugosc drugiego... 
	je podrugim

	cmp $0, %ecx # jesli dlugosc pierwszego...
	je popierwszym

	add $-1, %r9d
	add $-1, %r8d
	add $-1, %ecx 

petla: # petla dodawania wspolnej czesci 
	movb %r10b, %r11b 

    addb 0(%rsi,%r8,1), %r11b  # dodaje wartosc z drugiej tablicy 
	
	jc ustawiaj

	addb 0(%rdi,%rcx,1), %r11b # dodaje wartosc z pierwszej tablicy
	jmp poustawianiu

ustawiaj: # w pierwszym dodawaniu (linijka wyzej)
	addb 0(%rdi,%rcx,1), %r11b # dodaje wartosc z pierwszej tablicy
	stc

poustawianiu:

	mov %r11b, 0(%rdx,%r9,1) # zapisuje do tablicy wynikow

	jc setCF
	jnc clearCF

przeniesieniepopierwszym:
	mov $1, %r10b 
 
popierwszym: # pierwszy napis sie skonczyl. rozpatruje drugi
	cmp $0, %r8d # jesli dlugosc drugiego...
	je koniec
	add $-1, %r9d 
	add $-1, %r8d 
	movb %r10b, %r11b 
	
	addb 0(%rsi,%r8,1), %r11b # dodaje wartosc z drugiej tablicy
	mov %r11b, 0(%rdx,%r9,1) # zapisuje do tablicy wynikow
	
	mov $0, %r10b 
	jc przeniesieniepopierwszym
	jnc popierwszym

przeniesieniepodrugim:
	mov $1, %r10b 

podrugim: # drugi napis sie skonczyl. rozpatruje pierwszy
	cmp $0, %ecx # jesli dlugosc pierwszego...
	je koniec
	add $-1, %r9d 
 	add $-1, %ecx               
 	mov %r10b, %r11b                
 
 	addb 0(%rdi,%rcx,1), %r11b # dodaje wartosc z pierwszej tablicy          
 	mov %r11b, 0(%rdx,%r9,1) # zapisuje do tablicy wynikow

	mov $0, %r10b
	jc przeniesieniepodrugim
	jnc podrugim

koniec: # po dodaniu wszystkiego moze jeszcze wystapic przeniesienie
	cmp $1,%r10b 
	je przeniesienie
	jmp koniecKoncow

przeniesienie: # przeniesienie wynikajace z ostatniego dodawania
	add $-1, %r9d 
	mov %r10b, 0(%rdx,%r9,1) # zapisuje do tablicy wynikow

koniecKoncow:



	


     

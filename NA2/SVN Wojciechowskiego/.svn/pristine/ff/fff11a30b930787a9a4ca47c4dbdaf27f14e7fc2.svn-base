all:
	@echo "kompilacja"

clean:
	@echo "czyszczenie katalogu"

test: prog.py
	@./rzucacz.py input.txt | ./prog.py > wynik.txt
	@diff wynik.txt wynik.orig && echo "result correct" || echo "error: wrong result"

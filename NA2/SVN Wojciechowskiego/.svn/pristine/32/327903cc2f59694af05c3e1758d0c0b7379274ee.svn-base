all:
	@echo "kompilacja:"
	gcc -o lab4 lab4.c fpu_add.s get_fpu.s set_fpu.s ../lab3/rdtsc.c

test: lab4
	@echo "test:"
	./lab4

clean:
	@echo "czyszczenie katalogu:"
	rm lab4

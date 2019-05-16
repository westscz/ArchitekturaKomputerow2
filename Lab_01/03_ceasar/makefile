PROGRAM=ceasar
$(PROGRAM): $(PROGRAM).s
	as -g -o $(PROGRAM).o $(PROGRAM).s
	ld -o $(PROGRAM) $(PROGRAM).o
clean:
	rm *.o $(PROGRAM)

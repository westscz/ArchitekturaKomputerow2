PROGRAM=chars

$(PROGRAM): $(PROGRAM).s
	as -g -o $(PROGRAM).o $(PROGRAM).s
	ld -o $(PROGRAM) $(PROGRAM).o

run: $(PROGRAM)
	./$(PROGRAM)

clean:
	rm *.o $(PROGRAM)

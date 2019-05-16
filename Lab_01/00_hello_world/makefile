PROGRAM=hello_world

$(PROGRAM): $(PROGRAM).s
	as -g -o $(PROGRAM).o $(PROGRAM).s
	ld -o $(PROGRAM) $(PROGRAM).o

run:
	./$(PROGRAM)

clean:
	rm *.o $(PROGRAM)

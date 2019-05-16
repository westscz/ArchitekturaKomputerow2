PROGRAM=func

$(PROGRAM): $(PROGRAM).s
	as -g -o $(PROGRAM).o $(PROGRAM).s --32
	ld -o $(PROGRAM) $(PROGRAM).o -m elf_i386

clean:
	rm *.o $(PROGRAM)

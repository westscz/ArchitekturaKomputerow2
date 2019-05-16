PROGRAM=xor_func

$(PROGRAM): $(PROGRAM).s
	as -g -o $(PROGRAM).o $(PROGRAM).s --32
	ld -o $(PROGRAM) $(PROGRAM).o -m elf_i386
	rm $(PROGRAM).o

clean:
	rm $(PROGRAM)

debug: $(PROGRAM)
	gdb $(PROGRAM)
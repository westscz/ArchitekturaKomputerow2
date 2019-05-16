PROGRAM=calculator

build: $(PROGRAM).s
	as $(PROGRAM).s -o $(PROGRAM).o --32
	ld $(PROGRAM).o -o $(PROGRAM) -m elf_i386

#	as $(PROGRAM).s -o $(PROGRAM).o -g
#	gcc $(PROGRAM).s -o $(PROGRAM) -g -m32

run:
	./$(PROGRAM)

debug:
	gdb -x .gdb $(PROGRAM)

rebuild: clean build

clean:
	rm -f $(PROGRAM) $(PROGRAM).o

all: clean build run

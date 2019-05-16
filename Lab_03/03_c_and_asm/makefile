PROGRAM=main
EXTENSION=.c

build: $(PROGRAM)$(EXTENSION) 
#	as $(PROGRAM).s -o $(PROGRAM).o --32
#	ld $(PROGRAM).o -o $(PROGRAM) -m elf

#	as $(PROGRAM).s -o $(PROGRAM).o -g
#	gcc -Wall -c main.c -m32
#	gcc $(PROGRAM).s main.o -o $(PROGRAM) -g -m32

	gcc $(PROGRAM)$(EXTENSION) -o $(PROGRAM) -g -m32

run:
	./$(PROGRAM)

debug:
	gdb -x _gdb $(PROGRAM)

rebuild: clean build

clean:
	rm -f $(PROGRAM) $(PROGRAM).o

all: clean build run

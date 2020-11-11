PROGRAM=showimage

build: $(PROGRAM).c
#	as $(PROGRAM).s -o $(PROGRAM).o --32
#	ld $(PROGRAM).o -o $(PROGRAM) -m elf

#	as $(PROGRAM).s -o $(PROGRAM).o -g
	gcc -o $(PROGRAM) $(PROGRAM).c 'sdl2-config'  

run:
	./$(PROGRAM)

debug:
	gdb -x _gdb $(PROGRAM)

rebuild: clean build

clean:
	rm -f $(PROGRAM) $(PROGRAM).o

all: clean build run

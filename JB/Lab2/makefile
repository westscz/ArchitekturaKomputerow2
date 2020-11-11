PROGRAM=calc

build: $(PROGRAM).s
#	as $(PROGRAM).s -o $(PROGRAM).o
#	ld $(PROGRAM).o -o $(PROGRAM)
	gcc $(PROGRAM).s -o $(PROGRAM) -g -m32

run:
	./$(PROGRAM)

debug:
	gdb -x _gdb $(PROGRAM)

rebuild: clean build

clean:
	rm -f $(PROGRAM) $(PROGRAM).o

all: clean build run

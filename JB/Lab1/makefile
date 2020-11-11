PROGRAM=cezar

build: $(PROGRAM).s
#	as $(PROGRAM).s -o $(PROGRAM).o
#	ld $(PROGRAM).o -o $(PROGRAM)
	gcc $(PROGRAM).s -o $(PROGRAM) -g

run:
	./$(PROGRAM)

debug:
	gdb -x _gdb $(PROGRAM)

rebuild: clean build

clean:
	rm -f $(PROGRAM) $(PROGRAM).o

all: clean build run

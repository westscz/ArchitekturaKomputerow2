PROGRAM=$(patsubst %.s,%,$(wildcard *.s))
CFLAGS=-g -m32	#x86
COMPILATOR=gcc
DEBUGER=gdb

build: $(PROGRAM).s
	$(COMPILATOR) $< -o $(PROGRAM) $(CFLAGS)

run:
	./$(PROGRAM)

debug:
	$(DEBUGER) -x .$(DEBUGER) $(PROGRAM)

rebuild: clean build

clean:
	rm -f $(PROGRAM) $(PROGRAM).o *~

all: clean build run



# OLD BUILD INSTRUCTIONS
#	as $(PROGRAM).s -o $(PROGRAM).o --32
#	ld $(PROGRAM).o -o $(PROGRAM) -m elf
# GCC
#	as $(PROGRAM).s -o $(PROGRAM).o -g
# %:%s   ->  $@=%   $<=%.s

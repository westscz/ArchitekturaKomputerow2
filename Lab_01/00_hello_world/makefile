PROGRAM=hello_world

.PHONY: hello_world run clean

$(PROGRAM): $(PROGRAM).s
	as -g -o $(PROGRAM).o $(PROGRAM).s
	ld -o $(PROGRAM) $(PROGRAM).o

run: $(PROGRAM)
	./$(PROGRAM)

clean:
	rm *.o $(PROGRAM)

fmt: $(PROGRAM).s
	go run ~/go/src/github.com/klauspost/asmfmt/cmd/asmfmt/main.go -w $(PROGRAM).s #https://github.com/klauspost/asmfmt
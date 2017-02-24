make: cpuid.s
	as -g -o cpuid.o cpuid.s --32
	ld -o cpuid cpuid.o -m elf_i386

rdtsc: rdtsc.s
	as -g -o rdtsc.o rdtsc.s --32
	ld -o rdtsc rdtsc.o -m elf_i386

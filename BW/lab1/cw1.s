.align 32
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0


.text
msg_hello: .ascii "Hello, world!\n"
msg_hello_len = . - msg_hello

.global _start # wskazanie punktu wejścia do programu

_start:
	mov $SYSWRITE, %eax # funkcja do wywołania - SYSWRITE
	mov $STDOUT, %ebx # 1 arg. - syst. deskryptor stdout
	mov $msg_hello, %ecx # 2 arg. - adres początkowy napisu
	mov $msg_hello_len, %edx # 3 arg. - długość łańcucha
	int $0x80 # wywołanie przerwania programowego -

	mov $SYSEXIT, %eax # funkcja do wywołania - SYSEXIT
	mov $EXIT_SUCCESS, %ebx
	int $0x80	
	



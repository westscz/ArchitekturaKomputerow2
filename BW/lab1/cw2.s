.align 32
SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
STDIN=1
EXIT_SUCCESS = 0

.data
	msg_hello: .ascii ""
	.comm msg_hello_len,10
.text

.global _start # wskazanie punktu wejścia do programu

_start:
	mov $SYSREAD, %eax 
	mov $0, %ebx 
	mov $msg_hello, %ecx 
	mov $msg_hello_len, %edx 
	
	int $0x80 
	
	mov $SYSWRITE, %eax 
	mov $STDOUT, %ebx 
	mov $msg_hello, %ecx 
	mov $msg_hello_len, %edx 
	
	int $0x80	

	mov $SYSEXIT, %eax 
	mov $EXIT_SUCCESS, %ebx
	
	int $0x80	

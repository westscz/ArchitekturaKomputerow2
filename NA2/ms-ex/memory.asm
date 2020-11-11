

;
; file: memory.asm
; This program illustrates how to use the string instructions

global _asm_copy, _asm_find, _asm_strlen, _asm_strcpy

segment .text
; function _asm_copy
; copies blocks of memory
; C prototype
; void asm_copy( void * dest, const void * src, unsigned sz);
; parameters:
;   dest - pointer to buffer to copy to
;   src  - pointer to buffer to copy from
;   sz   - number of bytes to copy

; next, some helpful symbols are defined

%define dest [ebp+8]
%define src  [ebp+12]
%define sz   [ebp+16]
_asm_copy:
        enter   0, 0
        push    esi
        push    edi

        mov     esi, src         ; esi = address of buffer to copy from
        mov     edi, dest        ; edi = address of buffer to copy to
        mov     ecx, sz          ; ecx = number of bytes to copy

        cld                     ; clear direction flag 
        rep     movsb           ; execute movsb ECX times

        pop     edi
        pop     esi
        leave
        ret


; function _asm_find
; searches memory for a given byte
; void * asm_find( const void * src, char target, unsigned sz);
; parameters:
;   src    - pointer to buffer to search
;   target - byte value to search for
;   sz     - number of bytes in buffer
; return value:
;   if target is found, pointer to first occurrence of target in buffer
;   is returned
;   else
;     NULL is returned
; NOTE: target is a byte value, but is pushed on stack as a dword value.
;       The byte value is stored in the lower 8-bits.
; 
%define src    [ebp+8]
%define target [ebp+12]
%define sz     [ebp+16]

_asm_find:
        enter   0,0
        push    edi

        mov     eax, target      ; al has value to search for
        mov     edi, src
        mov     ecx, sz
        cld

        repne   scasb           ; scan until ECX == 0 or [ES:EDI] == AL

        je      found_it        ; if zero flag set, then found value
        mov     eax, 0          ; if not found, return NULL pointer
        jmp     short quit
found_it:
        mov     eax, edi          
        dec     eax              ; if found return (DI - 1)
quit:
        pop     edi
        leave
        ret


; function _asm_strlen
; returns the size of a string
; unsigned asm_strlen( const char * );
; parameter:
;   src - pointer to string
; return value:
;   number of chars in string (not counting, ending 0) (in EAX)

%define src [ebp + 8]
_asm_strlen:
        enter   0,0
        push    edi

        mov     edi, src        ; edi = pointer to string
        mov     ecx, 0FFFFFFFFh ; use largest possible ECX
        xor     al,al           ; al = 0
        cld

        repnz   scasb           ; scan for terminating 0

;
; repnz will go one step too far, so length is FFFFFFFE - ECX,
; not FFFFFFFF - ECX
;
        mov     eax,0FFFFFFFEh
        sub     eax, ecx          ; length = 0FFFFFFFEh - ecx

        pop     edi
        leave
        ret

; function _asm_strcpy
; copies a string
; void asm_strcpy( char * dest, const char * src);
; parameters:
;   dest - pointer to string to copy to
;   src  - pointer to string to copy from
; 
%define dest [ebp + 8]
%define src  [ebp + 12]
_asm_strcpy:
        enter   0,0
        push    esi
        push    edi

        mov     edi, dest
        mov     esi, src
        cld
cpy_loop:
        lodsb                   ; load AL & inc si
        stosb                   ; store AL & inc di
        or      al, al          ; set condition flags
        jnz     cpy_loop        ; if not past terminating 0, continue

        pop     edi
        pop     esi
        leave
        ret




BITS 64

section .data
    welscr db " ---  Welcome to MRETURN 1.0  --- ", 0x0A, 0x0A
    scrlen equ $-welscr

    prompt db 'please type in a operation $ ' ;you dont need comments for this, but it would still be cool
    promptlen equ $-prompt ;i have no idea how this works but it does
    
    clsseq db 27, '[2J', 27, '[3J', 27, '[H'
    clslen equ $-clsseq
    
    scream db 'AHHHHHHHH', 0x0
    sceamlen equ $-scream
    
section .bss
    BUFFER resq 8 ;THE CHINESE ARE HERE



section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, welscr
    mov rdx, scrlen
    syscall
    xor rax, rax
    xor rdi, rdi
    xor r8, r8


.mainloop:
    mov rax, 1 ;initilize sys_write
    mov rdi, 1 ;stdout
    mov rsi, prompt ;gets the prompt (please enter in a operation $)
    mov rdx, promptlen ;the length of the prompt
    syscall

    xor rax, rax ;sys_read
    xor rdi, rdi ;stdout
    mov rsi, BUFFER ;gets input var from .bss
    mov rdx, 64 ;gets the bytes
    syscall ;syscall yknow
    
    mov eax, [BUFFER] ;now i forgot to add a comment to this,
    cmp eax, 'exit' ;but the first one moves the value to users input to eax (32 bits of rax) and this will check if eax is equal to exit
    je _exit       ; now if eax IS equal to the exit command it will start the exit procedure i dont know how to spell proc she jure

    ; --- Check for "clear" ---
    mov eax, [BUFFER]            ;same thing
    cmp eax, 'clea'              ;evil buffer buffer waffle
    cmp byte  [BUFFER + 4], 'r'  ;now we cant exactly just check buffer, buffer is clea and it checks if buffer + 'r' (r is a string btw is equal to clear because of 'r')
    je _clear                    ; if it matches jump to the _clear procedure
    
    mov eax, [BUFFER]               ;same thing you know what it is!
    cmp eax, 'scre'                 ;say it with me..
    cmp word [BUFFER + 4], 'am'    ;i dont know
    je _scream                      ; im copy and pasting the clear command and changing it up
    
    
    mov eax, [BUFFER]               ;same thing you know what it is!
    cmp eax, 'echo'
    je _echo                        ; im copy and pasting the clear command and changing it up

.other_part:



    cmp r8, 1
    je _exit
    jne .mainloop


_echo:
    call _exit

_scream:
    mov rax, 1
    mov rdi, 1
    mov rsi, scream
    mov rdx, sceamlen
    syscall
    jmp _scream

_clear:
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; stdout
    mov rsi, clsseq                 ; bytes to print
    mov rdx, clslen                 ; length (7)
    syscall

    jmp _start.mainloop

_proc:
    jmp _exit
_exit:
    mov rax, 60
    xor rdi, rdi
    syscall
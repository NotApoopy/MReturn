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
    
    pecho db "/bin/echo"
    pecholen equ $-pecho
section .bss
    BUFFER resq 8 ;THE CHINESE ARE HERE



section .text
    global _start

_start:
    call startsetup
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
    shl rax, 16                  ;required genocide
    shr rax, 16                  ;i hate that i dont understand what these do  
    mov rbx, 'clear'
    cmp rax, rbx                 ;evil buffer buffer waffle
    je _clear                    ; if it matches jump to the _clear procedure

    mov rax, [BUFFER]               ;same thing you know what it is!
    shl rax, 16                     ;required genocide
    shr rax, 16 
    mov rbx, 'scream'
    cmp rax, rbx                    ;say it with me..
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

_startsetup
    mov rax, 1                      ; sys_write
    mov rdi, 1                      ; stdout
    mov rsi, clsseq                 ; bytes to print
    mov rdx, clslen                 ; length (7)
    syscall
    mov rax, 1
    mov rdi, 1
    mov rsi, welscr
    mov rdx, scrlen
    syscall
    ret ;what the hail bro vscode.dev got no drip :( no syntax highlighting either i aint setin that up
org     0x7c00
bits    16

start:
    xor ax, ax                  ; setup segments (by setting them all to zero)
    mov ds, ax
    mov es, ax

                                ; setup stack
    cli                         ; disable interrupts (to be safe while seting stack segment and pointer)
    mov ss, ax
    mov sp, 0x7c00              ; stack starts at 0x7c00 and points downwards - see memory map (x86), we still have space there
    sti                         ; enable interrupts

    jmp 0:skip                  ; use a far jump to set cs to zero
skip:
    call clearScreen

    mov ah, 0x13                ; write string
    mov al, 1                   ; mode: update cursor
    push ax
    xor ax, ax                  ; zero register
    mov es, ax                  ; zero segment
    pop ax
    xor bh, bh                  ; video page number zero
    mov bl, 0xa                 ; attribute: foregroung color - white
    mov bp, welcomeString       ; string location
    mov cx, [welcomeStringLength] ; length of the string
    mov dh, 0                   ; y pos
    mov dl, 0                   ; x pos

    int 0x10

    cli
hang:
    hlt
    jmp hang

clearScreen:
    push ax

    ; clear screen (by setting the video mode): http://www.ctyme.com/intr/rb-0069.htm
    xor ax, ax                  ; ah=0
    mov al, 0x03                ; al=0x03, 80x25
    int 0x10

    pop ax
    ret

welcomeString:
    db "Welcome from ziny bootloader!", 0
welcomeStringLength:
    dw $-welcomeString

times 510 - ($-$$) db 0         ; zero out the rest of boot sector

dw 0xaa55                       ; boot signature

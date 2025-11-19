org 0x0100

start:
    ; Set ES to video memory
    mov ax,0xB800
    mov es,ax

    ; --- Clear the screen ---
    xor di,di
    mov cx,2000           ; 80*25 cells
    mov ax,0x0720         ; space + white-on-black
clear_screen:
    mov [es:di], ax
    add di, 2
    loop clear_screen

    ; --- Triangle parameters ---
    mov bl,[n]            ; height of triangle
    xor si,si             ; row_index = 0

row_loop:
    cmp si,bx
    je done

    ; stars = n - row_index
    mov cx,bx
    sub cx,si

    ; spaces = 0
    xor dx,dx

    ; row_offset = row_index*160
    mov ax,si
    mov di,ax
    shl di,7              ; si*128
    mov ax,si
    shl ax,5              ; si*32
    add di,ax             ; di = si*160

    ; --- Print stars ---
    mov ax,0x0F2A         ; '*' bright white
    mov dx,cx
star_loop:
    cmp dx,0
    je next_row
    mov [es:di],ax
    add di,2
    dec dx
    jmp star_loop

next_row:
    inc si
    jmp row_loop

done:
    mov ax,0x4C00
    int 0x21

n: db 5                   ; triangle height

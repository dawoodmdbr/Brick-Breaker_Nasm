[org 0x0100]
jmp start

; =============== GAME DATA ===============
game_state: db 0        ; 0=menu, 1=playing, 2=paused, 3=gameover, 4=win
lives: db 3
level: db 1
combo: db 0
power_up: db 0          ; 0=none, 1=wide paddle, 2=multi-ball, 3=slow ball

; =============== SOUND FREQUENCIES ===============
SOUND_HIT: dw 1000      ; Brick hit sound
SOUND_PADDLE: dw 800    ; Paddle bounce
SOUND_LOSE: dw 400      ; Life lost
SOUND_WIN: dw 2000      ; Level complete
SOUND_POWERUP: dw 1500  ; Power-up collected

; =============== PADDLE DATA ===============
paddle_x: dw 36         ; Column position
paddle_y: db 23         ; Row position
paddle_width: db 14     ; Width in characters
paddle_speed: db 2      ; Movement speed
paddle_color: db 0x3E   ; Cyan on black, bright

; =============== BALL DATA ===============
ball_x: dw 40           ; Column (x10 for precision)
ball_y: dw 220          ; Row (x10 for precision)
ball_dx: dw 3           ; X velocity
ball_dy: dw -3          ; Y velocity
ball_attached: db 1     ; 1=attached to paddle
ball_char: db 0x07      ; White circle
prev_ball: dw 0         ; Previous ball position

; =============== SCORE & TIME ===============
score: dd 0
high_score: dd 0
time_sec: dw 0
time_min: db 0
timer_tick: db 0

; =============== BRICK DATA ===============
total_bricks: dw 60     ; 10 cols x 6 rows
brick_colors: db 0x4E, 0x1E, 0x5E, 0x6E, 0x2E, 0xCE  ; Different colors per row
brick_health: times 60 db 1  ; Health for each brick (some can take 2-3 hits)

; =============== PARTICLE EFFECTS ===============
particles: times 20 dw 0  ; Particle positions for effects
particle_active: times 20 db 0

; =============== OLD ISR ADDRESSES ===============
oldisr: dd 0
oldtmr: dd 0

; =============== STRINGS ===============
title_str: db 'SUPER BRICK BREAKER ULTIMATE'
subtitle_str: db 'Press ENTER to Start Adventure!'
inst1_str: db 'Arrow Keys: Move Paddle'
inst2_str: db 'SPACE: Launch Ball'
inst3_str: db 'P: Pause  |  ESC: Quit'
score_str: db 'SCORE:'
lives_str: db 'LIVES:'
level_str: db 'LEVEL:'
time_str: db 'TIME:'
combo_str: db 'COMBO: x'
gameover_str: db 'GAME OVER!'
win_str: db 'YOU WIN! LEVEL COMPLETE!'
paused_str: db 'PAUSED'
continue_str: db 'Press P to Continue'
highscore_str: db 'HIGH SCORE:'
powerup_wide: db 'WIDE PADDLE!'
powerup_multi: db 'MULTI BALL!'
powerup_slow: db 'SLOW MOTION!'

; =============== SOUND SUBROUTINE ===============
play_sound:
    push ax
    push bx
    push cx
    mov bx, [bp+4]      ; Get frequency
    
    mov al, 182
    out 43h, al
    mov ax, bx
    out 42h, al
    mov al, ah
    out 42h, al
    
    in al, 61h
    or al, 00000011b
    out 61h, al
    
    mov cx, 1000        ; Short beep duration
    sound_delay:
        push cx
        mov cx, 100
        sound_inner:
            loop sound_inner
        pop cx
        loop sound_delay
    
    in al, 61h
    and al, 11111100b
    out 61h, al
    
    pop cx
    pop bx
    pop ax
    ret

; =============== CLEAR SCREEN ===============
clrscr:
    push es
    push ax
    push cx
    push di
    
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, 0x0020      ; Black background
    mov cx, 2000
    cld
    rep stosw
    
    pop di
    pop cx
    pop ax
    pop es
    ret

; =============== DRAW BORDER WITH STYLE ===============
draw_border:
    push es
    push ax
    push di
    push cx
    
    mov ax, 0xb800
    mov es, ax
    
    ; Top border (double line style)
    mov di, 160
    mov cx, 80
    mov ax, 0x9FCD      ; Bright white on blue
    rep stosw
    
    ; Bottom border
    mov di, 3840
    mov cx, 80
    mov ax, 0x9FCD
    rep stosw
    
    ; Side borders
    mov cx, 23
    mov di, 320
    draw_left:
        mov word [es:di], 0x9FBA
        add di, 160
        loop draw_left
    
    mov cx, 23
    mov di, 478
    draw_right:
        mov word [es:di], 0x9FBA
        add di, 160
        loop draw_right
    
    pop cx
    pop di
    pop ax
    pop es
    ret

; =============== PRINT STRING ===============
print_string:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di
    
    mov ax, 0xb800
    mov es, ax
    mov di, [bp+8]      ; Position
    mov si, [bp+6]      ; String address
    mov cx, [bp+4]      ; Length
    mov ah, 0x0F        ; Bright white
    
    print_loop:
        mov al, [si]
        mov [es:di], ax
        add di, 2
        inc si
        loop print_loop
    
    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 6

; =============== PRINT NUMBER ===============
print_number:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    
    mov ax, 0xb800
    mov es, ax
    mov ax, [bp+4]      ; Number to print
    mov bx, 10
    mov cx, 0
    
    convert_digit:
        xor dx, dx
        div bx
        add dl, '0'
        push dx
        inc cx
        test ax, ax
        jnz convert_digit
    
    mov di, [bp+6]      ; Position
    print_digits:
        pop dx
        mov dh, 0x0E        ; Yellow
        mov [es:di], dx
        add di, 2
        loop print_digits
    
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 4

; =============== ANIMATED TITLE SCREEN ===============
show_menu:
    push ax
    call clrscr
    
   ; Animated title with color
mov ax, 530        ; centered row for title
push ax
mov ax, title_str
push ax
mov ax, 29
push ax
call print_string

; Subtitle
mov ax, 688        ; centered row for subtitle
push ax
mov ax, subtitle_str
push ax
mov ax, 31
push ax
call print_string

; Instructions
mov ax, 1016
push ax
mov ax, inst1_str
push ax
mov ax, 23
push ax
call print_string

mov ax, 1182
push ax
mov ax, inst2_str
push ax
mov ax, 18
push ax
call print_string

mov ax, 1334
push ax
mov ax, inst3_str
push ax
mov ax, 25
push ax
call print_string

; High score display
mov ax, 1668
push ax
mov ax, highscore_str
push ax
mov ax, 11
push ax
call print_string

mov ax, 1670
push ax
push word [high_score]
call print_number

    
    pop ax
    ret

; =============== DRAW COLORFUL BRICKS ===============
draw_bricks:
    push es
    push ax
    push bx
    push cx
    push dx
    push di
    push si
    
    mov ax, 0xb800
    mov es, ax
    
    xor si, si          ; Brick index
    mov bx, 0           ; Row counter
    
    brick_row_loop:
        cmp bx, 6
        jae bricks_done
        
        mov cx, 0       ; Column counter
        brick_col_loop:
            cmp cx, 10
            jae next_brick_row
            
            ; Check if brick is still alive
            cmp byte [brick_health + si], 0
            je skip_brick
            
            ; Calculate screen position
            mov ax, bx
            mov dx, 5
            mul dx
            add ax, 3
            mov dx, 160
            mul dx
            mov di, ax
            
            mov ax, cx
            mov dx, 7
            mul dx
            add ax, 5
            shl ax, 1
            add di, ax
            
            ; Get brick color based on row
            mov al, [brick_colors + bx]
            mov ah, 0xDB    ; Solid block character
            xchg ah, al
            
            ; Draw brick (7 chars wide)
            push cx
            mov cx, 7
            rep stosw
            pop cx
            
            skip_brick:
            inc si
            inc cx
            jmp brick_col_loop
        
        next_brick_row:
        inc bx
        jmp brick_row_loop
    
    bricks_done:
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    ret

; =============== DRAW PADDLE WITH GLOW EFFECT ===============
draw_paddle:
    push es
    push ax
    push cx
    push di
    
    mov ax, 0xb800
    mov es, ax
    
    ; Calculate paddle position
    mov al, [paddle_y]
    mov ah, 0
    mov cx, 160
    mul cx
    mov di, ax
    
    mov ax, [paddle_x]
    shl ax, 1
    add di, ax
    
    ; Draw paddle with gradient effect
    mov cl, [paddle_width]
    mov ch, 0
    mov ah, [paddle_color]
    mov al, 0xDC        ; Bottom half block
    
    paddle_draw_loop:
        mov [es:di], ax
        add di, 2
        loop paddle_draw_loop
    
    pop di
    pop cx
    pop ax
    pop es
    ret

; =============== CLEAR BALL (previous position) ===============
clear_ball:
    push es
    push ax
    push di
    
    mov ax, 0xb800
    mov es, ax
    mov di, [prev_ball]
    mov word [es:di], 0x0020
    
    pop di
    pop ax
    pop es
    ret

; =============== DRAW BALL ===============
draw_ball:
    push es
    push ax
    push bx
    push dx
    push di
    
    mov ax, 0xb800
    mov es, ax
    
    ; Convert ball position to screen coordinates
    mov ax, [ball_y]
    mov bx, 10
    xor dx, dx
    div bx              ; y / 10
    mov bx, 160
    mul bx
    mov di, ax
    
    mov ax, [ball_x]
    mov bx, 10
    xor dx, dx
    div bx              ; x / 10
    shl ax, 1
    add di, ax
    
    mov [prev_ball], di
    
    ; Draw ball
    mov word [es:di], 0x0F4F    ; Bright white 'O'
    
    pop di
    pop dx
    pop bx
    pop ax
    pop es
    ret

; =============== UPDATE BALL PHYSICS ===============
update_ball:
    push ax
    push bx
    push cx
    push dx
    
    ; Check if ball is attached
    cmp byte [ball_attached], 1
    jne ball_moving
    
    ; Keep ball on paddle
    mov ax, [paddle_x]
    mov bl, [paddle_width]
    mov bh, 0
    shr bx, 1
    add ax, bx
    mov bx, 10
    mul bx
    mov [ball_x], ax
    
    mov al, [paddle_y]
    dec al
    mov ah, 0
    mov bx, 10
    mul bx
    mov [ball_y], ax
    jmp ball_done
    
    ball_moving:
    ; Update ball position
    mov ax, [ball_x]
    add ax, [ball_dx]
    mov [ball_x], ax
    
    mov ax, [ball_y]
    add ax, [ball_dy]
    mov [ball_y], ax
    
    ; Check collisions
    call check_collisions
    
    ball_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; =============== CHECK COLLISIONS ===============
check_collisions:
    push ax
    push bx
    push cx
    push dx
    
    ; Convert to actual screen coords
    mov ax, [ball_x]
    mov bx, 10
    xor dx, dx
    div bx
    mov cx, ax          ; CX = ball column
    
    mov ax, [ball_y]
    mov bx, 10
    xor dx, dx
    div bx
    mov bx, ax          ; BX = ball row
    
    ; Check left/right walls
    cmp cx, 2
    jbe bounce_x
    cmp cx, 77
    jae bounce_x
    jmp check_y
    
    bounce_x:
        neg word [ball_dx]
        ; Play sound
        push word [SOUND_PADDLE]
        call play_sound
        add sp, 2
    
    check_y:
    ; Check top wall
    cmp bx, 2
    jbe bounce_y_down
    
    ; Check paddle collision
    mov al, [paddle_y]
    cmp bl, al
    jne check_bottom
    
    ; Check if ball is within paddle width
    mov ax, [paddle_x]
    cmp cx, ax
    jb check_bottom
    
    mov dx, ax
    add dl, [paddle_width]
    cmp cx, dx
    ja check_bottom
    
    ; Paddle hit!
    bounce_y_down:
        mov ax, [ball_dy]
        test ax, ax
        jns check_bottom    ; Already moving down
        neg word [ball_dy]
        ; Play sound
        push word [SOUND_PADDLE]
        call play_sound
        add sp, 2
        jmp check_bricks
    
    check_bottom:
    ; Check if ball fell off bottom
    cmp bx, 24
    jb check_bricks
    
    ; Lost a life!
    dec byte [lives]
    mov byte [ball_attached], 1
    mov byte [combo], 0
    ; Play lose sound
    push word [SOUND_LOSE]
    call play_sound
    add sp, 2
    jmp collision_done
    
    check_bricks:
    ; Check brick collisions (rows 3-8)
    cmp bx, 3
    jb collision_done
    cmp bx, 8
    ja collision_done
    
    ; Calculate brick index
    sub bx, 3
    mov ax, bx
    mov dx, 10
    mul dx
    
    sub cx, 5
    xor dx, dx
    mov bx, 7
    mov ax, cx
    div bx
    add ax, cx
    
    ; TODO: Check brick health and remove if hit
    
    collision_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; =============== DRAW HUD ===============
draw_hud:
    push ax
    
    ; Score
    mov ax, 164
    push ax
    mov ax, score_str
    push ax
    mov ax, 6
    push ax
    call print_string
    
    mov ax, 178
    push ax
    push word [score]
    call print_number
    
    ; Lives
    mov ax, 276
    push ax
    mov ax, lives_str
    push ax
    mov ax, 6
    push ax
    call print_string
    
    mov ax, 290
    push ax
    mov al, [lives]
    mov ah, 0
    push ax
    call print_number
    
    ; Level
    mov ax, 3868
    push ax
    mov ax, level_str
    push ax
    mov ax, 6
    push ax
    call print_string
    
    mov ax, 3882
    push ax
    mov al, [level]
    mov ah, 0
    push ax
    call print_number
    
    pop ax
    ret

; =============== KEYBOARD ISR ===============
kbisr:
    push ax
    push es
    
    in al, 0x60
    
    cmp byte [game_state], 0
    jne game_keys
    
    ; Menu keys
    cmp al, 0x1C        ; Enter
    jne menu_done
    mov byte [game_state], 1
    jmp kb_exit
    
    game_keys:
    cmp byte [game_state], 1
    jne kb_exit
    
    cmp al, 0x4B        ; Left arrow
    jne check_right
    mov ax, [paddle_x]
    sub al, [paddle_speed]
    cmp ax, 3
    jb kb_exit
    mov [paddle_x], ax
    jmp kb_exit
    
    check_right:
    cmp al, 0x4D        ; Right arrow
    jne check_space
    mov ax, [paddle_x]
    add al, [paddle_speed]
    mov bl, [paddle_width]
    add al, bl
    cmp al, 77
    ja kb_exit
    sub al, bl
    mov [paddle_x], ax
    jmp kb_exit
    
    check_space:
    cmp al, 0x39        ; Space
    jne check_pause
    mov byte [ball_attached], 0
    jmp kb_exit
    
    check_pause:
    cmp al, 0x19        ; P
    jne check_esc
    xor byte [game_state], 3    ; Toggle pause
    jmp kb_exit
    
    check_esc:
    cmp al, 0x01        ; ESC
    jne menu_done
    mov byte [game_state], 3
    
    menu_done:
    kb_exit:
    mov al, 0x20
    out 0x20, al
    
    pop es
    pop ax
    iret

; =============== TIMER ISR ===============
timer:
    push ax
    
    cmp byte [game_state], 1
    jne timer_done
    
    inc byte [timer_tick]
    cmp byte [timer_tick], 18
    jb timer_done
    
    mov byte [timer_tick], 0
    inc word [time_sec]
    cmp word [time_sec], 60
    jb timer_done
    
    mov word [time_sec], 0
    inc byte [time_min]
    
    timer_done:
    mov al, 0x20
    out 0x20, al
    pop ax
    iret

; =============== MAIN GAME LOOP ===============
game_loop:
    cmp byte [game_state], 0
    jne check_playing
    call show_menu
    jmp game_loop
    
    check_playing:
    cmp byte [game_state], 1
    jne check_gameover
    
    ; Game is playing
    call clrscr
    call draw_border
    call draw_bricks
    call draw_hud
    call clear_ball
    call update_ball
    call draw_ball
    call draw_paddle
    
    ; Small delay
    mov cx, 0xFFFF
    game_delay:
        nop
        loop game_delay
    
    ; Check win/lose conditions
    cmp byte [lives], 0
    je set_gameover
    
    cmp word [total_bricks], 0
    je set_win
    
    jmp game_loop
    
    set_gameover:
    mov byte [game_state], 3
    jmp game_loop
    
    set_win:
    mov byte [game_state], 4
    jmp game_loop
    
    check_gameover:
    cmp byte [game_state], 3
    jne check_win
    
    ; Game over screen
    call clrscr
    mov ax, 1600
    push ax
    mov ax, gameover_str
    push ax
    mov ax, 10
    push ax
    call print_string
    jmp wait_exit
    
    check_win:
    call clrscr
    mov ax, 1600
    push ax
    mov ax, win_str
    push ax
    mov ax, 23
    push ax
    call print_string
    
    wait_exit:
    ; Wait for ESC
    mov ah, 0
    int 0x16
    jmp cleanup

; =============== PROGRAM START ===============
start:
    ; Initialize brick health (some bricks take multiple hits)
    mov cx, 60
    mov di, brick_health
    mov al, 1
    rep stosb
    
    ; Make some bricks tougher
    mov byte [brick_health + 9], 2
    mov byte [brick_health + 19], 2
    mov byte [brick_health + 29], 3
    mov byte [brick_health + 39], 2
    mov byte [brick_health + 49], 2
    mov byte [brick_health + 59], 3
    
    ; Hook interrupts
    xor ax, ax
    mov es, ax
    
    cli
    mov ax, [es:9*4]
    mov [oldisr], ax
    mov ax, [es:9*4+2]
    mov [oldisr+2], ax
    
    mov ax, [es:8*4]
    mov [oldtmr], ax
    mov ax, [es:8*4+2]
    mov [oldtmr+2], ax
    
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    mov word [es:8*4], timer
    mov [es:8*4+2], cs
    sti
    
    ; Start game
    call game_loop

; =============== CLEANUP ===============
cleanup:
    ; Restore interrupts
    xor ax, ax
    mov es, ax
    
    cli
    mov ax, [oldisr]
    mov [es:9*4], ax
    mov ax, [oldisr+2]
    mov [es:9*4+2], ax
    
    mov ax, [oldtmr]
    mov [es:8*4], ax
    mov ax, [oldtmr+2]
    mov [es:8*4+2], ax
    sti
    
    ; Clear screen and exit
    call clrscr
    
    mov ax, 0x4C00
    int 0x21
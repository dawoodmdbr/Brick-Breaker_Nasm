[org 0x0100]
jmp start

start_game: db 0

inst: db 'PRESS I TO GO INTO INSTRUCTION BOX'
oldisr: dd 0

colume: dw 0
row: dw 0
incC: db 1    ; -1 = left, 0 = none, 1 = right
incR: db 1    ; -1 = up, 1 = down
ball_angle: db 0  ; 0 = 90° (vertical), 1 = 45° diagonal
previous: dw 0
tickcount: db 0
left_edge: dw 3518
right_edge dw 3658
right_: dw 0
left_: dw 0
pre_stack_pos: dw 3588

second: dw 0
minute: db 0
clock: db 0
bonus: dw 0

; bricks_start_location: dw 810 , 828 , 846 , 864 , 882 , 900 , 918 , 936 , 1130 , 1148 , 1166 , 1184 , 1202, 1220, 1238 , 1256, 1450, 1468, 1486, 1504, 1522, 1540, 1558, 1576 , 1770 , 1788 , 1806 , 1824 , 1842 , 1860 , 1878 , 1896
; bricks_end_location: dw 822 , 840 , 858 , 876 , 894 , 912 , 930 , 948 , 1142 , 1160 , 1178 , 1196 , 1214 , 1232 , 1250 , 1268 , 1462, 1480, 1498, 1516, 1534, 1552, 1570, 1588 , 1782 , 1800  , 1818 , 1836 ,1854 , 1872 , 1890 , 1908
bricks_start_location:
    dw 810, 828, 846, 864, 882, 900, 918, 936          ; Row 1 (starts at 810)
    dw 1290, 1308, 1326, 1344, 1362, 1380, 1398, 1416  ; Row 2 (starts at 1290)
    dw 1770, 1788, 1806, 1824, 1842, 1860, 1878, 1896  ; Row 3 (starts at 1770)

bricks_end_location:
    dw 822, 840, 858, 876, 894, 912, 930, 948          ; Row 1
    dw 1302, 1320, 1338, 1356, 1374, 1392, 1410, 1428  ; Row 2
    dw 1782, 1800, 1818, 1836, 1854, 1872, 1890, 1908  ; Row 3







score: dw 0
total_bricks: dw 32
calculated_location:  dw 0
left_limit dw 0
right_limit dw 0
mid dw 0
left_or_right: db 0
preBall:dw 0

live: db 3
end_of_game: dw 0
StayOnStacker: db 0

counter: dw 0
solid: db 0
solid1: db 0



; welcome_str: db 'WELCOME TO BRICK BREAKER'
; option_str: db 'PLEASE SELECT OPTIONS'
; group_str: db '24F-3053 | 24F-3053'
; instructions_str: db 'INSTRUCTION'
; play_str: db 'PRESS ENTER TO PLAY GAME'

welcome_str db "WELCOME TO BRICK BREAKER"
group_str: db '24F-3053 | 24F-3053'
instructions_str db "USE ARROW KEYS TO MOVE AND SPACE TO START"
play_str    db "PRESS ENTER TO PLAY GAME"
score_rule_str: db 'EACH BRICK = 5 POINTS'
esc_exit_str: db 'PRESS ESC TO EXIT'

ttl_live_str: db 'YOUR TOTAL LIVES ARE 3'
bonus_note_str: db 'BONUS AWARDED IF BREAK ALL BRICKS IN 2 MINS' 
solid_base_str: db 'HITTING RED BRICK WILL SOLIDIFY YOUR BASE'

space_bar: db 'PRESS SPACE BAR TO RELEASE BALL'

total_score_str: db 'YOUR TOTAL SCORES :'
lives_remain_str: db 'LIVES REMAINING'
exit_str: db 'PRESS E TO EXIT'
quit_str: db 'PRESS ENTER+Q TO QUIT GAME'
restart_str: db 'PRESS ENTER+R TO RESTART YOUR GAME'

left_arrow: db 'USE RIGHT & LEFT ARROW TO MOVE BAR'

Lose_str: db 'YOU_LOSE'
Win_str: db 'YOU_WIN!'
Score_str: db 'SCORE'
Lives_str: db 'LIVES'

; Original sound for brick breaking
sound:
	push ax
	push bx
	mov al,182
	out 43h,al
	mov ax, 4560        ; High pitch for brick break
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,2            ; Short duration
	pre:
	mov cx,65535
	pre1:
	dec cx
	jne pre1
	dec bx
	jne pre
	in al,61h
	and al,11111100b
	out 61h,al 
	pop bx
	pop ax
	ret 

; Sound for paddle hit (medium pitch, quick beep)
sound_paddle:
	push ax
	push bx
	mov al,182
	out 43h,al
	mov ax, 2280        ; Medium pitch
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,1            ; Very short duration
	paddle_pre:
	mov cx,65535
	paddle_pre1:
	dec cx
	jne paddle_pre1
	dec bx
	jne paddle_pre
	in al,61h
	and al,11111100b
	out 61h,al 
	pop bx
	pop ax
	ret

; Sound for life lost (low pitch, longer duration - sad sound)
sound_life_lost:
	push ax
	push bx
	push cx
	push dx
	
	; First tone - low pitch
	mov al,182
	out 43h,al
	mov ax, 8000        ; Low pitch
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,3            ; Longer duration
	life_pre1:
	mov cx,65535
	life_pre1_inner:
	dec cx
	jne life_pre1_inner
	dec bx
	jne life_pre1
	
	; Second tone - even lower pitch (descending sound)
	mov ax, 10000       ; Even lower pitch
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,3
	life_pre2:
	mov cx,65535
	life_pre2_inner:
	dec cx
	jne life_pre2_inner
	dec bx
	jne life_pre2
	
	; Turn off speaker
	in al,61h
	and al,11111100b
	out 61h,al 
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret

; Sound for game won (ascending victory melody)
sound_game_won:
	push ax
	push bx
	push cx
	push dx
	
	; Note 1 - Medium pitch
	mov al,182
	out 43h,al
	mov ax, 3000
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,2
	won_pre1:
	mov cx,65535
	won_pre1_inner:
	dec cx
	jne won_pre1_inner
	dec bx
	jne won_pre1
	
	; Note 2 - Higher pitch
	mov ax, 2400
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,2
	won_pre2:
	mov cx,65535
	won_pre2_inner:
	dec cx
	jne won_pre2_inner
	dec bx
	jne won_pre2
	
	; Note 3 - Even higher pitch
	mov ax, 2000
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,2
	won_pre3:
	mov cx,65535
	won_pre3_inner:
	dec cx
	jne won_pre3_inner
	dec bx
	jne won_pre3
	
	; Final note - Highest pitch (victory!)
	mov ax, 1500
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,4            ; Longer final note
	won_pre4:
	mov cx,65535
	won_pre4_inner:
	dec cx
	jne won_pre4_inner
	dec bx
	jne won_pre4
	
	; Turn off speaker
	in al,61h
	and al,11111100b
	out 61h,al 
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret

; Sound for game lost (sad descending melody)
sound_game_lost:
	push ax
	push bx
	push cx
	push dx
	
	; Note 1 - Medium-high pitch
	mov al,182
	out 43h,al
	mov ax, 3000
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,3
	lost_pre1:
	mov cx,65535
	lost_pre1_inner:
	dec cx
	jne lost_pre1_inner
	dec bx
	jne lost_pre1
	
	; Note 2 - Lower pitch
	mov ax, 4000
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,3
	lost_pre2:
	mov cx,65535
	lost_pre2_inner:
	dec cx
	jne lost_pre2_inner
	dec bx
	jne lost_pre2
	
	; Note 3 - Even lower pitch
	mov ax, 6000
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,3
	lost_pre3:
	mov cx,65535
	lost_pre3_inner:
	dec cx
	jne lost_pre3_inner
	dec bx
	jne lost_pre3
	
	; Final note - Lowest pitch (game over)
	mov ax, 9000
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,5            ; Longer final sad note
	lost_pre4:
	mov cx,65535
	lost_pre4_inner:
	dec cx
	jne lost_pre4_inner
	dec bx
	jne lost_pre4
	
	; Turn off speaker
	in al,61h
	and al,11111100b
	out 61h,al 
	
	pop dx
	pop cx
	pop bx
	pop ax
	ret

start_menu:
	push ax
	call clrscr

	; WELCOME (row 8, centered)
	mov ax, 1336
	push ax
	mov ax, welcome_str
	push ax
	mov ax, 24
	push ax
	call printstr

	; GROUP (row 10, centered)
	mov ax, 1500
	push ax
	mov ax, group_str
	push ax
	mov ax, 19
	push ax
	call printstr
	
	; RULES - Lives
	mov ax, 1816
	push ax
	mov ax, ttl_live_str
	push ax
	mov ax, 22
	push ax
	call printstr
	
	; RULES - Scoring (add this string)
	; score_rule_str: db 'EACH BRICK = 5 POINTS'
	mov ax, 1978
	push ax
	mov ax, score_rule_str
	push ax
	mov ax, 21
	push ax
	call printstr

	; INSTRUCTIONS (row 12, centered)
	mov ax, 2120
	push ax
	mov ax, instructions_str
	push ax
	mov ax, 41
	push ax
	call printstr

	; PLAY (row 14, centered, using fancy printer)
	mov ax, 2456
	push ax
	mov ax, play_str
	push ax
	mov ax, 24
	push ax
	call printstr_B
	
	; ESC to exit
	mov ax, 2622
	push ax
	mov ax, esc_exit_str
	push ax
	mov ax, 18
	push ax
	call printstr
	
	pop ax
	ret
	
printnum: 
	push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov ax, [bp+4] ; load number in ax
	mov bx, 10 ; use base 10 for division
	mov cx, 0 ; initialize count of digits

	nextdigit: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigit ; if no divide it again
	mov di, [bp+6] ; point di to 70th column
	nextpos:
		pop dx ; remove a digit from the stack
		mov dh, 0x07 ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextpos ; repeat for all digits on stack

	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
ret 4


; youLose:
	; push ax
	
	; ;call clrscr
	; mov ax , 1990
	; push ax
	; mov ax , Lose_str
	; push ax
	; mov ax , 8
	; push ax
	; call printstr
	
	; ;jmp endgame
	
	; pop ax
; ret

callmee:
	mov ax , 1990
	push ax
	mov ax , Lose_str
	push ax
	mov ax , 8
	push ax
	call printstr
	
	jmp callmee
	
	pop ax
ret
printstr:
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, [bp+8] ; point di to top left column
	mov si, [bp+6] ; point si to string
	mov cx, [bp+4] ; load length of string in cx
	mov ah, 0x07 ; normal attribute fixed in al
	nextchar: 
		mov al, [si] ; load next char of string
		mov [es:di], ax ; show this char on screen
		add di, 2 ; move to next screen location
		add si, 1 ; move to next char in string
		loop nextchar ; repeat the operation cx times
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
ret 6

printstr_B:
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov di, [bp+8] ; point di to top left column
	mov si, [bp+6] ; point si to string
	mov cx, [bp+4] ; load length of string in cx
	mov ah, 0x8e ; normal attribute fixed in al
	nextchar1: 
		mov al, [si] ; load next char of string
		mov [es:di], ax ; show this char on screen
		add di, 2 ; move to next screen location
		add si, 1 ; move to next char in string
		loop nextchar1 ; repeat the operation cx times
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
ret 6

time_str: db 'TIME '
printStrings:
	push ax
		
	mov ax , 162
	push ax
	mov ax , Score_str
	push ax
	mov ax , 5
	push ax
	call printstr
	
	mov ax , 230
	push ax
	mov ax , time_str
	push ax
	mov ax , 5
	push ax
	call printstr

	mov ax , 280
	push ax
	mov ax , Lives_str
	push ax
	mov ax , 5
	push ax
	call printstr
	
	pop ax
ret
clrscr: 
	push es
	push ax
	push cx
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	xor di, di ; point di to top left column
	mov ax, 0x0720 ; space char in normal attribute
	mov cx, 2000 ; number of screen locations
	cld ; auto increment mode
	rep stosw ; clear the whole screen
	pop di 
	pop cx
	pop ax
	pop es
ret 

border:
	push ax
	push es
	push di
	
	mov ax, 0xb800
	mov es, ax
	
	; ===== TOP BORDER (Row 3) - Single line =====
	mov ah, 0x07        ; Red on white for visibility
	mov al, 0xC4        ; Horizontal line character (─)
	mov di, 480         ; Start position (row 3, col 0)
	mov cx, 80          ; Full width
	rep stosw
	
	; ===== BOTTOM BORDER (Row 23) - Changes color if solid =====
	cmp byte[cs:solid], 1
	jne normal_bottom
		mov ah, 0x4F    ; Bright white on red (solid mode)
		jmp draw_bottom
	normal_bottom:
		mov ah, 0x07    ; Normal red on white
	draw_bottom:
		mov al, 0xC4    ; Horizontal line character
		mov di, 3680    ; Row 23
		mov cx, 80
		rep stosw
	
	; ===== LEFT BORDER - Single vertical line =====
	mov ah, 0x07
	mov al, 0xB3        ; Vertical line character (│)
	mov di, 480         ; Start at row 3
	mov cx, 21          ; 21 rows (3 to 23)
	left_loop:
		mov word[es:di], ax
		add di, 160     ; Next row
		loop left_loop
	
	; ===== RIGHT BORDER - Single vertical line =====
	mov ah, 0x07
	mov al, 0xB3
	mov di, 638         ; Right edge (col 79)
	mov cx, 21
	right_loop:
		mov word[es:di], ax
		add di, 160
		loop right_loop
	
	; ===== CORNERS (optional, for clean look) =====
	; Top-left corner
	mov di, 480
	mov ax, 0x07DA      ; ┌
	mov word[es:di], ax
	
	; Top-right corner
	mov di, 638
	mov ax, 0x07BF      ; ┐
	mov word[es:di], ax
	
	; Bottom-left corner
	mov di, 3680
	mov ax, 0x07C0      ; └
	mov word[es:di], ax
	
	; Bottom-right corner
	mov di, 3838
	mov ax, 0x07D9      ; ┘
	mov word[es:di], ax
	
	pop di
	pop es
	pop ax
	ret



brick_remove:
    push es
    push ax
    push dx
    push cx
    push si
    push bx
    push di

    mov ax, 0xb800
    mov es, ax

    mov cx, 32          ; total bricks
    mov si, 0
    mov dx, [cs:calculated_location]

check_brick_loop:
    mov ax, word [cs:bricks_start_location + si]
    mov bx, word [cs:bricks_end_location + si]
    
    ; Check if brick was already removed (marked with 0xFFFF)
    cmp ax, 0xFFFF
    je skip_this_brick
    
    ; IMPROVED: Check if ball position is within brick range
    ; Ball must be >= start AND <= end
    cmp dx, ax
    jb skip_this_brick      ; ball position < brick start
    
    cmp dx, bx
    ja skip_this_brick      ; ball position > brick end
    
    ; Ball hit this brick!
    jmp remove_this_brick

skip_this_brick:
    add si, 2
    loop check_brick_loop
    jmp end_brick_remove

remove_this_brick:
    ; Get brick position
    mov di, word [cs:bricks_start_location + si]
    
    ; Check if this is the special red brick at position 846
    cmp di, 846
    jne not_special_brick
        mov byte [cs:solid], 1
    not_special_brick:
    
    ; Clear the brick (6 characters)
    push cx
    mov cx, 6
    mov ax, 0x0720
    rep stosw
    pop cx
    
    ; Mark brick as removed in the array
    mov word [cs:bricks_start_location + si], 0xFFFF
    mov word [cs:bricks_end_location + si], 0xFFFF
    
    ; Update score and brick count
    call sound
    add word [cs:score], 5
    dec word [cs:total_bricks]
    
    ; Display updated score
    push ax
    mov ax, 174
    push ax
    push word [cs:score]
    call printnum
    pop ax

end_brick_remove:
    pop di
    pop bx
    pop si
    pop cx
    pop dx
    pop ax
    pop es
    ret

bricks:
    push es
    push cx
    push bx
    push si
    push di

    mov ax, 0xb800
    mov es, ax          ; Point to video memory at 0xB800
    mov si, 0           ; Initialize source index (unused but good practice)
    cld                 ; Clear direction flag (auto-increment mode)

;--- Row 1 (Blue - 0x10) at Row 5 of screen ---
row1_start:
    mov di, 810         ; Starting position: Row 5, Column ~1
    mov cx, 8           ; Draw 8 bricks
row1_loop:
    push cx             ; Save brick counter (we need CX for character count)
    
    ; Draw one brick (6 characters wide)
    mov ah, 0x10        ; Blue background (0x10), black foreground (0x00)
    mov al, 0x20        ; ASCII space character
    mov cx, 6           ; Brick width = 6 characters
    rep stosw           ; Repeat: write AX to [ES:DI], DI+=2, CX--
                        ; This draws: [■][■][■][■][■][■]
    
    ; Draw gap between bricks (3 characters)
    mov cx, 3           ; Gap width = 3 characters
    mov ax, 0x0720      ; Normal attribute (black on white)
    rep stosw           ; Draws: [ ][ ][ ]
    
    pop cx              ; Restore brick counter
    loop row1_loop      ; CX--, jump if CX != 0
                        ; Result: 8 bricks with gaps

;--- Row 2 (Green - 0x20) at Row 8 of screen ---
row2_start:
    mov di, 1290        ; Starting position: Row 8, Column ~1
    mov cx, 8           ; Draw 8 bricks
row2_loop:
    push cx
    
    ; Draw green brick
    mov ah, 0x20        ; Green background
    mov al, 0x20        ; Space character
    mov cx, 6
    rep stosw
    
    ; Draw gap
    mov cx, 3
    mov ax, 0x0720
    rep stosw
    
    pop cx
    loop row2_loop

;--- Row 3 (Cyan - 0x30) at Row 11 of screen ---
row3_start:
    mov di, 1770        ; Starting position: Row 11, Column ~1
    mov cx, 8           ; Draw 8 bricks
row3_loop:
    push cx
    
    ; Draw cyan brick
    mov ah, 0x30        ; Cyan background
    mov al, 0x20        ; Space character
    mov cx, 6
    rep stosw
    
    ; Draw gap
    mov cx, 3
    mov ax, 0x0720
    rep stosw
    
    pop cx
    loop row3_loop



    pop di
    pop si
    pop bx
    pop cx
    pop es
    ret



; ===================================================================
; PADDLE WITH 15 CHARACTERS
; ===================================================================
clearStacker:
	push bp
	mov bp , sp
	push es
	push ax
	push di
	push cx
	
	mov ax , 0xb800
	mov es , ax
	
	mov ax , 0x0720
	mov cx , 15          ; Changed to 15
	mov di , [bp+4]
	
	rep stosw
	mov di,[cs:preBall]
	mov word[es:di],ax
	
	pop cx
	pop di
	pop ax
	pop es
	pop bp
ret	2

printStacker:
	push bp
	mov bp , sp
	push es
	push ax
	push di
	push cx
	
	mov ax , 0xb800
	mov es , ax
	
	mov al , 0x20
	mov ah , 0x70
	mov cx , 15          ; Changed to 15
	mov di , [bp+4]
	
	mov word[cs:left_limit] , di
	rep stosw
	sub di , 2
	mov word[cs:right_limit] , di
	
	mov ax , word[cs:right_limit]
	sub ax,14           ; Changed to 14 (15*2/2 - 2)
	mov word[cs:mid] , ax
	
	sub ax,160
	mov di,ax
	shr ax,1
	sub ax,1680
	mov cx,ax
	
	cmp byte[cs:StayOnStacker],1
	jne endi
		mov al,'o'
		mov ah,0x07
		mov word[es:di],ax
		mov [cs:preBall],di
		mov word[cs:row],21
		mov word[cs:colume],cx
		mov word[cs:previous],di
		
		; Initialize ball angle
		mov byte[cs:ball_angle], 1
		mov byte[cs:incC], 1
		mov byte[cs:incR], 0
		
	endi:
	pop cx
	pop di
	pop ax
	pop es
	pop bp
ret	2



stacker:
	push ax
	push di
	
	cmp word[cs:right_] , 1
	je movRight
	cmp word[cs:left_] , 1
	je movLeft
	
	movRight:
		mov ax, word[cs:pre_stack_pos]
		add ax , 8
		cmp ax , word[cs:right_edge]
		ja exit1
			mov di, word[cs:pre_stack_pos]
			push di
			call clearStacker
			push ax
			call printStacker
			mov word[cs:pre_stack_pos] , ax
			jmp exit1
	
	movLeft:
		mov ax, word[cs:pre_stack_pos]
		sub ax , 8
		cmp ax , word[cs:left_edge]
		jb exit1
			mov di, word[cs:pre_stack_pos]
			push di
			call clearStacker
			push ax
			call printStacker
			mov word[cs:pre_stack_pos] , ax
			jmp exit1
	
	exit1:
		pop di
		pop ax
ret
calculate_position: 
	push bp
	mov bp , sp
	push ax
	
	mov al , 80
	mul byte[bp+4]
	add ax , [bp+6]
	shl ax ,1
	
	mov word[cs:calculated_location] , ax
	
	pop ax
	pop bp
	ret 4



nextposition:
	push ax
	push bx
	push cx
	
	mov al,[cs:incC]
	mov ah,[cs:incR]
	mov bx,[cs:colume]
	mov cx,[cs:row]

	; Check LEFT WALL - switch to 45° and bounce right
	cmp word[cs:colume],3
	jne check_right_wall_next
		mov al,1
		mov byte[cs:ball_angle], 1  ; Switch to 45° diagonal
		jmp rowCheck3
		
	check_right_wall_next:
	; Check RIGHT WALL - switch to 45° and bounce left
	cmp word[cs:colume],77
	jne rowCheck3
		mov al,0
		mov byte[cs:ball_angle], 1  ; Switch to 45° diagonal
			
	rowCheck3:
		cmp word[cs:row],4
		jne nextcond5
			mov ah,1
			; Keep 45° angle when hitting ceiling
			jmp printingLocation1
		nextcond5:
			cmp word[cs:row],22
			jne printingLocation1
				mov ah,0
	
	printingLocation1:
		; Only move horizontally if ball_angle is 1 (45°)
		cmp byte[cs:ball_angle], 0
		je skip_horizontal_nextpos
		
		cmp al,1
		jne nextcond6
			add bx,1
			jmp rowCheck4
		nextcond6:
			sub bx,1
			jmp rowCheck4
			
	skip_horizontal_nextpos:
		; 90° angle - don't change column
			
	rowCheck4:
		cmp ah,1
		jne nextcond7
			add cx,1
			jmp calculatelocation1
		nextcond7:
			sub cx,1
			
	calculatelocation1:
		push bx ;colume
		push cx ;row
		call calculate_position
		
	pop cx
	pop bx
	pop ax
	ret




left_right:
	push ax
	
	mov ax , word[cs:calculated_location]
	cmp ax , [cs:mid]
	ja check_right
	
	cmp ax , [cs:left_limit]
	jb endit
	mov byte[cs:left_or_right] , 0
	jmp endit
	
	check_right:
	cmp ax , [cs:right_limit]
	ja endit
	mov byte[cs:left_or_right] , 1
	jmp endit
	
	endit:
	pop ax
ret

check_middle_paddle:
	push ax
	push bx
	
	mov ax, word[cs:calculated_location]
	mov bx, word[cs:mid]
	
	; Middle range for 15-char paddle (mid-5 to mid+5)
	sub bx, 5
	cmp ax, bx
	jb not_middle_paddle
	
	mov bx, word[cs:mid]
	add bx, 5
	cmp ax, bx
	ja not_middle_paddle
	
	; It's in the middle
	mov byte[cs:left_or_right], 2  ; Use 2 to indicate middle
	jmp end_middle_check
	
not_middle_paddle:
	; Not in middle, use normal left_right
	call left_right
	
end_middle_check:
	pop bx
	pop ax
	ret


ball:
	push es
	push ax
	push bx
	push cx
	push di
	
	mov ax,0xb800
	mov es,ax
	
	; Clear previous ball position
	mov di,[cs:previous]
	mov word[es:di],0x0720
	
	; Calculate next position
	call nextposition
	
	; Check what's at new position
	mov di,[cs:calculated_location]
	mov ax,word[es:di]
	
	; Check if hitting paddle (attribute 0x70)
	cmp ah,0x70
	je paddle_collision
	
	; Check if empty space (attribute 0x07)
	cmp ah,0x07
	je R
	
	; Check if hitting CEILING or WALL (attribute 0x40)
	cmp ah,0x40
	je ceiling_collision
	
	; Check if hitting bottom border (attribute 0xb0)
	cmp ah,0xb0
	je border_collision
	
	; Otherwise it's a brick - remove it
	call brick_remove
	jmp reflect_vertical
	
paddle_collision:
	; Ball hit the paddle - play paddle sound
	call sound_paddle
	
	; Check if hit middle of paddle
	call check_middle_paddle
	
	; Always bounce up from paddle
	mov byte[cs:incR],0
	
	; Check where ball hit paddle
	cmp byte[cs:left_or_right], 2
	je hit_middle_paddle
	
	cmp byte[cs:left_or_right],1
	jne hit_left_side
		; Hit right side of paddle - bounce right at 45°
		mov byte[cs:ball_angle], 1
		mov byte[cs:incC],1
		jmp R
	hit_left_side:
		; Hit left side of paddle - bounce left at 45°
		mov byte[cs:ball_angle], 1
		mov byte[cs:incC],0
		jmp R
		
hit_middle_paddle:
	; Hit middle of paddle - go straight up at 90°
	mov byte[cs:ball_angle], 0
	jmp R

ceiling_collision:
	; Hit ceiling (top border)
	; Keep current angle, just bounce
	jmp reflect_vertical

border_collision:
	; Hit side/bottom border
	call left_right
	cmp byte[cs:left_or_right],1
	jne border_left
		mov byte[cs:incC],1
		jmp reflect_vertical
	border_left:
		mov byte[cs:incC],0
	
reflect_vertical:
	; Reflect vertical direction
	cmp byte[cs:incR],1
	jne r1
		mov byte[cs:incR],0
		jmp R
	r1:
		cmp byte[cs:incR],0
		jne R
			mov byte[cs:incR],1
	
R:
	; Check horizontal boundaries - switch to 45° on wall hit
	cmp word[cs:colume],3
	jne nextcond
		mov byte[cs:incC],1
		mov byte[cs:ball_angle], 1  ; Switch to 45° on left wall
		jmp rowCheck
	nextcond:
		cmp word[cs:colume],77
		jne rowCheck
			mov byte[cs:incC],0
			mov byte[cs:ball_angle], 1  ; Switch to 45° on right wall
			
	rowCheck:
		; Check top boundary
		cmp word[cs:row],4
		jne nextcond1
			mov byte[cs:incR],1
			jmp printingLocation
			
		nextcond1:
			; Check if solid base is active
			cmp byte[cs:solid],0
			jne solid12
				; No solid base - check if ball missed paddle
				cmp word[cs:row],22
				jne printingLocation
					; Ball missed paddle - play life lost sound
					call sound_life_lost
					
					; Reset ball position
					mov byte[cs:StayOnStacker],1 
					mov ax,word[cs:mid]
	
					sub ax,160
					mov di,ax
					shr ax,1
					sub ax,1680
					mov cx,ax

					mov al,'o'
					mov ah,0x07
					mov word[es:di],ax
					mov [cs:preBall],di
					mov word[cs:row],21
					mov word[cs:colume],cx
					mov word[cs:previous],di
					
					; Reset to 45° for next launch
					mov byte[cs:ball_angle], 1
					mov byte[cs:incC], 1
					mov byte[cs:incR], 0
					
					sub byte[cs:live],1
					call print_lives
					cmp byte[cs:live],0
					jne endii
					jmp endii
			solid12:
				; Solid base active - bounce at row 23
				cmp word[cs:row],23
				jne printingLocation
					mov byte[cs:incR],0
					
	printingLocation:
		; Update ball position based on direction AND angle
		
		; HORIZONTAL movement - only if 45° angle
		cmp byte[cs:ball_angle], 0
		je skip_horizontal_update
		
		cmp byte[cs:incC],1
		jne nextcond2
			add word[cs:colume],1
			jmp rowCheck1
		nextcond2:
			sub word[cs:colume],1
			jmp rowCheck1
			
	skip_horizontal_update:
		; 90° angle - column doesn't change
		
	rowCheck1:
		; VERTICAL movement - always happens
		cmp byte[cs:incR],1
		jne nextcond3
			add word[cs:row],1
			jmp calculatelocation
		nextcond3:
			sub word[cs:row],1
				
	calculatelocation:
		mov ax,word[cs:row]
		mov bx,80
		mul bx
		add ax,word[cs:colume]
		shl ax,1
		mov di,ax
		mov word[cs:previous],ax
		
	; Draw ball at new position
	mov ah,0x07
	mov al,'o'
	mov word[es:di],ax
	
	endii:
	pop di
	pop cx
	pop bx
	pop ax
	pop es
ret




call_instruction_menu: db 0
instruction_menu:
	push ax
	call clrscr
	
	
	mov ax , 370 ; row 6 col 25
	push ax
	mov ax ,instructions_str
	push ax
	mov ax , 11
	push ax
	call printstr_B
	
	mov ax , 690  ; row 6 col 25
	push ax
	mov ax , ttl_live_str
	push ax
	mov ax , 22
	push ax
	
	call printstr
	
	mov ax , 1010
	push ax
	mov ax , play_str
	push ax
	mov ax , 24
	push ax
	call printstr
	
	
	
	mov ax , 1330
	push ax
	mov ax , solid_base_str
	push ax
	mov ax , 41
	push ax
	call printstr
	
	
	mov ax , 1650
	push ax
	mov ax , bonus_note_str
	push ax
	mov ax , 43
	push ax
	call printstr
	
		
	mov ax , 1970
	push ax
	mov ax , space_bar
	push ax
	mov ax , 31
	push ax
	call printstr
	
	
	mov ax , 2290
	push ax
	mov ax , left_arrow
	push ax
	mov ax , 34
	push ax
	call printstr
	
	mov ax , 2610
	push ax
	mov ax , exit_str
	push ax
	mov ax , 15
	push ax
	call printstr
	
	pop ax
	ret
	
kbisr: 
	push ax
	push es
	
	mov word[cs:right_] , 0
	mov word[cs:left_] , 0
	mov ax, 0xb800
	mov es, ax 
	
	in al, 0x60 ; read a char from keyboard port
	
	cmp byte[start_game] , 0
	jne main_game

	cmp al, 0x01    ; ESC key
	jne check_enter
		call clrscr
	    mov ax, 0x4c00
	    int 0x21        ; Exit program

	check_enter:
	cmp al , 0x1c   ; Enter key
	jne cmp_instruction
	mov byte[start_game] , 1
	jmp exit
	
cmp_instruction:
	cmp al , 0x17
	jne exit
	mov byte[call_instruction_menu] , 1
	
	cmp byte[start_game] , 1
	jne exit
main_game:
	cmp al, 0x4b ; left arrow
	jne nextcmp ; no, try next comparison
		mov word[cs:left_] , 1
		call stacker ; 
		jmp exit ; leave interrupt routine
	nextcmp: 
		cmp al, 0x4d ; right arrow
		jne nextcmp2  ; no, leave interrupt routine
			mov word[cs:right_] , 1
			call stacker
			jmp exit
	nextcmp2: 
		cmp al, 0xad ; has the A key released
		jne nextcmp3 ; no, try next comparison
		;leave interrupt routine
		jmp exit
	nextcmp3: 
		cmp al, 0xab ; has the D key released
		jne nextcmp4 ; no, chain to old ISR
		jmp exit 
	nextcmp4:
		cmp al,0x39 ; space bar
		jne nextcmp5
			mov byte[cs:StayOnStacker],0
		jmp exit
	nextcmp5:
		cmp al,0xb9 ; has the space bar released
		jne exitcmp
		jmp exit
		
	exitcmp: 
		cmp al,0x12 ; has the E key released
		jne quitcmp
		mov byte[cs:end_game] , 1
		jmp exit
	quitcmp:
		cmp al , 0x10 ; has the Q key released
		jne restartcmp
		mov byte[cs:quit] , 1
		jmp exit
	restartcmp:
		cmp al , 0x13 ; has the R key released
		jne nomatch
		mov byte[cs:restart] , 1
		jmp exit
	nomatch: 
		pop es
		pop ax
		jmp far [cs:oldisr] 
	exit:
		mov al, 0x20
		out 0x20, al 
	pop es
	pop ax 
iret 

timer: 
	cmp byte[cs:start_game],1
	jne pp
		inc byte[cs:clock]
		cmp byte[cs:clock],18
		jne ppp
			add word[cs:second],1
			mov byte[cs:clock],0
		ppp:
		cmp byte[cs:solid],1
		jne po
			inc byte[cs:solid1]
			cmp byte[cs:solid1],180
			jne po
				mov byte[cs:solid],0
		po:
		inc word[cs:bonus]
		cmp word[cs:bonus],2160
		jnbe pk
			cmp word[cs:total_bricks],0
			jne pk
				add word[cs:score],50
		pk:
		push ax
		mov ax , 242
		push ax
		mov ax , word[cs:second]
		push ax
		call printnum
		pop ax
	pp:
	cmp byte[cs:StayOnStacker],0
	jne endof
	cmp byte[cs:start_game] , 1
	jne endof
		inc byte[cs:tickcount]
		cmp byte[cs:tickcount], 2
		jne endof
			call ball
			call border
			mov byte[cs:tickcount],0
			;jmp endiii
		endof:
		;cmp byte[cs:live],0
		;jne endiii
			;call youLose
		;endiii:
		mov al, 0x20
		out 0x20, al ; end of interrupt
iret ; return from interrupt 

print_lives:
	push ax
	push es
	
	mov ax , 0xb800
	mov es , ax
	mov cx , 3
	mov ax , 0x0720
	mov di , 292
	rep stosw
	
	mov cl , byte[cs:live]
	mov ch , 0
	mov ah , 0x07
	mov al , '*'
	mov di , 292
	rep stosw
	
	pop es
	pop ax
ret

oldtmr: dd 0
end_game: db 0
start:
	
	xor ax, ax
	mov es, ax ; point es to IVT base
	
	mov ax, [es:9*4]
	mov [oldisr], ax ; save offset of old routine
	mov ax, [es:9*4+2]
	mov [oldisr+2], ax ; save segment of old routine
	
	mov ax, [es:8*4]
	mov [oldtmr], ax ; save offset of old routine
	mov ax, [es:8*4+2]
	mov [oldtmr+2], ax ; save segment of old routine
	
	cli ; disable interrupts
		mov word [es:9*4], kbisr 
		mov [es:9*4+2], cs 
		mov word [es:8*4],timer
		mov [es:8*4+2],cs
	sti ; enable interrupts
	
	call start_menu
menu_loop:
	cmp byte[call_instruction_menu] , 1
	je instruction
	cmp byte[start_game] , 0
	je menu_loop
	cmp byte[end_game] , 1
	je endgame
start_game_here:
	mov byte[restart] , 0
	mov byte[quit] , 0
	mov byte[ball_angle], 1  ; Start with 45° diagonal
	mov byte[incC], 1        ; Start moving right
	mov byte[incR], 0        ; Start moving up
	call clrscr
	call printStrings
	call print_lives
	mov ax , 174
	push ax
	push word[score]
	call printnum
	call border
	call bricks
	mov byte[StayOnStacker],1
	call stacker 
game_inner_loop:
		; mov ax , 402
		; push ax
		; mov ax , [second]
		; push ax
		; call printnum
	
	cmp word[total_bricks] , 0
	je endgame ;;;;abhi impliment karna
	cmp byte[end_game] , 1
	je endgame
	cmp byte[live] , 0
	je endgame
	jmp game_inner_loop
instruction:
	call instruction_menu
again_ins:
	cmp byte[start_game] , 1
	je start_game_here
	jne again_ins
	
endgame:
mov byte[start_game] , 0
call last_menu
call clrscr
cmp byte[restart] , 1
je start_game_here
mov ax , [oldisr]
mov bx , [oldisr+2]
mov cx , [oldtmr]
mov dx , [oldtmr+2]
cli 
mov [es:9*4] , ax
mov [es:9*4+2], bx
mov [es:8*4] , cx
mov [es:8*4+2], dx
sti

mov ax , 0x4c00
int 0x21


restart: db 0
quit: db 0
variable: dw 0



last_menu:
	push ax
	call clrscr
	
	; Check if player lost (no lives remaining)
	cmp byte[live], 0
	jne check_win
		; Player lost - play sad sound
		call sound_game_lost
		mov ax, 1990
		push ax
		mov ax, Lose_str
		push ax
		mov ax, 8
		push ax
		call printstr_B
		jmp no_results
		
check_win:
	; Check if player won (all bricks destroyed)
	cmp word[total_bricks], 0
	jne no_results
		; Player won - play victory sound
		call sound_game_won
		; Display win message
		mov ax, 1990
		push ax
		mov ax, Win_str
		push ax
		mov ax, 8
		push ax
		call printstr_B
	
no_results:
	call last_menu_display
	
what_nxt:
	cmp byte[cs:restart], 1
	je do_restart
	cmp byte[cs:quit], 1
	je go_quit
	jmp what_nxt

go_quit:
	pop ax
	ret
	
do_restart:
	pop ax
	mov word[second], 0
	mov byte[clock], 0
	mov byte[start_game], 1
	mov word[total_bricks], 32
	mov byte[live], 3
	mov word[score], 0
	mov byte[end_game], 0
	mov word[bonus], 0
	ret

		
last_menu_display:
	push ax
	
	mov ax , 690  ; row 6 col 25
	push ax
	mov ax ,total_score_str
	push ax
	mov ax , 17
	push ax
	call printstr
	
	
	mov ax , 728 ; row 6 col 25
	push ax
	push word[score]
	call printnum
	
	
	mov ax , 1330  ; row 6 col 25
	push ax
	mov ax ,lives_remain_str
	push ax
	mov ax , 15
	push ax
	call printstr
	
	mov ax , 1392 ; row 6 col 25
	push ax
	push word[live]
	call printnum
	
	
	mov ax , 1650  ; row 6 col 25
	push ax
	mov ax ,restart_str
	push ax
	mov ax , 34
	push ax
	call printstr
	
	
	mov ax , 1970  ; row 6 col 25
	push ax
	mov ax , quit_str
	push ax
	mov ax , 26
	push ax
	call printstr
	
	pop ax
	ret
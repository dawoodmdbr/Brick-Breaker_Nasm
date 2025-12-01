[org 0x0100]
jmp start

start_game: db 0
oldisr: dd 0
colume: dw 0
row: dw 0
incC: db 1
incR: db 1
ball_angle: db 0
previous: dw 0
tickcount: db 0
left_edge: dw 3518
right_edge: dw 3658
right_: dw 0
left_: dw 0
pre_stack_pos: dw 3588
second: dw 0
minute: db 0
clock: db 0
bonus: dw 0

bricks_start_location:
    dw 810, 828, 846, 864, 882, 900, 918, 936
    dw 1290, 1308, 1326, 1344, 1362, 1380, 1398, 1416
    dw 1770, 1788, 1806, 1824, 1842, 1860, 1878, 1896

bricks_end_location:
    dw 822, 840, 858, 876, 894, 912, 930, 948
    dw 1302, 1320, 1338, 1356, 1374, 1392, 1410, 1428
    dw 1782, 1800, 1818, 1836, 1854, 1872, 1890, 1908

score: dw 0
total_bricks: dw 24
calculated_location: dw 0
left_limit: dw 0
right_limit: dw 0
mid: dw 0
left_or_right: db 0
preBall: dw 0
live: db 3
end_of_game: dw 0
StayOnStacker: db 0
solid: db 0
solid1: db 0

welcome_str: db "WELCOME TO BRICK BREAKER"
group_str: db '24F-3053 | 24F-3053'
instructions_str: db "USE ARROW KEYS TO MOVE AND SPACE TO START"
play_str: db "PRESS ENTER TO PLAY GAME"
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
time_str: db 'TIME '

sound:
	push ax
	push bx
	mov al,182
	out 43h,al
	mov ax, 4560
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,2
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

sound_paddle:
	push ax
	push bx
	mov al,182
	out 43h,al
	mov ax, 2280
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,1
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

sound_life_lost:
	push ax
	push bx
	push cx
	push dx
	mov al,182
	out 43h,al
	mov ax, 8000
	out 42h,al
	mov al,ah
	out 42h,al
	in al,61h
	or al,00000011b
	out 61h,al
	mov bx,3
	life_pre1:
	mov cx,65535
	life_pre1_inner:
	dec cx
	jne life_pre1_inner
	dec bx
	jne life_pre1
	mov ax, 10000
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
	in al,61h
	and al,11111100b
	out 61h,al 
	pop dx
	pop cx
	pop bx
	pop ax
	ret

sound_game_won:
	push ax
	push bx
	push cx
	push dx
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
	mov ax, 1500
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,4
	won_pre4:
	mov cx,65535
	won_pre4_inner:
	dec cx
	jne won_pre4_inner
	dec bx
	jne won_pre4
	in al,61h
	and al,11111100b
	out 61h,al 
	pop dx
	pop cx
	pop bx
	pop ax
	ret

sound_game_lost:
	push ax
	push bx
	push cx
	push dx
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
	mov ax, 9000
	out 42h,al
	mov al,ah
	out 42h,al
	mov bx,5
	lost_pre4:
	mov cx,65535
	lost_pre4_inner:
	dec cx
	jne lost_pre4_inner
	dec bx
	jne lost_pre4
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
	mov ax, 1336
	push ax
	mov ax, welcome_str
	push ax
	mov ax, 24
	push ax
	call printstr
	mov ax, 1500
	push ax
	mov ax, group_str
	push ax
	mov ax, 19
	push ax
	call printstr
	mov ax, 1816
	push ax
	mov ax, ttl_live_str
	push ax
	mov ax, 22
	push ax
	call printstr
	mov ax, 1978
	push ax
	mov ax, score_rule_str
	push ax
	mov ax, 21
	push ax
	call printstr
	mov ax, 2120
	push ax
	mov ax, instructions_str
	push ax
	mov ax, 41
	push ax
	call printstr
	mov ax, 2456
	push ax
	mov ax, play_str
	push ax
	mov ax, 24
	push ax
	call printstr_B
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
	mov es, ax
	mov ax, [bp+4]
	mov bx, 10
	mov cx, 0
	nextdigit: 
		mov dx, 0
		div bx
		add dl, 0x30
		push dx
		inc cx
		cmp ax, 0
		jnz nextdigit
	mov di, [bp+6]
	nextpos:
		pop dx
		mov dh, 0x07
		mov [es:di], dx
		add di, 2
		loop nextpos
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop es
	pop bp
	ret 4

printstr:
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+8]
	mov si, [bp+6]
	mov cx, [bp+4]
	mov ah, 0x07
	nextchar: 
		mov al, [si]
		mov [es:di], ax
		add di, 2
		add si, 1
		loop nextchar
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
	mov es, ax
	mov di, [bp+8]
	mov si, [bp+6]
	mov cx, [bp+4]
	mov ah, 0x8e
	nextchar1: 
		mov al, [si]
		mov [es:di], ax
		add di, 2
		add si, 1
		loop nextchar1
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 6

printStrings:
	push ax
	mov ax, 162
	push ax
	mov ax, Score_str
	push ax
	mov ax, 5
	push ax
	call printstr
	mov ax, 230
	push ax
	mov ax, time_str
	push ax
	mov ax, 5
	push ax
	call printstr
	mov ax, 280
	push ax
	mov ax, Lives_str
	push ax
	mov ax, 5
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
	mov es, ax
	xor di, di
	mov ax, 0x0720
	mov cx, 2000
	cld
	rep stosw
	pop di 
	pop cx
	pop ax
	pop es
	ret 

border:
	push ax
	push es
	push di
	push cx
	mov ax, 0xb800
	mov es, ax
	mov ah, 0x07
	mov al, 0xC4
	mov di, 480
	mov cx, 80
	rep stosw
	cmp byte[cs:solid], 1
	jne normal_bottom
		mov ah, 0x4F
		jmp draw_bottom
	normal_bottom:
		mov ah, 0x07
	draw_bottom:
		mov al, 0xC4
		mov di, 3680
		mov cx, 80
		rep stosw
	mov ah, 0x07
	mov al, 0xB3
	mov di, 480
	mov cx, 21
	left_loop:
		mov word[es:di], ax
		add di, 160
		loop left_loop
	mov ah, 0x07
	mov al, 0xB3
	mov di, 638
	mov cx, 21
	right_loop:
		mov word[es:di], ax
		add di, 160
		loop right_loop
	mov di, 480
	mov ax, 0x07DA
	mov word[es:di], ax
	mov di, 638
	mov ax, 0x07BF
	mov word[es:di], ax
	mov di, 3680
	mov ax, 0x07C0
	mov word[es:di], ax
	mov di, 3838
	mov ax, 0x07D9
	mov word[es:di], ax
	pop cx
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
	mov cx, 24
	mov si, 0
	mov dx, [cs:calculated_location]
check_brick_loop:
	mov ax, word [cs:bricks_start_location + si]
	mov bx, word [cs:bricks_end_location + si]
	cmp ax, 0xFFFF
	je skip_this_brick
	cmp dx, ax
	jb skip_this_brick
	cmp dx, bx
	ja skip_this_brick
	jmp remove_this_brick
skip_this_brick:
	add si, 2
	loop check_brick_loop
	jmp end_brick_remove
remove_this_brick:
	mov di, word [cs:bricks_start_location + si]
	cmp di, 846
	jne not_special_brick
		mov byte [cs:solid], 1
	not_special_brick:
	push cx
	mov cx, 6
	mov ax, 0x0720
	rep stosw
	pop cx
	mov word [cs:bricks_start_location + si], 0xFFFF
	mov word [cs:bricks_end_location + si], 0xFFFF
	call sound
	add word [cs:score], 5
	dec word [cs:total_bricks]
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
	mov es, ax
	mov si, 0
	cld
row1_start:
	mov di, 810
	mov cx, 8
row1_loop:
	push cx
	mov ah, 0x10
	mov al, 0x20
	mov cx, 6
	rep stosw
	mov cx, 3
	mov ax, 0x0720
	rep stosw
	pop cx
	loop row1_loop
row2_start:
	mov di, 1290
	mov cx, 8
row2_loop:
	push cx
	mov ah, 0x20
	mov al, 0x20
	mov cx, 6
	rep stosw
	mov cx, 3
	mov ax, 0x0720
	rep stosw
	pop cx
	loop row2_loop
row3_start:
	mov di, 1770
	mov cx, 8
row3_loop:
	push cx
	mov ah, 0x30
	mov al, 0x20
	mov cx, 6
	rep stosw
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

clearStacker:
	push bp
	mov bp, sp
	push es
	push ax
	push di
	push cx
	mov ax, 0xb800
	mov es, ax
	mov ax, 0x0720
	mov cx, 15
	mov di, [bp+4]
	rep stosw
	mov di, [cs:preBall]
	mov word[es:di], ax
	pop cx
	pop di
	pop ax
	pop es
	pop bp
	ret 2

printStacker:
	push bp
	mov bp, sp
	push es
	push ax
	push di
	push cx
	mov ax, 0xb800
	mov es, ax
	mov al, 0x20
	mov ah, 0x70
	mov cx, 15
	mov di, [bp+4]
	mov word[cs:left_limit], di
	rep stosw
	sub di, 2
	mov word[cs:right_limit], di
	mov ax, word[cs:right_limit]
	sub ax, 14
	mov word[cs:mid], ax
	sub ax, 160
	mov di, ax
	shr ax, 1
	sub ax, 1680
	mov cx, ax
	cmp byte[cs:StayOnStacker], 1
	jne endi
		mov al, 'o'
		mov ah, 0x07
		mov word[es:di], ax
		mov [cs:preBall], di
		mov word[cs:row], 21
		mov word[cs:colume], cx
		mov word[cs:previous], di
		mov byte[cs:ball_angle], 1
		mov byte[cs:incC], 1
		mov byte[cs:incR], 0
	endi:
	pop cx
	pop di
	pop ax
	pop es
	pop bp
	ret 2

stacker:
	push ax
	push di
	cmp word[cs:right_], 1
	je movRight
	cmp word[cs:left_], 1
	je movLeft
	jmp exit1
	movRight:
		mov ax, word[cs:pre_stack_pos]
		add ax, 8
		cmp ax, word[cs:right_edge]
		ja exit1
			mov di, word[cs:pre_stack_pos]
			push di
			call clearStacker
			push ax
			call printStacker
			mov word[cs:pre_stack_pos], ax
			jmp exit1
	movLeft:
		mov ax, word[cs:pre_stack_pos]
		sub ax, 8
		cmp ax, word[cs:left_edge]
		jb exit1
			mov di, word[cs:pre_stack_pos]
			push di
			call clearStacker
			push ax
			call printStacker
			mov word[cs:pre_stack_pos], ax
	exit1:
		pop di
		pop ax
	ret

calculate_position: 
	push bp
	mov bp, sp
	push ax
	mov al, 80
	mul byte[bp+4]
	add ax, [bp+6]
	shl ax, 1
	mov word[cs:calculated_location], ax
	pop ax
	pop bp
	ret 4

nextposition:
	push ax
	push bx
	push cx
	mov al, [cs:incC]
	mov ah, [cs:incR]
	mov bx, [cs:colume]
	mov cx, [cs:row]
	cmp word[cs:colume], 3
	jne check_right_wall_next
		mov al, 1
		mov byte[cs:ball_angle], 1
		jmp rowCheck3
	check_right_wall_next:
	cmp word[cs:colume], 77
	jne rowCheck3
		mov al, 0
		mov byte[cs:ball_angle], 1
	rowCheck3:
		cmp word[cs:row], 4
		jne nextcond5
			mov ah, 1
			jmp printingLocation1
		nextcond5:
			cmp word[cs:row], 22
			jne printingLocation1
				mov ah, 0
	printingLocation1:
		cmp byte[cs:ball_angle], 0
		je skip_horizontal_nextpos
		cmp al, 1
		jne nextcond6
			add bx, 1
			jmp rowCheck4
		nextcond6:
			sub bx, 1
			jmp rowCheck4
	skip_horizontal_nextpos:
	rowCheck4:
		cmp ah, 1
		jne nextcond7
			add cx, 1
			jmp calculatelocation1
		nextcond7:
			sub cx, 1
	calculatelocation1:
		push bx
		push cx
		call calculate_position
	pop cx
	pop bx
	pop ax
	ret

left_right:
	push ax
	mov ax, word[cs:calculated_location]
	cmp ax, [cs:mid]
	ja check_right
	cmp ax, [cs:left_limit]
	jb endit
	mov byte[cs:left_or_right], 0
	jmp endit
	check_right:
	cmp ax, [cs:right_limit]
	ja endit
	mov byte[cs:left_or_right], 1
	endit:
	pop ax
	ret

check_middle_paddle:
	push ax
	push bx
	mov ax, word[cs:calculated_location]
	mov bx, word[cs:mid]
	sub bx, 5
	cmp ax, bx
	jb not_middle_paddle
	mov bx, word[cs:mid]
	add bx, 5
	cmp ax, bx
	ja not_middle_paddle
	mov byte[cs:left_or_right], 2
	jmp end_middle_check
not_middle_paddle:
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
	mov ax, 0xb800
	mov es, ax
	mov di, [cs:previous]
	mov word[es:di], 0x0720
	call nextposition
	mov di, [cs:calculated_location]
	mov ax, word[es:di]
	cmp ah, 0x70
	je paddle_collision
	cmp ah, 0x07
	je R
	cmp ah, 0x40
	je ceiling_collision
	cmp ah, 0xb0
	je border_collision
	call brick_remove
	jmp reflect_vertical
paddle_collision:
	call sound_paddle
	call check_middle_paddle
	mov byte[cs:incR], 0
	cmp byte[cs:left_or_right], 2
	je hit_middle_paddle
	cmp byte[cs:left_or_right], 1
	jne hit_left_side
		mov byte[cs:ball_angle], 1
		mov byte[cs:incC], 1
		jmp R
	hit_left_side:
		mov byte[cs:ball_angle], 1
		mov byte[cs:incC], 0
		jmp R
hit_middle_paddle:
	mov byte[cs:ball_angle], 0
	jmp R
ceiling_collision:
	jmp reflect_vertical
border_collision:
	call left_right
	cmp byte[cs:left_or_right], 1
	jne border_left
		mov byte[cs:incC], 1
		jmp reflect_vertical
	border_left:
		mov byte[cs:incC], 0
reflect_vertical:
	cmp byte[cs:incR], 1
	jne r1
		mov byte[cs:incR], 0
		jmp R
	r1:
		cmp byte[cs:incR], 0
		jne R
			mov byte[cs:incR], 1
R:
	cmp word[cs:colume], 3
	jne nextcond
		mov byte[cs:incC], 1
		mov byte[cs:ball_angle], 1
		jmp rowCheck
	nextcond:
		cmp word[cs:colume], 77
		jne rowCheck
			mov byte[cs:incC], 0
			mov byte[cs:ball_angle], 1
	rowCheck:
		cmp word[cs:row], 4
		jne nextcond1
			mov byte[cs:incR], 1
			jmp printingLocation
	nextcond1:
		cmp byte[cs:solid], 0
		jne solid12
			cmp word[cs:row], 22
			jne printingLocation
				call sound_life_lost
				mov byte[cs:StayOnStacker], 1
				mov ax, word[cs:mid]
				sub ax, 160
				mov di, ax
				shr ax, 1
				sub ax, 1680
				mov cx, ax
				mov al, 'o'
				mov ah, 0x07
				mov word[es:di], ax
				mov [cs:preBall], di
				mov word[cs:row], 21
				mov word[cs:colume], cx
				mov word[cs:previous], di
				mov byte[cs:ball_angle], 1
				mov byte[cs:incC], 1
				mov byte[cs:incR], 0
				sub byte[cs:live], 1
				call print_lives
				cmp byte[cs:live], 0
				jne endii
				jmp endii
	solid12:
		cmp word[cs:row], 23
		jne printingLocation
			mov byte[cs:incR], 0
	printingLocation:
		cmp byte[cs:ball_angle], 0
		je skip_horizontal_update
		cmp byte[cs:incC], 1
		jne nextcond2
			add word[cs:colume], 1
			jmp rowCheck1
		nextcond2:
			sub word[cs:colume], 1
			jmp rowCheck1
	skip_horizontal_update:
	rowCheck1:
		cmp byte[cs:incR], 1
		jne nextcond3
			add word[cs:row], 1
			jmp calculatelocation
		nextcond3:
			sub word[cs:row], 1
	calculatelocation:
		mov ax, word[cs:row]
		mov bx, 80
		mul bx
		add ax, word[cs:colume]
		shl ax, 1
		mov di, ax
		mov word[cs:previous], ax
	mov ah, 0x07
	mov al, 'o'
	mov word[es:di], ax
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
	mov ax, 370
	push ax
	mov ax, instructions_str
	push ax
	mov ax, 11
	push ax
	call printstr_B
	mov ax, 690
	push ax
	mov ax, ttl_live_str
	push ax
	mov ax, 22
	push ax
	call printstr
	mov ax, 1010
	push ax
	mov ax, play_str
	push ax
	mov ax, 24
	push ax
	call printstr
	mov ax, 1330
	push ax
	mov ax, solid_base_str
	push ax
	mov ax, 41
	push ax
	call printstr
	mov ax, 1650
	push ax
	mov ax, bonus_note_str
	push ax
	mov ax, 43
	push ax
	call printstr
	mov ax, 1970
	push ax
	mov ax, space_bar
	push ax
	mov ax, 31
	push ax
	call printstr
	mov ax, 2290
	push ax
	mov ax, left_arrow
	push ax
	mov ax, 34
	push ax
	call printstr
	mov ax, 2610
	push ax
	mov ax, exit_str
	push ax
	mov ax, 15
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
	
	in al, 0x60
	
	cmp byte[start_game] , 0
	jne main_game

	cmp al, 0x01
	jne check_enter
		call clrscr
	    mov ax, 0x4c00
	    int 0x21

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
	cmp al, 0x4b
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
	mov es, ax
	
	mov ax, [es:9*4]
	mov [oldisr], ax
	mov ax, [es:9*4+2]
	mov [oldisr+2], ax 
	
	mov ax, [es:8*4]
	mov [oldtmr], ax
	mov ax, [es:8*4+2]
	mov [oldtmr+2], ax
	
	cli
		mov word [es:9*4], kbisr 
		mov [es:9*4+2], cs 
		mov word [es:8*4],timer
		mov [es:8*4+2],cs
	sti
	
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
	mov byte[ball_angle], 1
	mov byte[incC], 1
	mov byte[incR], 0
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
	
	cmp byte[live], 0
	jne check_win
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
	cmp word[total_bricks], 0
	jne no_results
		call sound_game_won
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
	mov word[total_bricks], 24
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
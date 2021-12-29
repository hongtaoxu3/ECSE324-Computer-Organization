// hongtao xu 260773785
// please un-select "Function clobbered callee-saved register"

.equ pixel, 0xC8000000
.equ char, 0xC9000000
.equ PS2_DATA, 0xFF200100
_start:
bl      input_loop
end:
b       end

draw_real_life_flag: //china 
        push    {r4, lr}
        sub     sp, sp, #8
        ldr     r3, .flags_L86
        str     r3, [sp]
		mov     r3, #240
        mov     r2, #320
		mov     r1, #0
        mov     r0, r1
		bl 		draw_rectangle
		ldr     r4, .flags_L86+4
        mov     r3, r4
        mov     r2, #25
        mov     r1, #50
        mov     r0, #55
        bl      draw_star
		ldr     r4, .flags_L86+4
        mov     r3, r4
        mov     r2, #10
        mov     r1, #30
        mov     r0, #110
        bl      draw_star
		mov     r3, r4
        mov     r2, #10
        mov     r1, #70
        mov     r0, #105
        bl      draw_star
		mov     r3, r4
        mov     r2, #10
        mov     r1, #101
        mov     r0, #80
        bl      draw_star
		mov     r3, r4
        mov     r2, #10
        mov     r1, #110
        mov     r0, #40
        bl      draw_star
		add     sp, sp, #8
        pop     {r4, pc}
.flags_L86:
        .word   45248
		.word   53000
        pop     {r4, pc}

draw_imaginary_flag: //mine
        push    {r4, lr}
        sub     sp, sp, #8
		ldr     r3, .flags_L32 
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #106
        mov     r1, #0
        mov     r0, r1
        bl      draw_rectangle
		ldr     r3, .flags_L32-16
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #106
		mov     r1, #0
        mov     r0, #212
        bl      draw_rectangle
        add     sp, sp, #8
        pop     {r4, pc}

draw_texan_flag: //given
        push    {r4, lr}
        sub     sp, sp, #8
        ldr     r3, .flags_L32
        str     r3, [sp]
        mov     r3, #240
        mov     r2, #106
        mov     r1, #0
        mov     r0, r1
        bl      draw_rectangle
        ldr     r4, .flags_L32+4
        mov     r3, r4
        mov     r2, #43
        mov     r1, #120
        mov     r0, #53
        bl      draw_star
        str     r4, [sp]
        mov     r3, #120
        mov     r2, #214
        mov     r1, #0
        mov     r0, #106
        bl      draw_rectangle
        ldr     r3, .flags_L32+8
        str     r3, [sp]
        mov     r3, #120
        mov     r2, #214
        mov     r1, r3
        mov     r0, #106
        bl      draw_rectangle
        add     sp, sp, #8
        pop     {r4, pc}
.flags_L32:
        .word   2911
        .word   65535
        .word   45248

draw_rectangle:
        push    {r4, r5, r6, r7, r8, r9, r10, lr}
        ldr     r7, [sp, #32]
        add     r9, r1, r3
        cmp     r1, r9
        popge   {r4, r5, r6, r7, r8, r9, r10, pc}
        mov     r8, r0
        mov     r5, r1
        add     r6, r0, r2
        b       .flags_L2
.flags_L5:
        add     r5, r5, #1
        cmp     r5, r9
        popeq   {r4, r5, r6, r7, r8, r9, r10, pc}
.flags_L2:
        cmp     r8, r6
        movlt   r4, r8
        bge     .flags_L5
.flags_L4:
        mov     r2, r7
        mov     r1, r5
        mov     r0, r4
        bl      VGA_draw_point_ASM
        add     r4, r4, #1
        cmp     r4, r6
        bne     .flags_L4
        b       .flags_L5
should_fill_star_pixel:
        push    {r4, r5, r6, lr}
        lsl     lr, r2, #1
        cmp     r2, r0
        blt     .flags_L17
        add     r3, r2, r2, lsl #3
        add     r3, r2, r3, lsl #1
        lsl     r3, r3, #2
        ldr     ip, .flags_L19
        smull   r4, r5, r3, ip
        asr     r3, r3, #31
        rsb     r3, r3, r5, asr #5
        cmp     r1, r3
        blt     .flags_L18
        rsb     ip, r2, r2, lsl #5
        lsl     ip, ip, #2
        ldr     r4, .flags_L19
        smull   r5, r6, ip, r4
        asr     ip, ip, #31
        rsb     ip, ip, r6, asr #5
        cmp     r1, ip
        bge     .flags_L14
        sub     r2, r1, r3
        add     r2, r2, r2, lsl #2
        add     r2, r2, r2, lsl #2
        rsb     r2, r2, r2, lsl #3
        ldr     r3, .flags_L19+4
        smull   ip, r1, r3, r2
        asr     r3, r2, #31
        rsb     r3, r3, r1, asr #5
        cmp     r3, r0
        movge   r0, #0
        movlt   r0, #1
        pop     {r4, r5, r6, pc}
.flags_L17:
        sub     r0, lr, r0
        bl      should_fill_star_pixel
        pop     {r4, r5, r6, pc}
.flags_L18:
        add     r1, r1, r1, lsl #2
        add     r1, r1, r1, lsl #2
        ldr     r3, .flags_L19+8
        smull   ip, lr, r1, r3
        asr     r1, r1, #31
        sub     r1, r1, lr, asr #5
        add     r2, r1, r2
        cmp     r2, r0
        movge   r0, #0
        movlt   r0, #1
        pop     {r4, r5, r6, pc}
.flags_L14:
        add     ip, r1, r1, lsl #2
        add     ip, ip, ip, lsl #2
        ldr     r4, .flags_L19+8
        smull   r5, r6, ip, r4
        asr     ip, ip, #31
        sub     ip, ip, r6, asr #5
        add     r2, ip, r2
        cmp     r2, r0
        bge     .flags_L15
        sub     r0, lr, r0
        sub     r3, r1, r3
        add     r3, r3, r3, lsl #2
        add     r3, r3, r3, lsl #2
        rsb     r3, r3, r3, lsl #3
        ldr     r2, .flags_L19+4
        smull   r1, ip, r3, r2
        asr     r3, r3, #31
        rsb     r3, r3, ip, asr #5
        cmp     r0, r3
        movle   r0, #0
        movgt   r0, #1
        pop     {r4, r5, r6, pc}
.flags_L15:
        mov     r0, #0
        pop     {r4, r5, r6, pc}
.flags_L19:
        .word   1374389535
        .word   954437177
        .word   1808407283
draw_star:
        push    {r4, r5, r6, r7, r8, r9, r10, fp, lr}
        sub     sp, sp, #12
        lsl     r7, r2, #1
        cmp     r7, #0
        ble     .flags_L21
        str     r3, [sp, #4]
        mov     r6, r2
        sub     r8, r1, r2
        sub     fp, r7, r2
        add     fp, fp, r1
        sub     r10, r2, r1
        sub     r9, r0, r2
        b       .flags_L23
.flags_L29:
        ldr     r2, [sp, #4]
        mov     r1, r8
        add     r0, r9, r4
        bl      VGA_draw_point_ASM
.flags_L24:
        add     r4, r4, #1
        cmp     r4, r7
        beq     .flags_L28
.flags_L25:
        mov     r2, r6
        mov     r1, r5
        mov     r0, r4
        bl      should_fill_star_pixel
        cmp     r0, #0
        beq     .flags_L24
        b       .flags_L29
.flags_L28:
        add     r8, r8, #1
        cmp     r8, fp
        beq     .flags_L21
.flags_L23:
        add     r5, r10, r8
        mov     r4, #0
        b       .flags_L25
.flags_L21:
        add     sp, sp, #12
        pop     {r4, r5, r6, r7, r8, r9, r10, fp, pc}
input_loop:
        push    {r4, r5, r6, r7, lr}
        sub     sp, sp, #12
        bl      VGA_clear_pixelbuff_ASM
        bl      draw_texan_flag
        mov     r6, #0
        mov     r4, r6
        mov     r5, r6
        ldr     r7, .flags_L52
        b       .flags_L39
.flags_L46:
        bl      draw_real_life_flag
.flags_L39:
        strb    r5, [sp, #7]
        add     r0, sp, #7
        bl      read_PS2_data_ASM
        cmp     r0, #0
        beq     .flags_L39
        cmp     r6, #0
        movne   r6, r5
        bne     .flags_L39
        ldrb    r3, [sp, #7]    @ zero_extendqisi2
        cmp     r3, #240
        moveq   r6, #1
        beq     .flags_L39
        cmp     r3, #28
        subeq   r4, r4, #1
        beq     .flags_L44
        cmp     r3, #35
        addeq   r4, r4, #1
.flags_L44:
        cmp     r4, #0
        blt     .flags_L45
        smull   r2, r3, r7, r4
        sub     r3, r3, r4, asr #31
        add     r3, r3, r3, lsl #1
        sub     r4, r4, r3
		push    {r4}
        bl      VGA_clear_pixelbuff_ASM
		pop     {r4}
        cmp     r4, #1
        beq     .flags_L46
        cmp     r4, #2
        beq     .flags_L47
        cmp     r4, #0
        bne     .flags_L39
        bl      draw_texan_flag
        b       .flags_L39
.flags_L45:
        bl      VGA_clear_pixelbuff_ASM
.flags_L47:
        bl      draw_imaginary_flag
        mov     r4, #2
        b       .flags_L39
.flags_L52:
        .word   1431655766
		
//draw a point on screen with color, x and y to change the position  
VGA_draw_point_ASM:
LDR r3, =pixel
ADD r3, r3, r1, LSL #10 
ADD r3, r3, r0, LSL #1 
STRH r2, [r3]
BX LR
	
//clear all the things on the graph 
//put all positions to 0; ckear rows and columns one by one 
VGA_clear_pixelbuff_ASM:
MOV r4, #0
MOV r6, #0
MOV r0, #0
col_clean:
LDR r3, =pixel
MOV r1, r4
MOV r0, r6
ADD r3, r3, r1, LSL #10 
ADD r3, r3, r0, LSL #1 
STRH r2, [r3]
ADD r4, r4, #1
CMP r4, #240
BNE col_clean
ADD r6, r6, #1
MOV r4, #0
CMP r6, #320
BNE col_clean
BX LR
	
//chart; +7 is to plus 7 on , a length regulated, one world by one world used to
//write "hello world".
VGA_write_char_ASM:
LDR r3, =char
ADD r3, r3, r1, LSL #7 
ADD r3, r3, r0 
STRB r2, [r3]
BX LR
	
//clear all the valid memory locations in the character buffer, 
//60 and 80 used to clear all the things so that it could appea new stuff 
VGA_clear_charbuff_ASM:
MOV r0, #0
MOV r1, #0
MOV r2, #0
clean:
LDR r3, =char
ADD r3, r3, r1 
ADD r3, r3, r0, LSL #7 
STRB r2, [r3]	
ADD r0, r0, #1
CMP r0, #60
BNE clean	
MOV r0, #0
ADD r1, r1, #1
CMP r1, #80
BNE clean
BX LR

//new stuff in part2; put memory in r3, to determine click or not 
//and determine the keyboard value and type into the blackboard.
read_PS2_data_ASM:
lDR r3, =PS2_DATA
LDR r3, [r3]
MOV r1, r3, LSR #15
BFC r1, #1, #31
CMP r1, #1
BEQ then
MOV r0, #0
BX LR
then:
BFC r3, #8, #23
STRB r3, [r0]
BX LR




//hongtao xu 260773785
//please un-select "Function clobbered callee-saved register 

.equ pixel, 0xC8000000
.equ char, 0xC9000000
_start:
bl draw_thescreen
finish:
b   finish

draw_thescreen:
push    {r4, r5, r6, r7, r8, r9, r10, lr}
bl      VGA_clear_pixelbuff_ASM
bl      VGA_clear_charbuff_ASM
mov     r6, #0
ldr     r10, .draw_thescreen_L8
ldr     r9, .draw_thescreen_L8+4
ldr     r8, .draw_thescreen_L8+8
b       .draw_thescreen_L2

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
		
//draw a point on screen with color, x and y to change the position  
VGA_draw_point_ASM:
LDR r3, =pixel
ADD r3, r3, r1, LSL #10 
ADD r3, r3, r0, LSL #1 
STRH r2, [r3]
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

.draw_thescreen_L7:
add     r6, r6, #1
cmp     r6, #320 
beq     .draw_thescreen_L4
.draw_thescreen_L2:
smull   r3, r7, r10, r6
asr     r3, r6, #31
rsb     r7, r3, r7, asr #2
lsl     r7, r7, #5
lsl     r5, r6, #5
mov     r4, #0
.draw_thescreen_L3:
smull   r3, r2, r9, r5
add     r3, r2, r5
asr     r2, r5, #31
rsb     r2, r2, r3, asr #9
orr     r2, r7, r2, lsl #11
lsl     r3, r4, #5
smull   r0, r1, r8, r3
add     r1, r1, r3
asr     r3, r3, #31
rsb     r3, r3, r1, asr #7
orr     r2, r2, r3
mov     r1, r4
mov     r0, r6
bl      VGA_draw_point_ASM
add     r4, r4, #1
add     r5, r5, #32
cmp     r4, #240 
bne     .draw_thescreen_L3
b       .draw_thescreen_L7
.draw_thescreen_L4:
mov     r2, #72
mov     r1, #5
mov     r0, #20
bl      VGA_write_char_ASM
mov     r2, #101
mov     r1, #5
mov     r0, #21
bl      VGA_write_char_ASM
mov     r2, #108
mov     r1, #5
mov     r0, #22
bl      VGA_write_char_ASM
mov     r2, #108
mov     r1, #5
mov     r0, #23
bl      VGA_write_char_ASM
mov     r2, #111
mov     r1, #5
mov     r0, #24
bl      VGA_write_char_ASM
mov     r2, #32
mov     r1, #5
mov     r0, #25
bl      VGA_write_char_ASM
mov     r2, #87
mov     r1, #5
mov     r0, #26
bl      VGA_write_char_ASM
mov     r2, #111
mov     r1, #5
mov     r0, #27
bl      VGA_write_char_ASM
mov     r2, #114
mov     r1, #5
mov     r0, #28
bl      VGA_write_char_ASM
mov     r2, #108
mov     r1, #5
mov     r0, #29
bl      VGA_write_char_ASM
mov     r2, #100
mov     r1, #5
mov     r0, #30
bl      VGA_write_char_ASM
mov     r2, #33
mov     r1, #5
mov     r0, #31
bl      VGA_write_char_ASM
pop     {r4, r5, r6, r7, r8, r9, r10, lr}
bx lr

.draw_thescreen_L8:
.word   1717986919
.word   -368140053
.word   -2004318071
.end

	
	
	
	
	
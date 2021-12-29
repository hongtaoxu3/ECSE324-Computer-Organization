// hongtao xu 260773785
// please un-select function clobbered callee-saved register 

.equ pixel, 0xC8000000
.equ char, 0xC9000000
.equ PS2_DATA, 0xFF200100

.global read_PS2_data_ASM
start:
bl      input_loop
end:
b       end

write_hex_digit:
push    {r4, lr}
cmp     r2, #9
addhi   r2, r2, #55
addls   r2, r2, #48
and     r2, r2, #255
bl      VGA_write_char_ASM
pop     {r4, pc}
write_byte:
push    {r4, r5, r6, lr}
mov     r5, r0
mov     r6, r1
mov     r4, r2
lsr     r2, r2, #4
bl      write_hex_digit
and     r2, r4, #15
mov     r1, r6
add     r0, r5, #1
bl      write_hex_digit
pop     {r4, r5, r6, pc}
input_loop:
push    {r4, r5, lr}
sub     sp, sp, #12
bl      VGA_clear_pixelbuff_ASM
bl      VGA_clear_charbuff_ASM
mov     r4, #0
mov     r5, r4
b       .input_loop_L9
.input_loop_L13:
ldrb    r2, [sp, #7]
mov     r1, r4
mov     r0, r5
bl      write_byte
add     r5, r5, #3
cmp     r5, #79
addgt   r4, r4, #1
movgt   r5, #0
.input_loop_L8:
cmp     r4, #59
bgt     .input_loop_L12
.input_loop_L9:
add     r0, sp, #7
bl      read_PS2_data_ASM
cmp     r0, #0
beq     .input_loop_L8
b       .input_loop_L13
.input_loop_L12:
add     sp, sp, #12
pop     {r4, r5, pc}

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

//draw a point on screen with color, x and y to change the position  
VGA_draw_point_ASM:
LDR r3, =pixel
ADD r3, r3, r1, LSL #10 
ADD r3, r3, r0, LSL #1 
STRH r2, [r3]
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

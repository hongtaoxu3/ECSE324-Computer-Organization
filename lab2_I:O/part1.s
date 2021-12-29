//Hongtao Xu 260773785
//turn off the Function clobbered callee-saved register
.text
.equ SW_MEMORY, 0xFF200040 //switches 
.equ LED_MEMORY, 0xFF200000 //LEDs Driver 
.equ PB_MEMORY, 0xFF200050
.equ EC_MEMORY, 0xFF20005C
.equ MK_MEMORY, 0xFF200058
.equ HEX_1, 0xFF200020
.equ HEX_2, 0xFF200030
.global HEX_clear_ASM
.global HEX_flood_ASM
.global HEX_write_ASM
.global read_slider_switches_ASM
.global write_LEDs_ASM

_start:
	MOV R3, #00000000000000000000000000000000
	LDR R8, =HEX_2
	LDR R7, =HEX_1
	
	BL read_slider_switches_ASM
	CMP R0, #0x00000200
	BGE check_SW_all				
	MOV R0, #0x00000030			
	BL HEX_flood_ASM            //turn on all the segments of HEX
	
segment_display:						
	BL read_slider_switches_ASM
	CMP R0, #0x00000200
	BGE check_SW_all				
	MOV R0, #0x00000001	
	BL PB_data_is_pressed_ASM
	CMP R0, #1					
	BEQ segment_display
	
	BL PB_edgecp_is_pressed_ASM	//The subroutine receives pushbuttons indices as argument
	CMP  R0, #1
	BLEQ HEX_clear_ASM			//The subroutine will turn off all the segments
	BLNE PB_clear_edgecp_ASM    //The subroutine clears the pushbuttons Edgecapture register.
	CMP R2, #2
	BLEQ HEX_write_ASM			//recivers HEX displays indices and an integer from 0-15
	
need_change:				
	BL read_slider_switches_ASM
	CMP R0, #0x00000200
	BGE check_SW_all				
	MOV R0, #0x00000001	
	BL PB_data_is_pressed_ASM
	CMP R0, #0
	BEQ need_change
	B _start
	
check_SW_all:
	BFC R0, #0, #32
	STR R0, [R7]
	STR R0, [R8]
	B _start

read_slider_switches_ASM: 
    LDR R1, =SW_MEMORY
    LDR R0, [R1]

write_LEDs_ASM:
    LDR R1, =LED_MEMORY
    STR R0, [R1]
    BX LR	
	
HEX_flood_ASM:
	MOV R6, #0x7F
	SUB R9, R0, #0x000000020
	CMP R9, #0
	BGE flood_NUM5

compare_f_NUM4:
	SUB R9, R0, #0x000000010
	CMP R9, #0
	BGE flood_NUM4
	
compare_f_NUM3:
	SUB R9, R0, #0x000000008
	CMP R9, #0
	BGE flood_NUM3
	
compare_f_NUM2:
	SUB R9, R0, #0x000000004
	CMP R9, #0
	BGE flood_NUM2
	
compare_f_NUM1:
	SUB R9, R0, #0x000000002
	CMP R9, #0
	BGE flood_NUM1
	
compare_f_NUM0:
	SUB R9, R1, #0x000000001
	CMP R9, #0
	BEQ flood_NUM0
	B END
	
flood_NUM5:
	BFI R3, R6, #8, #7
	STR R3, [R8]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_f_NUM4
	
flood_NUM4:
	BFI R3, R6, #0, #7
	STR R3, [R8]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_f_NUM3
	
flood_NUM3:
	BFI R3, R6, #24, #7
	STR R3, [R7]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_f_NUM2
	
flood_NUM2:
	BFI R3, R6, #16, #7
	STR R3, [R7]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_f_NUM1
	
flood_NUM1:
	BFI R3, R6, #8, #7
	STR R3, [R7]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_f_NUM0

flood_NUM0:
	BFI R3, R6, #0, #7
	STR R3, [R7]
	B END

HEX_write_ASM:
	LDR R2, =SW_MEMORY
    LDR R1, [R2]
	MOV R0, #0x00000001
compare:
	CMP R1, #0
	BEQ reach0
	CMP R1, #1
	BEQ reach1
	CMP R1, #2
	BEQ reach2
	CMP R1, #3
	BEQ reach3
	CMP R1, #4
	BEQ reach4
	CMP R1, #5
	BEQ reach5
	CMP R1, #6
	BEQ reach6
	CMP R1, #7
	BEQ reach7
	CMP R1, #8
	BEQ reach8
	CMP R1, #9
	BEQ reach9
	CMP R1, #10
	BEQ reach10
	CMP R1, #11
	BEQ reach11
	CMP R1, #12
	BEQ reach12
	CMP R1, #13
	BEQ reach13
	CMP R1, #14
	BEQ reach14
	CMP R1, #15
	BEQ reach15

reach0:
	MOV R10, #0x3F
	B compare_w_NUM5
	
reach1:
	MOV R10, #0x06
	B compare_w_NUM5

reach2:
	MOV R10, #0x5B
	B compare_w_NUM5

reach3:
	MOV R10, #0x4F
	B compare_w_NUM5

reach4:
	MOV R10, #0x66
	B compare_w_NUM5

reach5:
	MOV R10, #0x6D
	B compare_w_NUM5

reach6:
	MOV R10, #0x7D
	B compare_w_NUM5

reach7:
	MOV R10, #0x07
	B compare_w_NUM5

reach8:
	MOV R10, #0x7F
	B compare_w_NUM5

reach9:
	MOV R10, #0x6F
	B compare_w_NUM5

reach10:
	MOV R10, #0x77
	B compare_w_NUM5

reach11:
	MOV R10, #0x7C
	B compare_w_NUM5

reach12:
	MOV R10, #0x39
	B compare_w_NUM5

reach13:
	MOV R10, #0x5E
	B compare_w_NUM5

reach14:
	MOV R10, #0x79
	B compare_w_NUM5

reach15:
	MOV R10, #0x71
	B compare_w_NUM5
	
compare_w_NUM5:
	SUB R11, R0, #0x000000020
	CMP R11, #0
	BGE write_NUM5

compare_w_NUM4:
	SUB R11, R0, #0x000000010
	CMP R11, #0
	BGE write_NUM4
	
compare_w_NUM0:
	SUB R11, R1, #0x000000001
	CMP R11, #0
	BGE write_NUM0
	B END

write_NUM5:
	BFC R3, #0, #32
	BFI R3, R10, #8, #7
	STR R3, [R8]
	CMP R11, #0
	BEQ END
	MOV R0, R11
	B compare_w_NUM4

write_NUM4:
	BFC R3, #0, #32
	BFI R3, R10, #0, #7
	STR R3, [R8]
	CMP R11, #0
	BEQ END
	MOV R0, R11
	B compare_w_NUM0

write_NUM0:
	BFC R3, #0, #32
	BFI R3, R10, #0, #7
	STR R3, [R7]
	B END

END:
	BX LR
	
read_PB_data_ASM:
	LDR R1, =PB_MEMORY
    LDR R0, [R1]
	BX LR

PB_data_is_pressed_ASM:	
	LDR R1, =PB_MEMORY
    LDR R2, [R1]
	BFC R2, #4, #28
    CMP R2, R0
	MOVEQ R0, #1
	MOVNE R0, #0
	BX LR

read_PB_edgecp_ASM:
	LDR R1, =EC_MEMORY	
	LDR R0, [R1]
	BFC R0, #4, #28			
	BX LR

PB_edgecp_is_pressed_ASM:
	LDR R1, =EC_MEMORY
    LDR R2, [R1]
	BFC R2, #4, #28	
    CMP R2, R0
	MOVEQ R0, #1
	MOVNE R0, #0
	BX LR

PB_clear_edgecp_ASM:
	LDR R1, =EC_MEMORY
	MOV R2, #2
    STR R2, [R1]
	BX LR

enable_PB_INT_ASM:
	LDR R1, =PB_MEMORY
    LDR R0, [R1]
	LDR R2, =MK_MEMORY
	MOV R3, R0
	BFC R3, #4, #28	
	STR R3, [R2]
	BX LR	

disable_PB_INT_ASM:
	LDR R1, =MK_MEMORY		
	LDR R2, [R1]			
	BFC R2, #0, #4
	STR R2, [R1]			
	BX LR	

HEX_clear_ASM:
	SUB R9, R0, #0x000000020
	CMP R9, #0
	BGE clear_NUM5

compare_NUM4:
	SUB R9, R0, #0x000000010
	CMP R9, #0
	BGE clear_NUM4
	
compare_NUM3:
	SUB R9, R0, #0x000000008
	CMP R9, #0
	BGE clear_NUM3
	
compare_NUM2:
	SUB R9, R0, #0x000000004
	CMP R9, #0
	BGE clear_NUM2
	
compare_NUM1:
	SUB R9, R0, #0x000000002
	CMP R9, #0
	BGE clear_NUM1

compare_NUM0:
	SUB R9, R1, #0x000000001
	CMP R9, #0
	BEQ clear_NUM0
	B END
	
clear_NUM5:
	BFC R3, #8, #7
	STR R3, [R8]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_NUM4
	
clear_NUM4:
	BFC R3, #0, #7
	STR R3, [R8]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_NUM3
	
clear_NUM3:
	BFC R3, #24, #7
	STR R3, [R7]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_NUM2
	
clear_NUM2:
	BFC R3, #16, #7
	STR R3, [R7]
	CMP R9, #0
	BEQ END
	MOV R0, R9
	B compare_NUM1
	
clear_NUM1:
	BFC R3, #8, #7
	STR R3, [R7]
	CMP R9, #0
	BEQ END

clear_NUM0:
	BFC R3, #0, #7
	STR R3, [R7]
	B END
	
.end
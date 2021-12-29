//Hongtao Xu 260773785
//turn off the Function clobbered callee-saved register
.equ PB_MEMORY, 0xFF200050
.equ EC_MEMORY, 0xFF20005C
.equ MK_MEMORY, 0xFF200058
.equ Interrupt, 0xFFFEC60C
.equ Counter, 0xFFFEC604
.equ Control, 0xFFFEC608
.equ HEX_2, 0xFF200030
.equ HEX_1, 0xFF200020
.equ Load, 0xFFFEC600
LDR R12, =HEX_2
LDR R11, =HEX_1
MOV R10, #0x3F
BFI R3, R10, #0, #7
STR R3, [R11]
BFI R3, R10, #8, #7
STR R3, [R11]
BFI R3, R10, #16, #7
STR R3, [R11]
BFI R3, R10, #24, #7
STR R3, [R11]
BFI R3, R10, #0, #7
STR R3, [R12]
BFI R3, R10, #8, #7
STR R3, [R12]
define:
MOV R10, #0				
MOV R9, #0				
MOV R8, #0
MOV R7, #0
MOV R6, #0					
MOV R5, #0	
LDR R4, =#00000000000000000000000000000000
LDR R3, =#00000000000000000000000000000000
	
begin: 
MOV R0, #0
BL read_PB_edgecp_ASM
CMP R0, #1
BNE begin
	
next:  
BL PB_edgecp_is_pressed_ASM	
CMP  R2, #1
BNE next
BL PB_clear_edgecp_ASM
	
open:        
PUSH {R3-R10}
BL HEX_write_ASM_HEX0
BL HEX_write_ASM_HEX1
BL HEX_write_ASM_HEX2
BL HEX_write_ASM_HEX3
BL HEX_write_ASM_HEX4
BL HEX_write_ASM_HEX5
BL ARM_TIM_config_ASM
BL ARM_TIM_read_INT_ASM
POP {R3-R10}
ADD R5, R5, #1
BL updates
BL ARM_TIM_clear_INT_ASM
B re_count	

PB_edgecp_is_pressed_ASM: LDR R1, =EC_MEMORY
                          LDR R2, [R1]
	                      BFC R2, #4, #28	
                          CMP R2, R0
	                      MOVEQ R2, #1
	                      MOVNE R2, #0
	                      BX LR
ARM_TIM_clear_INT_ASM: LDR R3, =Interrupt
	                   MOV R4, #1
	                   STR R4, [R3]
	                   BX LR
ARM_TIM_read_INT_ASM: LDR R3, =Interrupt
	                  MOV R4, #0
	                  LDR R11, [R3]
	                  BFC R11, #1, #31
	                  CMP R11, #1
	                  BNE ARM_TIM_read_INT_ASM
	                  BX LR				  	
PB_clear_edgecp_ASM: LDR R1, =EC_MEMORY
	                 MOV R2, #0xF
                     STR R2, [R1]
	                 BX LR
ARM_TIM_config_ASM: LDR R1, =Load
	                LDR R0, =#2000000
	                STR R0, [R1]			
	                LDR R2, =Control		
	                MOV R7, #5
	                STR R7, [R2]			
	                BX LR					   		
read_PB_edgecp_ASM: LDR R1, =EC_MEMORY	
	                LDR R0, [R1]
	                BFC R0, #4, #28			
	                BX LR
	
updates:        CMP R5, #10
	            BEQ record_HEX1
	            BX LR	
record_HEX1:    MOV R5, #0
	            ADD R6, R6, #1
	            CMP R6, #10
	            BEQ record_HEX2
	            BX LR	
record_HEX2:    MOV R6, #0
	            ADD R7, R7, #1
	            CMP R7, #10
	            BEQ record_HEX3
	            BX LR
record_HEX3:    MOV R7, #0
	            ADD R8, R8, #1
	            CMP R8, #6
	            BEQ record_HEX4
	            BX LR	
record_HEX4:    MOV R8, #0
	            ADD R9, R9, #1
	            CMP R9, #10
	            BEQ record_HEX5
	            BX LR
record_HEX5:    MOV R9, #0
	            ADD R10, R10, #1
	            BX LR
						 
HEX_write_ASM_HEX0:    LDR R12, =HEX_1
                       CMP R5, #0
                       BEQ arrive0_1
                       CMP R5, #1
                       BEQ arrive0_2
                       CMP R5, #2
                       BEQ arrive0_3
                       CMP R5, #3
                       BEQ arrive0_4
                       CMP R5, #4
                       BEQ arrive0_5
                       CMP R5, #5
                       BEQ arrive0_6
                       CMP R5, #6
                       BEQ arrive0_7
                       CMP R5, #7
                       BEQ arrive0_8
                       CMP R5, #8
                       BEQ arrive0_9
                       CMP R5, #9
                       BEQ arrive0_10
arrive0_1:                 MOV R11, #0x3F
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_2:                 MOV R11, #0x06
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_3:                 MOV R11, #0x5B
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_4:                 MOV R11, #0x4F
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_5:                 MOV R11, #0x66
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_6:                 MOV R11, #0x6D
                       BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_7:                 MOV R11, #0x7D
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_8:                 MOV R11, #0x07
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_9:                 MOV R11, #0x7F
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR
arrive0_10:                 MOV R11, #0x6F
	                   BFI R4, R11, #0, #7
	                   STR R4, [R12]
	                   BX LR

HEX_write_ASM_HEX1:    LDR R12, =HEX_1
                       CMP R6, #0
                       BEQ arrive1_1
                       CMP R6, #1
                       BEQ arrive1_2
                       CMP R6, #2
                       BEQ arrive1_3
                       CMP R6, #3
                       BEQ arrive1_4
                       CMP R6, #4
                       BEQ arrive1_5
                       CMP R6, #5
                       BEQ arrive1_6
                       CMP R6, #6
                       BEQ arrive1_7
                       CMP R6, #7
                       BEQ arrive1_8
                       CMP R6, #8
                       BEQ arrive1_9
                       CMP R6, #9
                       BEQ arrive1_10
arrive1_1:                 MOV R11, #0x3F
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_2:                 MOV R11, #0x06
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_3:                 MOV R11, #0x5B
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_4:                 MOV R11, #0x4F
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_5:                 MOV R11, #0x66
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_6:                 MOV R11, #0x6D
                       BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_7:                 MOV R11, #0x7D
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_8:                 MOV R11, #0x07
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_9:                 MOV R11, #0x7F
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
arrive1_10:                 MOV R11, #0x6F
	                   BFI R4, R11, #8, #7
	                   STR R4, [R12]
	                   BX LR
					   
HEX_write_ASM_HEX2:    LDR R12, =HEX_1
                       CMP R7, #0
                       BEQ arrive2_1
                       CMP R7, #1
                       BEQ arrive2_2
                       CMP R7, #2
                       BEQ arrive2_3
                       CMP R7, #3
                       BEQ arrive2_4
                       CMP R7, #4
                       BEQ arrive2_5
                       CMP R7, #5
                       BEQ arrive2_6
                       CMP R7, #6
                       BEQ arrive2_7
                       CMP R7, #7
                       BEQ arrive2_8
                       CMP R7, #8
                       BEQ arrive2_9
                       CMP R7, #9
                       BEQ arrive2_10
arrive2_1:                 MOV R11, #0x3F
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_2:                 MOV R11, #0x06
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_3:                 MOV R11, #0x5B
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_4:                 MOV R11, #0x4F
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_5:                 MOV R11, #0x66
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_6:                 MOV R11, #0x6D
                       BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_7:                 MOV R11, #0x7D
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_8:                 MOV R11, #0x07
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_9:                 MOV R11, #0x7F
	                   BFI R4, R11, #16, #7
	                   STR R4, [R12]
	                   BX LR
arrive2_10:                 MOV R11, #0x6F
	                   BFI R4, R11,#16, #7
	                   STR R4, [R12]
	                   BX LR
					   
HEX_write_ASM_HEX3:    LDR R12, =HEX_1
                       CMP R8, #0
                       BEQ arrive3_1
                       CMP R8, #1
                       BEQ arrive3_2
                       CMP R8, #2
                       BEQ arrive3_3
                       CMP R8, #3
                       BEQ arrive3_4
                       CMP R8, #4
                       BEQ arrive3_5
					   CMP R8, #5
                       BEQ arrive3_6          
arrive3_1:                 MOV R11, #0x3F
	                   BFI R4, R11, #24, #7
	                   STR R4, [R12]
	                   BX LR
arrive3_2:                 MOV R11, #0x06
	                   BFI R4, R11, #24, #7
	                   STR R4, [R12]
	                   BX LR
arrive3_3:                 MOV R11, #0x5B
	                   BFI R4, R11, #24, #7
	                   STR R4, [R12]
	                   BX LR
arrive3_4:                 MOV R11, #0x4F
	                   BFI R4, R11, #24, #7
	                   STR R4, [R12]
	                   BX LR
arrive3_5:                 MOV R11, #0x66
	                   BFI R4, R11, #24, #7
	                   STR R4, [R12]
	                   BX LR
arrive3_6:                 MOV R11, #0x66
	                   BFI R4, R11, #24, #7
	                   STR R4, [R12]
	                   BX LR
				   
HEX_write_ASM_HEX4:    LDR R12, =HEX_2
                       CMP R9, #0
                       BEQ arrive4_1
                       CMP R9, #1
                       BEQ arrive4_2
                       CMP R9, #2
                       BEQ arrive4_3
                       CMP R9, #3
                       BEQ arrive4_4
                       CMP R9, #4
                       BEQ arrive4_5
                       CMP R9, #5
                       BEQ arrive4_6
                       CMP R9, #6
                       BEQ arrive4_7
                       CMP R9, #7
                       BEQ arrive4_8
                       CMP R9, #8
                       BEQ arrive4_9
                       CMP R9, #9
                       BEQ arrive4_10					   
arrive4_1:                 MOV R11, #0x3F
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_2:                 MOV R11, #0x06
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_3:                 MOV R11, #0x5B
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_4:                 MOV R11, #0x4F
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_5:                 MOV R11, #0x66
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_6:                 MOV R11, #0x6D
                       BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_7:                 MOV R11, #0x7D
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_8:                 MOV R11, #0x07
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_9:                 MOV R11, #0x7F
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
arrive4_10:                 MOV R11, #0x6F
	                   BFI R3, R11, #0, #7
	                   STR R3, [R12]
	                   BX LR
					   
HEX_write_ASM_HEX5:    LDR R12, =HEX_2
                       CMP R10, #0
                       BEQ arrive5_1
                       CMP R10, #1
                       BEQ arrive5_2
                       CMP R10, #2
                       BEQ arrive5_3
                       CMP R10, #3
                       BEQ arrive5_4
                       CMP R10, #4
                       BEQ arrive5_5
                       CMP R10, #5
                       BEQ arrive5_6
                       CMP R10, #6
                       BEQ arrive5_7
                       CMP R10, #7
                       BEQ arrive5_8
                       CMP R10, #8
                       BEQ arrive5_9
                       CMP R10, #9
                       BEQ arrive5_10
arrive5_1:                 MOV R11, #0x3F
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_2:                 MOV R11, #0x06
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_3:                 MOV R11, #0x5B
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_4:                 MOV R11, #0x4F
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_5:                 MOV R11, #0x66
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_6:                 MOV R11, #0x6D
                       BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_7:                 MOV R11, #0x7D
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_8:                 MOV R11, #0x07
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_9:                 MOV R11, #0x7F
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
arrive5_10:                 MOV R11, #0x6F
	                   BFI R3, R11, #8, #7
	                   STR R3, [R12]
	                   BX LR
					   
re_count:     MOV R0, #0
	          BL read_PB_edgecp_ASM
	          CMP R0, #0
	          BEQ open
			  
release:      BL PB_edgecp_is_pressed_ASM	
	          CMP  R2, #1
	          BNE release
	          BL PB_clear_edgecp_ASM
	          CMP R0, #1					
	          BEQ open
	          CMP R0, #2
	          BEQ begin
	          CMP R0, #4
	          BEQ define
.end
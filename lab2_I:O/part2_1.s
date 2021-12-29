//Hongtao Xu 260773785
//turn off the Function clobbered callee-saved register	
.global _start
_start:
.equ Control, 0xFFFEC608
.equ Interrupt, 0xFFFEC60C
.equ Counter, 0xFFFEC604
.equ HEX_1, 0xFF200020
.equ Load, 0xFFFEC600
LDR R8, =HEX_1
MOV R5, #0					
	
remember: BL HEX_write_ASM
	      BL ARM_TIM_config_ASM
	      BL ARM_TIM_read_INT_ASM
	      ADD R5, R5, #1
	      BL ARM_TIM_clear_INT_ASM
	      CMP R5, #16
	      MOVEQ R5, #0
	      B remember
	
HEX_write_ASM: CMP R5, #0
	           BEQ reach0
	           CMP R5, #1
	           BEQ reach1
	           CMP R5, #2
	           BEQ reach2
	           CMP R5, #3
	           BEQ reach3
	           CMP R5, #4
	           BEQ reach4
	           CMP R5, #5
	           BEQ reach5
	           CMP R5, #6
	           BEQ reach6
	           CMP R5, #7
	           BEQ reach7
	           CMP R5, #8
	           BEQ reach8
	           CMP R5, #9
	           BEQ reach9
	           CMP R5, #10
	           BEQ reach10
	           CMP R5, #11
	           BEQ reach11
	           CMP R5, #12
	           BEQ reach12
	           CMP R5, #13
	           BEQ reach13
	           CMP R5, #14
	           BEQ reach14
	           CMP R5, #15
	           BEQ reach15
reach0: MOV R0, #0x3F
	    STR R0, [R8]
	    B finish
reach1: MOV R0, #0x06
        STR R0, [R8]
	    B finish
reach2: MOV R0, #0x5B
        STR R0, [R8]
	    B finish
reach3: MOV R0, #0x4F
        STR R0, [R8]
	    B finish
reach4: MOV R0, #0x66
        STR R0, [R8]
	    B finish
reach5: MOV R0, #0x6D
        STR R0, [R8]
	    B finish
reach6: MOV R0, #0x7D
	    STR R0, [R8]
	    B finish
reach7: MOV R0, #0x07
        STR R0, [R8]
	    B finish
reach8: MOV R0, #0x7F
        STR R0, [R8]
	    B finish
reach9: MOV R0, #0x6F
        STR R0, [R8]
	    B finish
reach10:MOV R0, #0x77
        STR R0, [R8]
	    B finish
reach11:MOV R0, #0x7C
        STR R0, [R8]
	    B finish
reach12:MOV R0, #0x39
        STR R0, [R8]
	    B finish
reach13:MOV R0, #0x5E
        STR R0, [R8]
	    B finish
reach14:MOV R10, #0x79
        STR R10, [R8]
	    B finish
reach15:MOV R0, #0x71
        STR R0, [R8]
	    B finish
finish: BX LR
	
ARM_TIM_config_ASM:	//The subroutine is used to configure the timer		
	LDR R1, =Load
	LDR R0, =#200000000
	STR R0, [R1]			
	LDR R2, =Control
	MOV R7, #5				
	STR R7, [R2]			
	BX LR
	
ARM_TIM_read_INT_ASM://The subroutine returns the “F” value
	LDR R3, =Interrupt
	MOV R4, #0
	LDR R6, =Counter
	LDR R11, [R6]
	CMP R11, #0
	BEQ record_F
	STR R4, [R3]
	B ARM_TIM_read_INT_ASM
	
ARM_TIM_clear_INT_ASM://The subroutine clears the “F” value in the ARM A9 private
	ADD R4, R4, #1
	STR R4, [R3]
	BX LR
				
record_F:
	ADD R4, #1
	STR R4, [R3]
	BX LR	
	
.end
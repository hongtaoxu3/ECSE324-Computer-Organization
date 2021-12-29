//Hongtao Xu 260773785
//turn off the Function clobbered callee-saved register
//turn off Device-specific warnings
.section .vectors, "ax"
B _start
B SERVICE_UND // undefined instruction vector
B SERVICE_SVC // software interrupt vector
B SERVICE_ABT_INST // aborted prefetch vector
B SERVICE_ABT_DATA // aborted data vector
.word 0 // unused vector
B SERVICE_IRQ // IRQ interrupt vector
B SERVICE_FIQ // FIQ interrupt vector
//all provided
.text
.global _start
tim_int_flag :.word 0x0
PB_int_flag : .word 0x0
.equ SEVEN_DISPLAY, 0xFF200020
.equ PUSH_BUTTONS, 0xFF200050
.equ TIMER, 0xFFFEC600 

_start:
/* Set up stack pointers for IRQ and SVC processor modes */
MOV R1, #0b11010010 // interrupts masked, MODE = IRQ
MSR CPSR_c, R1 // change to IRQ mode
LDR SP, =0xFFFFFFFF - 3 // set IRQ stack to A9 onchip memroy
/* Change to SVC (supervisor) mode with interrupts disabled */
MOV R1, #0b11010011 // interrupts masked, MODE = SVC
MSR CPSR, R1 // change to supervisor mode
LDR SP, =0x3FFFFFFF - 3 // set SVC stack to top of DDR3 memory
BL CONFIG_GIC // configure the ARM GIC
// To DO: write to the pushbutton KEY interrupt mask register
// Or, you can call enable_PB_INT_ASM subroutine from previous task
// to enable interrupt for ARM A9 private timer, use
MOV R0, #0xF             
BL enable_PB_INT_ASM
MOV R1, #2
MOV	R0, #0
BL ARM_TIM_config_ASM
// enable IRQ interrupts in the processor
MOV R0, #0b01010011 // IRQ unmasked, MODE = SVC
MSR CPSR_c, R0
IDLE:
// This is where you write your objective task

MOV R1, #0x00000007	
LDR R0, =#2000000					
PUSH {R0-R2}
BL ARM_TIM_config_ASM		
POP {R0-R2}
MOV R6, #0					
MOV R5, #0					
MOV R4, #0					
MOV R3, #0					
MOV R2, #0					
MOV R1, #0					
MOV R0, #0					
PUSH {R0-R3}
for:	
LDR R7, PB_int_flag
CMP R7, #2
BEQ later
CMP R7, #4
BLEQ again
LDR R8, tim_int_flag
CMP R8, #1
MOV R8, #0
BLEQ increase
B for
	  	
/*--- Undefined instructions --------------------------------------*/
SERVICE_UND:
B SERVICE_UND
/*--- Software interrupts ----------------------------------------*/
SERVICE_SVC:
B SERVICE_SVC
/*--- Aborted data reads ------------------------------------------*/
SERVICE_ABT_DATA:
B SERVICE_ABT_DATA
/*--- Aborted instruction fetch -----------------------------------*/
SERVICE_ABT_INST:
B SERVICE_ABT_INST
/*--- IRQ ---------------------------------------------------------*/
SERVICE_IRQ:
PUSH {R0-R7, LR}
/* Read the ICCIAR from the CPU Interface */
LDR R4, =0xFFFEC100
LDR R5, [R4, #0x0C] // read from ICCIAR
CMP R5, #29
PUSH {R5}
BLEQ ARM_TIM_ISR
POP {R5}
CMP	R5, #73
BLEQ KEY_ISR
/* To Do: Check which interrupt has occurred (check interrupt IDs)
Then call the corresponding ISR
If the ID is not recognized, branch to UNEXPECTED
See the assembly example provided in the De1-SoC Computer_Manual
on page 46 */
Pushbutton_check:
CMP R5, #73
CMPNE R5, #29
UNEXPECTED:
BNE UNEXPECTED // if not recognized, stop here
EXIT_IRQ:
/* Write to the End of Interrupt Register (ICCEOIR) */
STR R5, [R4, #0x10] // write to ICCEOIR
POP {R0-R7, LR}
SUBS PC, LR, #4
/*--- FIQ ---------------------------------------------------------*/
SERVICE_FIQ:
B SERVICE_FIQ
		
CONFIG_GIC:
PUSH {LR}
/* To configure the FPGA KEYS interrupt (ID 73):
* 1. set the target to cpu0 in the ICDIPTRn register
* 2. enable the interrupt in the ICDISERn register */
/* CONFIG_INTERRUPT (int_ID (R0), CPU_target (R1)); */
/* To Do: you can configure different interrupts
by passing their IDs to R0 and repeating the next 3 lines */
MOV R0, #29 // KEY port (Interrupt ID = 73)
MOV R1, #1  // this field is a bit-mask; bit 0 targets cpu0
BL CONFIG_INTERRUPT
MOV R0, #73
MOV R1, #1
BL CONFIG_INTERRUPT

/* configure the GIC CPU Interface */
LDR R0, =0xFFFEC100 // base address of CPU Interface
/* Set Interrupt Priority Mask Register (ICCPMR) */
LDR R1, =0xFFFF // enable interrupts of all priorities levels
STR R1, [R0, #0x04]
/* Set the enable bit in the CPU Interface Control Register (ICCICR).
* This allows interrupts to be forwarded to the CPU(s) */
MOV R1, #1
STR R1, [R0]
/* Set the enable bit in the Distributor Control Register (ICDDCR).
* This enables forwarding of interrupts to the CPU Interface(s) */
LDR R0, =0xFFFED000
STR R1, [R0]
POP {PC}

/*
* Configure registers in the GIC for an individual Interrupt ID
* We configure only the Interrupt Set Enable Registers (ICDISERn) and
* Interrupt Processor Target Registers (ICDIPTRn). The default
(reset)
* values are used for other registers in the GIC
* Arguments: R0 = Interrupt ID, N
* R1 = CPU target
*/

CONFIG_INTERRUPT:
PUSH {R4-R5, LR}
/* Configure Interrupt Set-Enable Registers (ICDISERn).
* reg_offset = (integer_div(N / 32) * 4
* value = 1 << (N mod 32) */
LSR R4, R0, #3 // calculate reg_offset
BIC R4, R4, #3 // R4 = reg_offset
LDR R2, =0xFFFED100
ADD R4, R2, R4 // R4 = address of ICDISER
AND R2, R0, #0x1F // N mod 32
MOV R5, #1 // enable
LSL R2, R5, R2 // R2 = value
/* Using the register address in R4 and the value in R2 set the
* correct bit in the GIC register */
LDR R3, [R4] // read current register value
ORR R3, R3, R2 // set the enable bit
STR R3, [R4] // store the new register value
/* Configure Interrupt Processor Targets Register (ICDIPTRn)
* reg_offset = integer_div(N / 4) * 4
* index = N mod 4 */
BIC R4, R0, #3 // R4 = reg_offset
LDR R2, =0xFFFED800
ADD R4, R2, R4 // R4 = word address of ICDIPTR
AND R2, R0, #0x3 // N mod 4
ADD R4, R2, R4 // R4 = byte address in ICDIPTR
/* Using register address in R4 and the value in R2 write to
* (only) the appropriate byte */
STRB R1, [R4]
POP {R4-R5, PC}

increase: 
PUSH {LR}
ADD	R0, R0, #1			
PUSH {R0-R3}
LDR R2, =SEVEN_DISPLAY
BL HEX_write_ASM			
POP {R0-R3}
PUSH {R0-R3}
MOV R0, R1
LDR R2, =SEVEN_DISPLAY
ADD R2, R2, #1
BL HEX_write_ASM			
POP {R0-R3}
PUSH {R0-R3}
MOV R0, R2
LDR R2, =SEVEN_DISPLAY
ADD R2, R2, #2
BL HEX_write_ASM			
POP {R0-R3}
PUSH {R0-R3}
MOV R0, R3
LDR R2, =SEVEN_DISPLAY
ADD R2, R2, #3
BL HEX_write_ASM			
POP {R0-R3}
PUSH {R0-R3}
MOV R0, R4
LDR R2, =SEVEN_DISPLAY
ADD R2, R2, #16
BL HEX_write_ASM			
POP {R0-R3}
PUSH {R0-R3}
MOV R0, R5
LDR R2, =SEVEN_DISPLAY
ADD R2, R2, #17
BL HEX_write_ASM			
POP {R0-R3}
CMP R0, #9				
MOVEQ R0, #-1			
ADDEQ R1, R1, #1
CMPEQ R1, #10
MOVEQ R1, #0			
ADDEQ R2, R2, #1
CMPEQ R2, #10
MOVEQ R2, #0			
ADDEQ R3, R3, #1
CMPEQ R3, #6
MOVEQ R3, #0			
ADDEQ R4, R4, #1
CMPEQ R4, #10
MOVEQ R4, #0			
ADDEQ R5, R5, #1
CMPEQ R5, #10
MOVEQ R5, #0			
ADDEQ R6, R6, #1
CMPEQ R6, #6
MOVEQ R6, #0			
MOV R8, #0
STR R8, tim_int_flag
POP {LR}
BX LR

KEY_ISR:
LDR R0, =0xFF200050 // base address of pushbutton KEY port
LDR R1, [R0, #0xC] // read edge capture register
STR R1, PB_int_flag
MOV R2, #0xF
STR R2, [R0, #0xC]     // clear the interrupt
BX LR	
PB_edgecp_is_pressed_ASM: 
LDR R2, =PUSH_BUTTONS
ADD R2, R2, #12
LDR R1, [R2]
TST R0, R1
MOVNE R0, #1
MOVEQ R0, #0
BX LR
ARM_TIM_clear_INT_ASM:
MOV R0, #0x00000001
LDR R1, =TIMER
ADD R1, R1, #12
STR R0, [R1]
BX LR
ARM_TIM_read_INT_ASM:
LDR R1, =TIMER
ADD R1, R1, #12
LDR R0, [R1]
BX LR	
PB_clear_edgecp_ASM:
LDR R1, =PUSH_BUTTONS
ADD R1, R1, #12
MOV R0, #255
STR R0, [R1]
BX LR
ARM_TIM_config_ASM:
LDR R2,=TIMER
STR R0, [R2]
ADD R2, R2, #8
STR R1, [R2]
BX LR
enable_PB_INT_ASM:
LDR R1, =0xFF200050 
ADD R1, R1, #8
LDR R2, [R1]
ORR R0, R0, R2
STR R0, [R1]
BX LR	
ARM_TIM_ISR: 	
MOV R0, #1
STR R0, tim_int_flag
LDR R0, =#0xFFFEC60C
MOV R1, #0x00000001
STR R1, [R0]	

cleanHEX:
LDR R1, =SEVEN_DISPLAY
MOV R3, #1				
cleanloop:	TST R0, R3			
PUSH {LR}
BLNE cleansegment		
POP {LR}
ADD R1, R1, #1		
LSL R3, R3, #1
CMP R3, #16			
ADDEQ R1, R1, #12	 
CMP R3, #33
BLE cleanloop
BX LR
cleansegment:			
MOV R2, #0		
STRB R2, [R1]
BX LR			
	
HEX_write_ASM:
CMP R0, #0
MOVEQ R3, #0x3F
STREQB R3, [R2]
CMP R0, #1
MOVEQ R3, #0x06
STREQB R3, [R2]
CMP R0, #2
MOVEQ R3, #0x5B
STREQB R3, [R2]
CMP R0, #3
MOVEQ R3, #0x4F
STREQB R3, [R2]
CMP R0, #4
MOVEQ R3, #0x66
STREQB R3, [R2]
CMP R0, #5
MOVEQ R3, #0x6D
STREQB R3, [R2]
CMP R0, #6
MOVEQ R3, #0x7D
STREQB R3, [R2]
CMP R0, #7
MOVEQ R3, #0x07
STREQB R3, [R2]
CMP R0, #8
MOVEQ R3, #0x7F
STREQB R3, [R2]
CMP R0, #9
MOVEQ R3, #0x6F
STREQB R3, [R2]
CMP R0, #10
MOVEQ R3, #0x77
STREQB R3, [R2]
CMP R0, #11
MOVEQ R3, #0x7C
STREQB R3, [R2]
CMP R0, #12
MOVEQ R3, #0x39
STREQB R3, [R2]
CMP R0, #13
MOVEQ R3, #0x5E
STREQB R3, [R2]
CMP R0, #14
MOVEQ R3, #0x79
STREQB R3, [R2]
CMP R0, #15
MOVEQ R3, #0x71
STREQB R3, [R2]
BX LR

again:
MOV R0, #63
PUSH {LR}
BL cleanHEX
POP {LR}
MOV R0, #0
MOV R1, #0
MOV R2, #0
MOV R3, #0
MOV R4, #0
MOV R5, #0
MOV R6, #0
STR R6, PB_int_flag
BX LR
later: 
LDR R7, PB_int_flag
CMP R7, #1
LDREQ R7, =PB_int_flag
MOVEQ R8, #0
STREQ R8, [R7]			
MOVEQ R7, #0
BEQ for
CMP R7, #4
BLEQ again
B later
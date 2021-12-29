.global _start

array: .word -1, 23, 0, 12, -7

_start:  LDR R0, =array
         MOV R1, #4 
		 //size
         MOV R2, #0 
		 //step
 
steploop:
         MOV R3, #0 
		 //i
         CMP R2, R1
         BLT iloop
 
end:
         B end
 
iloop:
         SUB R4, R1, R2
         CMP R3, R4
         BLT assign
         ADD R2, R2, #1
         B steploop
		 
swap:
         STR R6, [R0, R5]
         SUB R5, R5, #4
         STR R7, [R0, R5]
         ADD R3, R3, #1
         B iloop
 
assign:
         MOV R5, #4
         MUL R5, R3, R5
         LDR R6, [R0, R5] 
         ADD R5, R5, #4
         LDR R7, [R0, R5] 
         CMP R6, R7
         BGT swap
         ADD R3, R3, #1
         B iloop
 



 

.global _start

_start: MOV R0, #1
        MOV R1, #6
        MOV R2, #1
        MOV R3, #1
        MOV R4, R1
        BL if
 
end:    B end

if:     PUSH {LR}
        CMP R1, #3
        BLT less
        ADD R5, R2, R3
        MOV R0, R5
        MOV R2, R3
        MOV R3, R5
        SUB R4, R4, #1
        CMP R4, #3
        BLT total
        BL if
 
total:  POP {LR}
        BX LR
 
less:   POP {LR}
        BX LR
 


 

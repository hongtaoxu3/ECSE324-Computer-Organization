.global _start

_start: MOV R0, #0
        MOV R1, #4
        MOV R2, #1
        BL if
 
end:    B end

back1:  POP {LR}
        BX LR

if:     PUSH {LR}
        CMP R1, #2
        BLT back1
        MUL R2, R2, R1
        MOV R0, R2
        SUB R1, R1, #1
		POP {LR}
        BL if
 

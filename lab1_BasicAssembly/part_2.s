.global _start
array1: .word 183 , 207 , 128 , 30 , 109 , 0 , 14 , 52 , 15 , 210,
 228 , 76 , 48 , 82 , 179 , 194 , 22 , 168 , 58 , 116,
 228 , 217 , 180 , 181 , 243 , 65 , 24 , 127 , 216 , 118,
 64 , 210 , 138 , 104 , 80 , 137 , 212 , 196 , 150 , 139,
 155 , 154 , 36 , 254 , 218 , 65 , 3 , 11 , 91 , 95,
 219 , 10 , 45 , 193 , 204 , 196 , 25 , 177 , 188 , 170,
 189 , 241 , 102 , 237 , 251 , 223 , 10 , 24 , 171 , 71,
 0 , 4 , 81 , 158 , 59 , 232 , 155 , 217 , 181 , 19,
 25 , 12 , 80 , 244 , 227 , 101 , 250 , 103 , 68 , 46,
 136 , 152 , 144 , 2 , 97 , 250 , 47 , 58 , 214 , 51 

array2: .word  1 , 1 , 0 , -1 , -1,
 0 , 1 , 0 , -1 , 0,
 0 , 0 , 1 , 0 , 0,
 0 , -1 , 0 , 1 , 0,
 -1 , -1 , 0 , 1 , 1 

start:
 LDR R0, =array1
 LDR R1, =array2
 MOV R2, #10 //iw
 MOV R3, #10 //ih
 MOV R4, #5  //kw
 MOV R5, #5  //kh
 MOV R6, #2  //ksw
 MOV R7, #2  //khw
 MOV R8, #0  //y
 MOV R9, #0  //x 
 MOV R10,#10 //i
 MOV R11,#11 //j
 MOV R12,#12 //sum or gx 
  
for_step:
 CMP R8, R2
 BLT for_x
 
end:
 B end
 
for_x:
  ADD R8, R8,#1
  CMP R9, R3
  BLT for_i
  ADD R9, R9,#1
  
for_i:
  CMP R10, R4
  BLT for_j
  ADD R10, R10,#1
  
for_j:
  CMP R11, R5
  BLT temp
  ADD R11,R11,#1

temp: 
  ADD R9, R9, R11
  SUB R9, R9, R6 //temp1 
  ADD R8, R8, R10 
  SUB R8, R8, R7 //temp2 
  CMP R8, #0
  
one: 
  CMP R8, #9
  BLT two 
  
two: 
  CMP R9, #0
  BGT three
  
three: 
  CMP R9, #9 
  BLT four 
  
four:
  MUL R8, R9, R8 //temp1*2
  MUL R8, R8, =array2 
  MUL R10, R10, R11 //j*i
  MUL R10, R10, =array1
  MUL R8, R8, R10 
  ADD R8, R8, R10
  ADD R12, R12, R8
  B laststep
 
 laststep: 
  MUL R8, R8, R9 //x*y 
  MUL R12, R12, R8
  B for_x

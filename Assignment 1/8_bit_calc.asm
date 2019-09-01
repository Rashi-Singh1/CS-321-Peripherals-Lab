cpu "8085.tbl"
hof "int8"
org 9000h

LDA 81FFH     ;Operation is loaded from 81FF memory location
CPI 01H
JZ ADD

CPI 02H
JZ SUB

CPI 03H
JZ MUL

CPI 04H
JZ DIV


;--------------------
;1st operand : 8200H
;2nd operand : 8201H
;Sum 		 : 8202H
;Carry       : 8203H
;--------------------
ADD:				
mvi C,00H
LDA 8200H     		;First operand loaded from memory
MOV B,A       		;moved to B
LDA 8201H     		;Next operand loaded
ADD B         		;B is added to accumulator
JNC STOREADD	  	;if there is a carry increment C
INR C
STOREADD:
STA 8202H     		;store sum in memory
MOV A,C 
STA 8203H     		;store carry
RST 5


;--------------------
;1st operand : 8200H
;2nd operand : 8201H
;Abs diff    : 8202H
;Sign        : 8203H
;--------------------
SUB:          ;mem 8201H - mem 8200H
MVI E,00H
LDA 8200H     ;First operand loaded from memory
MOV B,A       ;moved to B
LDA 8201H     ;Next operand loaded
CMP B         ;if B is smaller than A it will generate carry 1 otherwise 0
JNC LBL1        ;Jump to L1 if A is greater
INR E         ;otherwise make sign register 1
MOV C,A       ;Swap A and B
MOV A,B
MOV B,C
LBL1: 
SUB B         ;Subtract B from A
STA 8202H     ;Save answer in memory
MOV A,E
STA 8203H     ;store sign 1 is for negative and 0 for positive
RST 5


;--------------------
;1st operand : 8200H
;2nd operand : 8201H
;LOWER BITS  : 8202H
;HIGHER BITS : 8203H
;--------------------
MUL:
LDA 8200H        
MOV C,A 			
LDA 8201H     
MOV E,A       
MVI D,00H
LXI H,0000H
LABEL3: DAD D ;It will add data of DE pair(basically E as D is zero) to HL pair
DCR C         ;C times
JNZ LABEL3
SHLD 8202H    ;As C becomes zero store answer in HL to memory(8202 and 8203)
RST 5

;--------------------
;1st operand : 8200H
;2nd operand : 8201H
;Quotient    : 8202H
;Remainder   : 8203H
;--------------------
DIV:		;8201h divided by 8200h
mvi C,00H
LDA 8200H     ;First operand loaded from memory
MOV B,A       ;moved to B
LDA 8201H     ;Next operand loaded
LOOP: CMP B   ;If B is smaller we will keep on subtracting it from A
JC LABEL4
SUB B
INR C         ;This will be our quotient 
JMP LOOP
LABEL4: 
STA 8202H     ;In accumulator our remainder was saved so we put that in memory 
MOV A,C
STA 8203H     ;Quotient is saved in 8203
RST 5

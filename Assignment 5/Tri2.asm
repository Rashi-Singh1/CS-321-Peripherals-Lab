cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH
KBINT: EQU 3CH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

;;;;lower 2 bits then higher high two bits
MVI A,8BH
OUT 03H
OUT 43H

LXI H, 0AA05H
SHLD 8202H
CALL DIV16
CALL DIV8
JMP CHECK

Square:
XRA A
L11:
MVI A, 0FFH
OUT 00H
OUT 01H
OUT 40H
OUT 41H
CALL DELAY
MVI A,00H
OUT 00H
OUT 01H
OUT 40H
OUT 41H
CALL DELAY
JMP CHECK
JMP L11


Triangular:
XRA A
L21: 
OUT 00H  
OUT 01H  
OUT 40H  
OUT 41H  
INR A  
;JMP L21  
CMP C  
JNZ L21  
  
L22: 
OUT 00H
OUT 01H
OUT 40H
OUT 41H
DCR A
JNZ L22
JMP CHECK
JMP L21

Sawtooth:
XRA A
L31: 
OUT 00H
OUT 01H
OUT 40H
OUT 41H
INR A
CMP C
JNZ L31
JMP CHECK



Staircase:
;CALL LDIV2
INIT:
XRA A
L49: 
OUT 00H  
OUT 01H  
OUT 40H  
OUT 41H  
MOV B,A
CALL DELAY
MOV A,B
INR A  
INR A 
INR A
CPI 15H  
JNZ L49
JMP CHECK 
  

SymmetricalStaircase:
XRA A
;CALL LDIV2
L41: 
OUT 00H  
OUT 01H  
OUT 40H  
OUT 41H  
MOV B,A
CALL DELAY
MOV A,B
INR A  
INR A 
INR A
CPI 15H  
JNZ L41  
  
L42: 
OUT 00H
OUT 01H
OUT 40H
OUT 41H
MOV B,A
CALL DELAY
MOV A,B
DCR A
DCR A
DCR A
JNZ L42
JMP CHECK
JMP L41 




DELAY:						;delays machine by 1 second
	MVI C,03H
OUTLOOP:
	MOV D, H
	MOV E, L			
INLOOP:						;reapeatedly run inloop as many times as
	DCX D 					;frequency of microprocessor
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET


;--------------------
;1st operand : 8200H
;2nd operand : 8202H
;Remainder   : 8204H
;Quotient    : 8206H
;--------------------
DIV16:				;MEM 8202h DIVIDED BY MEM 8200h (second op/first op)
LXI B,0000H
LHLD 8200H        ;Load first no. from memory
XCHG              ;Copy HL pair to DE
LHLD 8202H        ;Load next no. 
LOOP2: MOV A,L    ;Subtract DE from HL till HL is greater tha DE
SUB E
MOV L,A
MOV A,H
SBB D
MOV H,A
JC LOOP1
INX B             ;increment BC pair(Quotient) 
JMP LOOP2
LOOP1: DAD D
SHLD 8204H        ;Store remainder in memory
MOV L,C
MOV H,B
SHLD 8206H        ;Store quotient

RET


;--------------------
;1st operand : 8200H
;2nd operand : 0FFH
;Quotient    : 8202H
;Remainder   : 8203H
;--------------------
DIV8:		;8201h divided by 8200h
mvi C,00H
LDA 8200H     ;First operand loaded from memory
MOV B,A       ;moved to B
MVI A,0FFH  ;Next operand loaded
LOOP: CMP B   ;If B is smaller we will keep on subtracting it from A
JC LABEL4
SUB B
INR C         ;This will be our quotient 
JMP LOOP
LABEL4: 
STA 8202H     ;In accumulator our remainder was saved so we put that in memory 
MOV A,C
STA 8203H     ;Quotient is saved in 8203
RET


;To check DIP switch
CHECK:
IN 01H
MOV B,A
ANI 01H
CPI 01H
JZ Square
MOV A,B
ANI 02H
CPI 02H
JZ Triangular
MOV A,B
ANI 04H
CPI 04H
JZ Sawtooth
MOV A,B
ANI 08H
CPI 08H
JZ Staircase
MOV A,B
ANI 10H
CPI 10H
JZ SymmetricalStaircase
MOV A,B
ANI 20H
CPI 20H
JZ Sine
JMP CHECK

Sine:
MVI A,00H
STA 8501H
MVI A,01H
STA 8502H
MVI A,02H
STA 8503H
MVI A,04H
STA 8504H
MVI A,08H
STA 8505H
MVI A,11H
STA 8506H
MVI A,17H
STA 8507H
MVI A,1EH
STA 8508H
MVI A,25H
STA 8509H
MVI A,2DH
STA 850AH
MVI A,36H
STA 850BH
MVI A,40H
STA 850CH
MVI A,49H
STA 850DH
MVI A,54H
STA 850EH
MVI A,5EH
STA 850FH
MVI A,69H
STA 8510H
MVI A,74H
STA 8511H
MVI A,7FH
STA 8512H
MVI A,84H
STA 8513H
MVI A,95H
STA 8514H
MVI A,9FH
STA 8515H
MVI A,0AFH
STA 8516H
MVI A,0B4H
STA 8517H
MVI A,0C0H
STA 8518H
MVI A,0C8H
STA 8519H
MVI A,0D0H
STA 851AH
MVI A,0D8H
STA 851BH
MVI A,0E0H
STA 851CH
MVI A,0EAH
STA 851DH
MVI A,0EDH
STA 851EH
MVI A,0EFH
STA 851FH
MVI A,0F2H
STA 8520H
MVI A,0F9H
STA 8521H
MVI A,0FCH
STA 8522H
MVI A,0FDH
STA 8523H
MVI A,0FFH
STA 8524H
MVI A,00H
STA 8525H

START:
MVI C,24H
LXI H,8501H
POS:
MOV A,M
OUT 00H
OUT 01H
OUT 40H
OUT 41H
INX H
DCR C
JNZ POS
MVI C,24H
NEG:
DCX H
MOV A,M
OUT 00H
OUT 01H
OUT 40H
OUT 41H
    DCR C
    JNZ NEG
    JMP START
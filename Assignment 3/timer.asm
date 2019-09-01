cpu "8085.tbl"
hof "int8"

org 9000h
GTHEX: EQU 030EH    		;Gets hex digits entered from keyboard and displays them
							;Parameters reg B=0 address field B=1 data field
HXDSP: EQU 034FH			;Expands hex digits for display
OUTPUT:EQU 0389H			;Outputs characters to display
							;Parameters reg A=0 address field A=1 data field
CLEAR: EQU 02BEH			;Clears the display
RDKBD: EQU 03BAH			;Reads keyboard and puts characters in reg A
KBINT: EQU 3CH		

UPDAD: EQU 0440H				;The contents of location CURAD are displayed in Address field.
CURAD: EQU 8FEFH				;Address of values displayed on Address field

CURDT: EQU 8FF1H				;Address of values displayed on Data field
UPDDT: EQU 044cH				;The contents of location CURDT are displayed in Data field.

MVI A,00H 					;next 12 instructions used to display inital message
MVI B,00H 					

;Display 'AS03' on start of program

LXI H,8840H
MVI M,0AH

LXI H,8841H
MVI M,05H

LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,0H

LXI H,8840H
CALL OUTPUT
CALL RDKBD
CALL CLEAR 					;clear the display

MVI A,00H
MVI B,00H
Call gthex 					;take input time from keyboard (format : MM-SS)
MOV H,D 					;store in H-L register
MOV L,E

MVI D,00H 					;D will  store value of hours

CHECK_SEC:					;check if sec in less than 60
MOV A,L
CPI 60H
JC CHECK_MIN
INR H
SUI 60H 					;else make sec = sec - 60 , increment minutes
MOV L,A

CHECK_MIN: 					;check if min < 60
MOV A,H
CPI 60H
JC SKIPCHECKS  
INR D
SUI 60H 					;else min = min - 60, hours = 1
MOV H,A

SKIPCHECKS: 				;initialize registers for display
MOV A,L
MOV L,H
MOV H,D
SHLD CURAD
JMP DEC_SEC
									
CHN_HR_MIN:					;start seconds counter from 59s if minute changes
	SHLD CURAD
	MVI A,59H
DEC_SEC:
    STA 8200H
    MVI A,0BH
    SIM						;check for interrupt
	EI						;enable interrupt if present, runs macro ISR?
	LDA 8200H
	STA CURDT				;update display
	CALL UPDAD
	CALL UPDDT
	CALL DELAY				;call delay which runs for 1 second
    
	LDA CURDT
	CPI 00H 				;check if seconds reach 0
	JZ MIN
	CALL SUBTRACT_BCD 				;bcd subtractor of seconds by 1
	JMP DEC_SEC
	MIN:
	LHLD CURAD
	MOV A,L
	CPI 00H 				;check if minute reach 0
	JZ HOUR					
	CALL SUBTRACT_BCD 				;if not 0,reduce minute by 1;
	MOV L,A
	JMP CHN_HR_MIN
	HOUR:					;check if hour reach 0
	MVI L,59H				
	MOV A,H
	CPI 00H  				
	JZ BREAK 				;stop timer if hour reaches 0
	CALL SUBTRACT_BCD
	MOV H,A
	JMP CHN_HR_MIN
BREAK:
	RST 5
DELAY:						;delays machine by 1 second
	MVI C,03H
OUTLOOP:
	LXI D,0AA05H			
INLOOP:						;reapeatedly run inloop as many times as
	DCX D 					;frequency of microprocessor
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET

ISR:  						;ISR to store values of program
	PUSH PSW
	CALL RDKBD 				;when another interrupt comes,restore original
	POP PSW					;values
	EI
	RET

SUBTRACT_BCD:						;bcd subtractor 
 STA 8202H
 ANI 0FH
 CPI 00H
 JZ SUBTRACT_HELPER
 LDA 8202H
 DCR A
 RET
 SUBTRACT_HELPER:
 LDA 8202H
 SBI 07H
 RET

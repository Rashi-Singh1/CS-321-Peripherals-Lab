cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH				;Gets hex digits entered from keyboard and displays them
								;Parameters reg B=0 address field B=1 data field
OUTPUT:EQU 0389H				;Outputs characters to display
								;Parameters reg A=0 address field A=1 data field
CLEAR: EQU 02BEH				;Clears the display
RDKBD: EQU 03BAH				;Reads keyboard and puts characters in reg A

UPDAD: EQU 0440H				;The contents of location CURAD are displayed in Address field.
CURAD: EQU 8FEFH				;Address of values displayed on Address field

CURDT: EQU 8FF1H				;Address of values displayed on Data field
UPDDT: EQU 044cH				;The contents of location CURDT are displayed in Data field.



MVI A,00H 						
MVI B,00H 						

;Display 'AS02' on start of program

LXI H,8840H
MVI M,0AH

LXI H,8841H
MVI M,05H

LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,02H

LXI H,8840H
CALL OUTPUT
CALL RDKBD
CALL CLEAR 						;clear the display

;H-Hours, L-Minutes, A-Seconds
MVI A,00H
MVI B,00H
CALL GTHEX 						;take input time from keyboard
								
MOV H,D 						;store in H-L register
MOV L,E

CHECKHOUR:						;check if hour <= 12
	MOV A,H
	CPI 12H
	JC CHECKMIN
SETHOUR:						;set hours to 0 if hours>=12
	MVI H,00H
	;JC SKIPCHECK
CHECKMIN:						;check if minute <= 60
	MOV A,L
	CPI 60H
	JC SKIPCHECK
SETMIN:
	MVI L,00H 					;set min to 0 if minutes>=60
SKIPCHECK:							
	

UPDATE_HOUR_MIN:				;start seconds counter from 0s
	SHLD CURAD					;store updated time into address of CURAD	
	MVI A,00H
NEXTSEC:
	STA CURDT
	CALL UPDAD					;update display of Address field
	CALL UPDDT 					;update display of Data field
	CALL DELAY					;call delay which runs for ~ 1 second
	LDA CURDT
	ADI 01H						;increment seconds by 1
	DAA 						;converts contents of A into 4-bit BCD
	CPI 60H 					;check if seconds reach 60
	JNZ NEXTSEC
	LHLD CURAD
	MOV A,L
	ADI 01H						;increment minutes by 1
	DAA
	MOV L,A
	CPI 60H 					;check if minutes reach 60
	JNZ UPDATE_HOUR_MIN
	MVI L,00H
	MOV A,H
	ADI 01H 					;increment hour by 1
	DAA
	MOV H,A
	CPI 12H						;check if hour reach 12
	JNZ UPDATE_HOUR_MIN
	LXI H,0000H
	JMP UPDATE_HOUR_MIN
	
DELAY: 							;delays machine by 1 second
	MVI C,03H
OUTLOOP:
	LXI D,0AA05H
INLOOP: 						;reapeatedly run inloop as many times as 43525 times
	DCX D 						;frequency of microprocessor = 3.072MHz
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET
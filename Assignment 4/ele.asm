cpu "8085.tbl"
hof "int8"

GTHEX: EQU 030EH
OUTPUT: EQU 0389H
HXDSP: EQU 034FH
RDKBD: EQU 03BAH
CLEAR: EQU 02BEH

org 9000h

;;;;;;Before you start the program;;;;
;This is a code for MPS 85-3 trainer to simulate a working elevator using LCI
;Connect LCI to J1 port
;The floors are represented by LEDs as follows - first floor = D8, second floor = D7, third floor = D6, and so on.
;It is assumed that all passengers want to reach ground floor, boss floor is given more priority
;The boss floor value has to be inserted into memory location 8200H before starting program as shown below
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LDA 8200h 				;Insert 8-bit value of boss floor in 8200H as follows.
						;1st floor - 80H  ;5th floor - 08H
						;2st floor - 40H  ;6th floor - 04H
						;3st floor - 20H  ;7th floor - 02H
						;4st floor - 10H  ;8th floor - 01H
MOV H,A
MVI A,8BH
OUT 03H

GROUND:
	MVI B,01H 			;reg B stores direction of movement, 01H = up, 00H = down.
	MVI A,00H 			;reg A stores value of current floor
	STA 8202H           ;Store current floor in 8202H to restart incase BOSS routine is called
	OUT 00H
	CALL DELAY          ;Delay of 2 sec 
	IN 01H
	ANA H 				;check if Boss Dip switch is High
	CMP H 
	JZ BOSS
	IN 01H
	CPI 00H 
	JZ GROUND 			;if Any DIP switch is high, go up (to first floor)
	JZ FIRST_FLR

FIRST_FLR:
	MVI A,01H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 01H 			;Stay on floor 1 till DIP switch 8 is high. 
						;This is because door of elevator has to be open till the button of that floor is pressed
	CPI 01H
	JZ FIRST_FLR
	IN 01H
	ANA H
	CMP H  				;Check if BOSS floor requested elevator
	JZ BOSS
	MOV A,B
	CPI 00H 			;if no other floor requests elevator, go to GROUND
	JZ GROUND
	IN 01H
	CPI 01H
	MVI B,00H
	JC GROUND
	JZ FIRST_FLR
	MVI B,01H 			;if not GROUND nor First, Go up


SEC_FLR:
	MVI A,02H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 02H
	CPI 02H
	JZ SEC_FLR 			;Stay on 2nd floor till DIP switch 7 is high
	IN 01H
	ANA H
	CMP H 				;Check if BOSS floor requested elevator 
	JZ BOSS
	MOV A,B
	CPI 00H  			;if Direction is DOWN go to FIRST_FLR
	JZ FIRST_FLR
	IN 01H
	CPI 02H
	MVI B,00H 			
	JC FIRST_FLR 		
	JZ SEC_FLR
	MVI B,01H 			;if LCI input>2 go to higher floor

THIRD_FLR:
	MVI A,04H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 04H
	CPI 04H
	JZ THIRD_FLR
	IN 01H
	ANA H
	CMP H 
	JZ BOSS
	MOV A,B
	CPI 00H 
	JZ SEC_FLR
	IN 01H
	CPI 04H
	MVI B,00H
	JC SEC_FLR
	JZ THIRD_FLR
	MVI B,01H 			;if LCI input>04H go to higher floor

FOURTH_FLR:
	MVI A,08H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 08H
	CPI 08H
	JZ FOURTH_FLR
	IN 01H
	ANA H
	CMP H 
	JZ BOSS
	MOV A,B
	CPI 00H 
	JZ THIRD_FLR
	IN 01H
	CPI 08H
	MVI B,00H
	JC THIRD_FLR
	JZ FOURTH_FLR
	MVI B,01H 			;if LCI input>08H go to higher floor

FIFTH_FLR:
	MVI A,10H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 10H
	CPI 10H
	JZ FIFTH_FLR
	IN 01H
	ANA H
	CMP H 
	JZ BOSS
	MOV A,B
	CPI 00H 
	JZ FOURTH_FLR
	IN 01H
	CPI 10H
	MVI B,00H
	JC FOURTH_FLR
	JZ FIFTH_FLR
	MVI B,01H 			;if LCI input>10H go to higher floor

SIX_FLR:
	MVI A,20H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 20H
	CPI 20H
	JZ SIX_FLR
	IN 01H
	ANA H
	CMP H 
	JZ BOSS
	MOV A,B
	CPI 00H 
	JZ FIFTH_FLR
	IN 01H
	CPI 20H
	MVI B,00H
	JC FIFTH_FLR
	JZ SIX_FLR
	MVI B,01H 			;if LCI input>20H go to higher floor

SEVEN_FLR:
	MVI A,40H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 40H
	CPI 40H
	JZ SEVEN_FLR
	IN 01H
	ANA H
	CMP H 
	JZ BOSS
	MOV A,B
	CPI 00H 
	JZ SIX_FLR
	IN 01H
	ANI 0C0H
	CPI 40H
	MVI B,00H
	JC SIX_FLR
	JZ SEVEN_FLR
	MVI B,01H 			;if LCI input>40H go to higher floor

EIGHT_FLR:
	MVI B, 00H
	MVI A,80H 
	STA 8202H
	OUT 00H
	CALL DELAY 
	IN 01H
	ANI 80H
	CPI 80H
	JZ EIGHT_FLR
	IN 01H
	ANA H
	CMP H 
	JZ BOSS
	IN 01H
	ANI 080H
	CPI 80H	
	JC SEVEN_FLR 			;if LCI input < 80H go to lower floor
	JZ EIGHT_FLR			;else stay on 8th

DELAY: 						;Runs 2 loops to create a delay of about 2 seconds
	MVI C,03H
OUTLOOP:
	LXI D,0AF00H
INLOOP:
	DCX D					;increase the D-E pair by one
	MOV A,D
	ORA E					;logical or with content of A
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET

BOSS:					
	LDA 8202H 			;Load value of current floor
	CMP H				;Compares BOSS floor with current floor
	JC UPBOSS			;If boss floor is higher than present location, goes to UPBOSS subroutine
	JZ STAY				;If boss is at same floor jumps to STAY subroutine
	JMP DOWNBOSS		;If boss floor is lower than present floor, jumps to DOWNBOSS subroutine
UPBOSS:
	LDA 8202H			
	CPI 00H
	JZ INCREMENT		;if BOSS is called from GROUND then A will have 00H, we increment it to 01H for RLC to work
	RLC					;logical left circular shift of A
	STA 8202H
RETURN:	OUT 00H
	CALL DELAY
	LDA 8202H
	CMP H
	JC UPBOSS
	JZ STAY 			;Jump to STAY when BOSS floor is reached
DOWNBOSS:				;changes elevator position to boss position by right rotation of A, then jumps to STAY
	LDA 8202H
	RRC
	STA 8202H
	OUT 00H
	CALL DELAY
	LDA 8202H
	CMP H
	JZ STAY
	JMP DOWNBOSS 	
STAY:					;waits for boss floor request to go low, then goes to BOSSGND subroutine
	IN 01H
	ANA H
	CMP H	
	JZ STAY
	CALL DELAY
BOSSGND:				;Takes elevator with boss in it to ground floor (GROUND)
	LDA 8202H
	RRC					;logical right roation of A
	STA 8202H
	OUT 00H
	CALL DELAY
	LDA 8202H
	CPI 01H
	JZ GROUND			;Jumps to GROUND subroutine after boss reaches GROUND
	JMP BOSSGND
INCREMENT:				;INCREMENTS location 8202H (for UPBOSS call from GROUND)
	ADI 01H
	STA 8202H
	JMP RETURN
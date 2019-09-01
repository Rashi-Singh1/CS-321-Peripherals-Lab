cpu "8085.tbl"
hof "int8"

org 9000h 

;;;;;;Before you start the program;;;;
;This is a code for MPS 85-3 trainer blink LEDs on output port cyclically
;Connect LCI to J1 port
;When D6 on input port is made low, output port blink one at a time in order D0,D1,D2....
;When D5 on input port is made low, program pauses
;When D6 on input port is made low, program commences again
;When D2 on input port is made low, program terminates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


MVI A,8BH 					;to configure to mode 0 which gives A - output, B - input, C - input
OUT 03H 					;to configure J1 8255 port on the board

START:	
	CALL SWITCH_2_CHECK   	;Check if 2nd dip switch is high, if high then terminate.
	IN 01H					;takes dip switch input
	ANI 004H   				;to extract 6th bit from left
	CPI 04H 				;to check if D6 is on
	JNZ DISPLAY_NEXT        ;Check if 6th switch is high, if yes increment count else repeat.
	JMP START
	RST 5


DISPLAY_NEXT:
	MVI A,01H       		;This label calls a delay of one second and displays the next output
	OUT 00H         		;During every delay is checks for the 5th and 2nd switch
	CALL DELAY
	MVI A,02H
	OUT 00H
	CALL DELAY
	MVI A,04H
	OUT 00H
	CALL DELAY
	MVI A,08H
	OUT 00H
	CALL DELAY
	MVI A,10H
	OUT 00H
	CALL DELAY
	MVI A,20H
	OUT 00H
	CALL DELAY
	MVI A,40H
	OUT 00H
	CALL DELAY
	MVI A,80H
	OUT 00H
	CALL DELAY
	JMP DISPLAY_NEXT


SWITCH_2_CHECK:
	IN 01H          			;This label checks for the 2nd switch to terminate the program
	ANI 040H
	CPI 40H
	JNZ TERMINATE
	RET


DELAY:

CALL PAUSECOND
CALL SWITCH_2_CHECK

MVI C,03H

OUTLOOP:
	LXI D,0A604H

INLOOP:							;Delays the machine by almost 2 seconds
	DCX D 
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET


TERMINATE:
	MVI A, 00H 						;To terminate the program
	OUT 00H
	RST 5


PAUSECOND:							;Pause condition
	CALL SWITCH_2_CHECK
	IN 01H
	MOV D,A
	ANI 008H
	CPI 08H
	JZ BEG
	MOV A,D
	RET

BEG:								;Recur pause condition until D6 is low again
	
	IN 01H
	MOV D,A
	ANI 004H
	CPI 04H
	JZ BEG
	MOV A,D
	RET

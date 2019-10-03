cpu "8085.tbl"
hof "int8"
org 9000h
RDKBD: EQU 03BAH

; 0816 16 channel ADC connected to J2 Port(8255) of trainer
; Stepper motor connected to J1 Port of trainer

MVI A,8BH                ; Configure 8255 to mode 0
OUT 43H 				 ; Port A - O/P , Port B & Port C - I/P

MVI A,80H 				 ; All ports are O/P
OUT 03H

MVI A,00H
STA 8200H				; Memory address for clockwise rotation

MVI A,00H
STA 8201H				; Memory address for anti-clockwise rotation

START:

	MVI D,00H 				 ; Initialize channel to 0000
	MVI E,00H
	CALL CONVERT 			 ; Converting analog to digital
	STA 8501H
	CALL DELAY

	LDA 8501H

	CALL DISPLAY			 ; Displaying the converted value on data field


	LDA 8501H   			 ; Storing the values to the memory address
	STA 8200H				 ; According to the required rotation
	LDA 8501H
	STA 8201H

MVI A,88H				 ;Initial bit pattern

LOOP:
PUSH PSW    			 ; Saving the program state
OUT 00H
LDA 8200H     			 ; Rotate the motor for number of steps stored in 8200.
CPI 00H 				 ; If number of left rotation steps is zero jump to stop
JZ STOP
LDA 8200H
DCR A 					 ; Decreasing the number of steps left for rotation
STA 8200H
LDA 8200H   
JZ STOP 
CALL DELAY
POP PSW 				
RRC						 ; Command to take rotation steps in clockwise direction
JMP LOOP

STOP: 
CALL RDKBD

MVI A,88H 			 	; Initial bit pattern
LOOP2:
PUSH PSW 				; Saving the program state
OUT 00H
LDA 8201H 				; Rotote the motor shaft in anti-clockwise direction similar to above procedure
CPI 00H
JZ START
LDA 8201H
DCR A
STA 8201H
LDA 8201H
JZ START   
CALL DELAY
POP PSW
RLC			
JMP LOOP2
JMP START


DELAY:    				; Creating a delay for each step
	MVI C,03H
OUTLOOP:
	LXI D,00FFH
INLOOP:  	
	DCX D
	MOV A,D
	ORA E
	JNZ INLOOP
	DCR C
	JNZ OUTLOOP
	RET



CONVERT:                
	MVI A,00H 			; intilaize channel
	ORA D 				; add the channel no.
	OUT 40H

	; START SIGNAL
	MVI A,20H			; assert for start signal
	ORA D 				; for A to D conversion
	OUT 40H
	
	NOP
	NOP
	
	; START PULSE OVER
	MVI A,00H      		; start pulse over
	ORA D
	OUT 40H


WAIT1:	
	IN 42H				; check EOC
	ANI 01H
	JNZ WAIT1 			; check until EOC goes down
WAIT2:
	IN 42H				; check EOC
	ANI 01H
	JZ WAIT2			; wait until EOC goes up



; READ SIGNAL
	MVI A,40H
	ORA D
	OUT 40H
	NOP

	IN 41H				; GET THE CONVERTED DATA FROM PORT B

	PUSH PSW			; SAVE A SO THAT WE CAN DEASSERT THE SIGNAL

	MVI A,00H 			; DEASSERT READ SIGNAL 
	ORA D
	OUT 40H
	POP PSW

RET

DISPLAY:
		call DELAY 		
		LDA 8501H
		PUSH PSW		; save the digital value


DISPKBD:
		MOV A,E 		; channel number i sstored in LS byte of ad. field
		STA 8FEFH
		XRA A 			; zero is stored in M.S byte of ad. field
		STA 8FF0H
		POP PSW			; digital value is stored in data field
		STA 8FF1H
		PUSH D 			; save reg D and E.
		MVI B,00H
		CALL 0440H 		; display without dot the ad. field
		MVI B,00H
		CALL 0440H 		; display without dot the data field
		MVI B,00
		CALL 044CH 		; get back reg D and E.
		POP D
		RET
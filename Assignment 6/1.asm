cpu "8085.tbl"
hof "int8"
org 9000h

; 0816 16 channel ADC connected to J2 Port(8255) of trainer
; Stepper motor connected to J1 Port of trainer

MVI A,8BH                ; Configure 8255 to mode 0
OUT 43H 				 ; Port A - O/P , Port B & Port C - I/P

MVI A,80H 				 ; All ports are O/P
OUT 03H


MVI A,88H
LOOP:
PUSH PSW                 ; saving the state
OUT 00H
MVI D,00H                ; initialize channel to 0000
MVI E,00H
CALL CONVERT             ; converting analog to digital
STA 8201H 				 ; Storing the converted value at address 8201H
MOV B,A 			
MVI A,0FFH				 ; subtracting the value from FF and running the delay loop for the new number of times.
SUB B
MOV C,A 				 ; Storing the subtracted result in C
STA 8200H				 ; 8200H contains the subtracted value ... (more the digital value, lesser the value of A)
CALL DELAY 				 ; for a larger voltage value, delay has to be small and vice-versa.

MVI D,00H
MVI E,00H   			 ; initialize channel to 0000
MVI A,32H
MVI C,04H
STA 8200H
LDA 8201H				 

CALL DISPLAY             ; displaying the converted value on data field
POP PSW
RRC						 ; to rotate the shaft clockwise
JMP LOOP


DELAY:                   ; delaying the whole process by square of value of number stored at 8200.
	LOOP4a:  MVI D,01H
	LOOP1a: LDA 8200H  
	MOV E, A
	LOOP2a:  DCR E
	    JNZ LOOP2a
	    DCR D
	    JNZ LOOP1a
	    DCR C
	    JNZ LOOP4a
RET



CONVERT:                
	MVI A,00H 			; Initialize channel
	ORA D 				; add the channel no.
	OUT 40H 			; Set the channel for conversion

	; START SIGNAL
	MVI A,20H			; assert for start signal
	ORA D 				; for A to D conversion
	OUT 40H
	
	NOP
	NOP
	
; START SIGNAL
	MVI A,00H      		; START pulse over
	ORA D
	OUT 40H


WAIT1:	
	IN 42H				; check EOC
	ANI 01H
	JNZ WAIT1 			; Wait until EOC goes down
WAIT2:
	IN 42H				; check EOC
	ANI 01H
	JZ WAIT2			; wait until EOC goes up



; READ SIGNAL
	MVI A,40H 			; Assert READ signal
	ORA D
	OUT 40H
	NOP

	IN 41H				; GET THE CONVERTED DATA FROM PORT B

	PUSH PSW			; SAVE STATUS SO THAT WE CAN DEASSERT THE SIGNAL

	MVI A,00H 			; Deassert the READ signal
	ORA D
	OUT 40H
	POP PSW 			; Restore the digital equivalent

RET

DISPLAY:
		CALL DELAY 		
		LDA 8201H 		; Load the converted digital value in A
		PUSH PSW		; save the digital value


DISPKBD:
		MOV A,E 		; Channel number i sstored in LS byte of ad. field
		STA 8FEFH
		XRA A 			; Zero is stored in M.S byte of ad. field
		STA 8FF0H
		POP PSW			; Digital value is stored in data field
		STA 8FF1H
		PUSH D 			; Save reg D and E.
		MVI B,00H
		CALL 0440H 		; Display without dot the ad. field
		MVI B,00H
		CALL 0440H 		; Display without dot the data field
		MVI B,00
		CALL 044CH 		; Get back reg D and E.
		POP D
		RET
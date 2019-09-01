
	CS 321 : Computer Peripherals and Interfacing Lab

			Assignment - 4
		
			  Group 10

	1. Rashi Singh   - 170101052
	2. Soumik Paul   - 170101066
	3. Aniket Rajput - 170101007
	4. Aayush Patni  - 170101001

Steps to configure kit and run the program:

1. Download the .asm files for Part A and Part B (ele.asm) from here : https://drive.google.com/open?id=1knGxhBbNY6vPNR-NRQEM4PqDYEmpoZnt
2. Copy them to the directory esa-xt85 in your local machine.
3. Use command "c16 -h led2.hex -l led2.lst led2.asm" for Part A 
   and "c16 -h ele.hex -l ele.lst ele.asm" for Part B in command prompt
4. Switch no. 4 should be turned to serial mode.
5. Download one hex file at a time into the kit using xt85.exe.
6. Switch no. 4 should be turned back to initial position.
7. Connect the LCI to port J1 (8255 port)

Part A
1. Switch D2 to high before executing program.
2. Press 'Go' and enter 9000 in the address field and then press 'Exec'.
3. Lower the D5 switch to pause the program.
4. Lower the D6 switch to resume the program.
5. Lower the D2 switch to terminate the program.

Part B
1. Enter the BOSS floor in 8200H according to the following:-
	1.1 1st floor - 80H  ;5th floor - 08H
	1.2 2st floor - 40H  ;6th floor - 04H
	1.3 3st floor - 20H  ;7th floor - 02H
	1.4 4st floor - 10H  ;8th floor - 01H
2. Press 'Go' and enter 9000 in the address field and then press 'Exec'.
3. Elevator will be called to the floor whose dip switch is high.
4. BOSS floor will be given priority and serviced accordingly.
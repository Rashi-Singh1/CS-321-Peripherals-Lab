
	CS 321 : Computer Peripherals and Interfacing Lab

			Assignment - 2
		
			  Group 10

	1. Rashi Singh   - 170101052
	2. Soumik Paul   - 170101066
	3. Aniket Rajput - 170101007
	4. Aayush Patni  - 170101001

Steps to configure kit and run the program:

1. Download the .asm files for 12hr and 24hr clocks from here : https://drive.google.com/open?id=1HMhVIyB89hfPhqhys2hMQFx61JQTU4CI
2. Copy them to the directory esa-xt85 in your local machine.
3. Use command "c16 -h 12hr.hex -l 12hr.lst 12hr.asm" for 12hr clock 
   and "c16 -h 24hr.hex -l 24hr.lst 24hr.asm" for 24hr clock with alarm in command prompt
4. Switch no. 4 should be turned to serial mode.
5. Download one hex file at a time into the kit using xt85.exe.
6. Switch no. 4 should be turned back to initial position.



Steps for operating kit with 12hr.asm loaded:
1. Run the program by pressing Go key and enter value 9000H (start address of program), then press Exec Key.
2. Upon execution, the message 'AS02' will be displayed on address field.
3. Press 0 key two times and enter current (start) time in the format HH:MM (will be displayed in address fields).
4. Press 'Next' key to start time.



Steps for operating kit with 24hr.asm loaded:

1. Use 'Exam Mem' key to insert input data as following
   1.1. Insert alarm time in memory location "8844H"
	- HH (hours) in 8844H
	- MM (minutes) in 8845H

2. Press Reset key
3. Run the program by pressing Go key and enter value 9000H (start address of program), then press Exec Key.
2. Upon execution, the message 'AS02' will be displayed on address field.
3. Press 0 key two times and enter current (start) time in the format HH:MM (will be displayed in address fields).
4. Press 'Next' key to start time.
5. When current time (time displayed) is equal to alarm time (stores in 8844H), the message 'AS02' will be displayed for 7 seconds and then current time will resume from (alarm + 7 seconds).
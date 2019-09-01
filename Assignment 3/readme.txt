CS 321 : Computer Peripherals and Interfacing Lab

			Assignment - 3
		
			  Group 10

	1. Rashi Singh   - 170101052
	2. Soumik Paul   - 170101066
	3. Aniket Rajput - 170101007
	4. Aayush Patni  - 170101001

Steps to configure kit and run the program:

1. Download the .asm file for timer from here : https://drive.google.com/open?id=1F6STePaRxwzFfdQzVliiDNZq6wqJqGk0
2. Copy it to the directory esa-xt85 in your local machine.
3. Use command "c16 -h timer.hex -l timer.lst timer.asm" in command prompt
4. Switch no. 4 should be turned to serial mode.
5. Download the hex file into the kit using xt85.exe.
6. Switch no. 4 should be turned back to initial position.

Steps for operating kit with timer loaded:

1. Use 'Exam Mem' key to insert location of our Interrupt Service Routine which can be found from the "timer.lst" file, as following:
   1.1 Exam memory location 8fbf to see that it has data C3 in it.
   1.2 Go to next memory location and insert the last two digits of the memory address of ISR.
   1.3 Go to next memory location and insert the first two digits of the memory address of ISR.

2. Press Reset key.
3. Run the program by pressing Go key and enter value 9000H (start address of program), then press Exec Key.
4. The Welcome message AS03 will be displayed on the adrress fields. 
5. Next enter 00 and then enter the time in MM:SS format.
6. Then press Next key to start the countdown.
7. To pause the timer press the KBINT key. This will pause the timer until the ISR is completed.
8. To start the timer again enter 0 key 2 times. This will start the timer from the same time when it was stopped.		
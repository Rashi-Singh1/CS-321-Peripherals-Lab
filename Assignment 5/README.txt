
	CS 321 : Computer Peripherals and Interfacing Lab

			Assignment - 5
		
			  Group 10

	1. Rashi Singh   - 170101052
	2. Soumik Paul   - 170101066
	3. Aniket Rajput - 170101007
	4. Aayush Patni  - 170101001

Steps to configure kit and run the program:

1. Download the .asm file Tri2.asm from here : https://drive.google.com/open?id=1wN9nRjVRc3hLHqXXH2E_cGHcwS-qDjpf
2. Copy them to the directory esa-xt85 in your local machine.
3. Use command "c16 -h Tri2.hex -l Tri2.lst Tri2.asm" in command prompt
4. Switch no. 4 should be turned to serial mode.
5. Download the hex file into the kit using xt85.exe.
6. Switch no. 4 should be turned back to initial position.
7. Connect the LCI to port J1 (8255 port)
8. Connect the DAC to port J2
9. Connect the CRO to DAC in channel 1

Steps for generating the waveforms on CRO:

1. Enter the required frequency of the waveform in memory locations 8200(lower bits) and 8201 (higher bits).
2. Switch D8 to high to generate square waveform.
3. Switch D7 to high to generate triangular waveform.
4. Switch D6 to high to generate sawtooth waveform.
5. Switch D5 to high to generate staircase waveform.
6. Switch D4 to high to generate symmetrical staircase waveform.
7. Switch D3 to high to generate sinusoidal waveform.

Note: If multiple switches are high, switch with higher index will generate the waveform.
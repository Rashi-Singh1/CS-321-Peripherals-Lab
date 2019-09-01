
	CS 321 : Computer Peripherals and Interfacing Lab

			Assignment - 1
		
			  Group 10

	1. Rashi Singh   - 170101052
	2. Soumik Paul   - 170101066
	3. Aniket Rajput - 170101007
	4. Aayush Patni  - 170101001

Steps to configure kit and run the program:

1. Download the .asm files for 8-bit and 16-bit calculator from here : https://drive.google.com/open?id=1PRsuGDsZ8ItLcIMHjSpp1zIjpg9fLxJL
2. Copy them to the directory esa-xt85 in your local machine.
3. Use command "c16 -h 8_bit_calc.hex -l 8_bit_calc.lst 8_bit_calc.asm" for 8-bit calculator 
   and "c16 -h 16_bit_calc.hex -l 16_bit_calc.lst 16_bit_calc.asm" in command prompt
4. Switch no. 4 should be turned to serial mode.
5. Download one hex file at a time into the kit using xt85.exe.
6. Switch no. 4 should be turned back to initial position.



Steps for operating kit with 8-bit calculator loaded:

1. Use 'Exam Mem' key to insert input data as following
   1.1. Insert operation code in memory location "81FFH"
	- 01H for ADD
	- 02H for SUB
	- 03H for MUL
	- 04H for DIV
   1.2. Insert first operand (8-bit) in memory loaction 8200H
   1.3. Insert second operand (8-bit) in memory loaction 8201H

2. Press Reset key
3. Run the program by pressing Go key and enter value 9000H (start address of program), then press Exec Key.
4. Now examine memory loactions (using Exam Mem key) 8202H and 8203H for outputs.
   Note : The different outputs for different operations are mentioned in comments in the .asm files 



Steps for operating kit with 16-bit calculator loaded:

1. Use 'Exam Mem' key to insert input data as following
   1.1. Insert operation code in memory location "81FFH"
	- 01H for ADD
	- 02H for SUB
	- 03H for MUL
	- 04H for DIV
   1.2. Insert first operand (16-bit) in memory loaction 8200H (higher order bits in 8201H)
   1.3. Insert second operand (16-bit) in memory loaction 8202H (higher order bits in 8203H)

2. Press Reset key
3. Run the program by pressing Go key and enter value 9000H (start address of program), then press Exec Key.
4. Now examine memory loactions (using Exam Mem key) 8204H and 8206H for outputs.
   Note : The different outputs for different operations are mentioned in comments in the .asm files 
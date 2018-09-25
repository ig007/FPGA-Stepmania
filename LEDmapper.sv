module LEDmapper(totalscore, LED1, LED2, LED3, LED4, redarray, greenarray);

	//The code was written in terms of one column of LEDs, for simplicity
	//This module will map this information about the four LED columns into the rows of a 2d red-light array and a 2d green-light array
	
	input logic [7:0] LED1, LED2, LED3, LED4;
	input logic [7:0] totalscore;
	output logic [7:0] [7:0] redarray, greenarray;

	//The matrix was wired such that LEDx[7:0] is one column of the matrix, with MSB on the bottom and LSB on the top.
	//Thus, the LED1/2/3/4 columns must be split up to be entered to the rows of each matrix

		always_comb begin 
		if (totalscore != 8'd255) begin
			 redarray[0] = {LED1[0], 1'b0, LED2[0],  1'b0,  1'b0, LED3[0], 1'b0, LED4[0]};
			 redarray[1] = 8'b0;
			 redarray[2] = {LED1[2], 1'b0, LED2[2], 1'b0,  1'b0, LED3[2], 1'b0, LED4[2]};
			 redarray[3] = {LED1[3], 1'b0, LED2[3],  1'b0,  1'b0, LED3[3], 1'b0, LED4[3]};
			 redarray[4] = {LED1[4], 1'b0, LED2[4],  1'b0,  1'b0, LED3[4], 1'b0, LED4[4]};
			 redarray[5] = {LED1[5], 1'b0, LED2[5],  1'b0,  1'b0, LED3[5], 1'b0, LED4[5]};
			 redarray[6] = {LED1[6], 1'b0, LED2[6],  1'b0,  1'b0, LED3[6], 1'b0, LED4[6]};
			 redarray[7] = {LED1[7], 1'b0, LED2[7],  1'b0,  1'b0, LED3[7], 1'b0, LED4[7]};
			
			//{LED1[1], 1'b0, LED2[1], 1'b0, 1'b0, LED3[1], 1'b0, LED4[1]}
			 greenarray[0] = 8'b0;
			  greenarray[1] = {LED1[1],1'b0, LED2[1], 1'b0, 1'b0, LED3[1], 1'b0, LED4[1]};
			  greenarray[2] = 8'b0;
			  greenarray[3] = 8'b0;
			  greenarray[4] = 8'b0;
			  greenarray[5] = 8'b0;
			  greenarray[6] = 8'b0;
			  greenarray[7] = 8'b0;
		end
		
		else  begin
		
		// When the user reaches 255 points a smiley face is displayed on the matrix
		
			  redarray[0] = 8'b00000000;
			  redarray[1] = 8'b00000000;
			  redarray[2] = {1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0};
			  redarray[3] = 8'b0000000;
			  redarray[4] = {1'b0, 1'b1, 4'h0, 1'b1, 1'b0};
			  redarray[5] = {2'b00, 4'hf, 2'b00};
			  redarray[6] = 8'b00000000;
			  redarray[7] = 8'b00000000;
			
			  greenarray[0] = {4'hf, 4'hf};
			  greenarray[1] = {1'b1, 6'b000000, 1'b1};
			  greenarray[2] = {1'b1, 6'b000000, 1'b1};
			  greenarray[3] = {1'b1, 6'b000000, 1'b1};
			  greenarray[4] = {1'b1, 6'b000000, 1'b1};
			  greenarray[5] = {1'b1, 6'b000000, 1'b1};
			  greenarray[6] = {1'b1, 6'b000000, 1'b1};
			  greenarray[7] = {4'hf, 4'hf};
		end
			
	end
	
			
endmodule 

module LEDmapper_testbench;
	
	logic clk;
	logic [7:0] totalscore, LED1, LED2, LED3, LED4;
	logic [7:0] [7:0] redarray, greenarray;
	
	LEDmapper dut (totalscore, LED1, LED2, LED3, LED4, redarray, greenarray);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	//set up inputs to design
	//Testing each possible input
	initial begin
																														 
			totalscore <= 8'd55; LED1 <= 8'b0010010; LED2 <=8'b0; LED3 <= 8'b0; LED4 <= 8'b0; @(posedge clk);
																														 @(posedge clk);
																  LED2 <=8'b01010100;							@(posedge clk);
																																					 @(posedge clk);
																					LED3 <= 8'b10000010;										@(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);
																										LED4 <= 8'b11111111;					@(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);
		totalscore <= 8'd255;																												 @(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);
																																					 @(posedge clk);

														
										
		$stop; //End the simulation
	end
endmodule 
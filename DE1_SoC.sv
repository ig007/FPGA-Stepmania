module DE1_SoC(CLOCK_50, reset, key0, key1, key2, key3, hex2, hex1, hex0, red_driver, green_driver, row_sink);

	//~key0 is for column 4
	//~key1 is for column 3
	//~key2 is for column 2
	//~key3 is for column 1
	input logic CLOCK_50, reset, key0, key1, key2, key3;
	
	//hex2 is for hundreds place, hex1 is for tens, hex0 is for ones.
	output logic [6:0] hex2, hex1, hex0;

	output logic [7:0] red_driver, green_driver, row_sink;
	
	//input 1-4 is the pulsed, inverted key input that will be actually used
	//start 1-4 is what enables a row to start lighting up
	logic input1, input2, input3, input4, start1, start2, start3, start4, offEdge1, offEdge2, offEdge3, offEdge4;
	logic [7:0] totalscore = 0;

	logic [7:0] [7:0] redarray, greenarray;
	logic [7:0] LED1, LED2, LED3, LED4;
	
	//Map all LED location information into two 2D arrays
	LEDmapper mapme (totalscore, LED1, LED2, LED3, LED4, redarray, greenarray);

		//Using a divided clock for the whole system
	logic [31:0] clk;
	parameter whichClock = 17; 
	clock_divider cdiv(CLOCK_50, clk);

	//DRIVER
	led_matrix_driver leddriver(clk[16], redarray, greenarray, red_driver, green_driver, row_sink);
	
	//call inputPulse to turn the user's input to a pulse and output the ACTUAL INPUT
	inputPulse in1(clk[whichClock], reset, ~key3, input1); //press for row 1
	inputPulse in2(clk[whichClock], reset, ~key2, input2); //press for row 2
	inputPulse in3(clk[whichClock], reset, ~key1, input3); //press for row 3
	inputPulse in4(clk[whichClock], reset, ~key0, input4); //press for row 4

	//call LFSR to get a random value
	logic [32:0] random;
	LFSR randomprompts(clk[whichClock], random); 
	
	//Then output the random 'start' values
	promptEnable clocks(clk[whichClock], reset, random, start1, start2, start3, start4);
	
	logic stop; //stop is when score reaches max value.
	
	assign stop = (totalscore >= 8'd255);

	//lightRow controls shifting of lights in each column 
	lightRow column1 (clk[whichClock], reset, start1, input1, stop, LED1, offEdge1); 
	lightRow column2 (clk[whichClock], reset, start2, input2, stop, LED2, offEdge2);
	lightRow column3 (clk[whichClock], reset, start3, input3, stop, LED3, offEdge3);
	lightRow column4 (clk[whichClock], reset, start4, input4, stop, LED4, offEdge4);
	
	logic [7:0] score1, score2, score3, score4;
	
	//victory outputs each score change that needs to occur once a score-changing event has occured
	victory column1event (clk[whichClock], reset, input1, LED1, offEdge1, totalscore, score1);
	victory column2event (clk[whichClock], reset, input2, LED2, offEdge2, totalscore, score2);
	victory column3event (clk[whichClock], reset, input3, LED3, offEdge3, totalscore, score3);
	victory column4event (clk[whichClock], reset, input4, LED4, offEdge4, totalscore, score4);
	
	//Calculating the total score
	
	always_ff @(posedge clk[whichClock]) begin
		if (reset)
			totalscore <= 0;
			
		//To keep the score from bugging if the 'score' outputs are more negative than the actual score
		else if ((totalscore < 8'd10) & (totalscore + score1 + score2 + score3 + score4 >= 8'd17))
			totalscore <= 0;
		
		//To keep the score from going too high and truncating to 0 if the 'score' outputs are too large
		else if((totalscore >= 247) & (score1 + score2 + score3 + score4 >= 255 - totalscore))
			totalscore <= 8'd255;
			
		else 
			totalscore = totalscore + score1 + score2 + score3 + score4;
	end

//call scoreDisplay with score input to display the score
	scoreDisplay showed(clk[whichClock], reset, totalscore, hex2, hex1, hex0);

endmodule 


module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;
	
	initial begin
		divided_clocks <= 0;
	end
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule 



module DE1_SoC_testbench;
	
	//CLOCK_50, reset, key0, key1, key2, key3, hex2, hex1, hex0, red_driver, green_driver, row_sink
	logic clk, reset, key0, key1, key2, key3;
	logic [6:0] hex2, hex1, hex0;
	logic [7:0] red_driver, green_driver, row_sink;
	
	DE1_SoC dut (clk, reset, ~key0, ~key1, ~key2, ~key3, hex2, hex1, hex0, red_driver, green_driver, row_sink);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	//set up inputs to design
	//Testing each possible input
	initial begin
			reset <= 0; key0<=0; key1<=0; key2<=0; key3<=0;		@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
								key1 <= 1;key2<=1; key3<=1; key0<=1;@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
								key1 <= 0;									@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
			reset <= 1;														@(posedge clk);
			reset <= 0;														@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
																				@(posedge clk);
														

														
										
		$stop; //End the simulation
	end
endmodule 
module scoreDisplay(clk, reset, totalscore, hexhundreds, hextens, hexones);
	
	//This module is responsible for outputting the user's score on the hex display
	
	input logic clk, reset;
	input logic [7:0] totalscore;
	
	//one hex responsible for the hundreds place, one for the tens place, one for the ones place of the score
	output logic [6:0] hexhundreds, hextens, hexones;
	
	logic [3:0] tens, ones, hundreds;
	
	always_comb begin
	
		//Tens, hundreds, and ones are separated from the total score, which will result in a 4-bit value of 0 - 9
		
		hundreds = (totalscore - (tens*10) - ones) / 100; 
		tens = ((totalscore %100) - ones) /10;
		ones = totalscore % 10;
	end
	
	always @(posedge clk) begin
	
		//relating hex output is assigned based on the value of that piece of the score
		
		
		if (reset) begin
			hexhundreds = 7'b1000000;
			hextens = 7'b1000000;
			hexones = 7'b1000000; end
		else begin
		
			case (hundreds)
				0: hexhundreds = 7'b1000000; //0
				1: hexhundreds = 7'b1111001; //1
				2: hexhundreds = 7'b0100100; //2
				3: hexhundreds = 7'b0110000; //3
				4: hexhundreds = 7'b0011001; //4
				5: hexhundreds = 7'b0010010; //5
				6: hexhundreds = 7'b0000010; //6
				7: hexhundreds = 7'b1111000; //7
				8: hexhundreds = 7'b0000000; //8
				9: hexhundreds = 7'b0010000; //9
			endcase
			
			case (tens)
				0: hextens = 7'b1000000; //0
				1: hextens = 7'b1111001; //1
				2: hextens = 7'b0100100; //2
				3: hextens = 7'b0110000; //3
				4: hextens = 7'b0011001; //4
				5: hextens = 7'b0010010; //5
				6: hextens = 7'b0000010; //6
				7: hextens = 7'b1111000; //7
				8: hextens = 7'b0000000; //8
				9: hextens = 7'b0010000; //9
			endcase
			
			case(ones)
				0: hexones = 7'b1000000; //0
				1: hexones = 7'b1111001; //1
				2: hexones = 7'b0100100; //2
				3: hexones = 7'b0110000; //3
				4: hexones = 7'b0011001; //4
				5: hexones = 7'b0010010; //5
				6: hexones = 7'b0000010; //6
				7: hexones = 7'b1111000; //7
				8: hexones = 7'b0000000; //8
				9: hexones = 7'b0010000; //9
			endcase
		end
	end
	
endmodule 

module scoreDisplay_testbench();
	logic clk, reset;
	logic [7:0] totalscore;
	logic [6:0] hexsign, hextens, hexones;
	
	scoreDisplay dut (clk, reset, totalscore, hexsign, hextens, hexones);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		
		reset <= 0;	totalscore <= 8'b0;				@(posedge clk);
														@(posedge clk);
						totalscore <= 8'b01000010;		@(posedge clk);
														@(posedge clk);
						totalscore <= 8'b10000110;		@(posedge clk);
						totalscore <= 8'b00001010;		@(posedge clk);
														@(posedge clk);
						totalscore <= 8'b01100001;		@(posedge clk);
														@(posedge clk);
						totalscore <= 8'b11111111;		@(posedge clk);
		reset <= 1;									@(posedge clk);	
														@(posedge clk);
						totalscore <= 8'b11010010;		@(posedge clk);
														@(posedge clk);
		reset <= 0;	totalscore <= 8'b00000100;		@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
		
		$stop;
	end
endmodule 	
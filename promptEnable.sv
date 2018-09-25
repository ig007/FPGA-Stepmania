module promptEnable(clk, reset, random, start1, start2, start3, start4);
	
	//This module will use a 33-bit random number to decide which columns will initiate lighting up. 
	//Because having multiple initiated columns close together is confusing, I chose to initiate once every 48th clock cycle
	//Which is also once every time the lights shift three times
	
	input logic clk, reset;
	input logic [32:0] random;
	output logic start1, start2, start3, start4;
	
	//This creates a counter that cycles through 0 - 47
	logic [5:0] counter = 0;
	
	always_ff @(posedge clk) begin
		if (reset) 
			counter <= 0;
		else 
			counter <= counter + 1;
	end
	
	
	//At the 48th cycle, four arbitrary bits from the 33-bit number are chosen (one for initiating each row)
	//Otherwise, the rows should not be initiated
	
	always_ff @(posedge clk) begin
		if (counter == 6'b111110) begin
			start1 <= random[0];
			start2 <= random[28];
			start3 <= random[1];
			start4 <= random[4];
		end
		else begin
			start1 <= 0;
			start2 <= 0;
			start3 <= 0;
			start4 <= 0;
		end
	end

endmodule 

//promptEnable(clk, reset, random, start1, start2, start3, start4)
module promptEnable_testbench();
	logic clk, reset;
	logic [32:0] random;
	logic start1, start2, start3, start4;
	
	promptEnable dut (clk, reset, random, start1, start2, start3, start4);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		
		reset <= 0; random <= 33'b111111111111111111111111111111111;	@(posedge clk);
													@(posedge clk);
													@(posedge clk);
		reset <= 1;								@(posedge clk);
													@(posedge clk);
		reset <= 0;								@(posedge clk);
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

		$stop;
	end
	
endmodule 
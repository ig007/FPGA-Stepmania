module lightRow(clk, reset, start, userInput, stop, lightOn, offEdge);

	//Here, stop refers to score being 255
	input logic clk, reset, start, userInput, stop;
	output logic [7:0] lightOn = 0;
	
	//offEdge refers to if the topmost light had been on without the user pressing the button
	output logic offEdge = 0;
	
	//turnoff will store the value of userInput until counter reaches 16th cycle
	
	logic turnoff = 0;

	//This creates a counter that cycles through 0 - 15 for lights to change every 16 cycles
	logic [3:0] counter = 0;
	always_ff @(posedge clk) begin
		if (reset) 
			counter <= 0;
		else 
			counter <= counter + 1;
	end

	//if user presses button, turnoff will store that fact until the lights change, which depends on if user pressed button or not
	always_ff @(posedge clk) begin
		if (reset)
			turnoff <= 0;
		else if (userInput)
			turnoff <= 1;	
		else if (counter == 4'b1111)
			turnoff <= 0;
	end
	
	//This actually changes the lights. If reset, all lights should be off. then, lights only change at each sixteen cycle in which they move up the counter
	always_ff @(posedge clk) begin
		if (reset | stop)
			lightOn <= 0;
		else if (counter == 4'b1111) begin
		
			if (turnoff) begin
			
			//If the user had pressed the button, the next state will have the light next to the top-most light turned off when it would otherwise be on
			
				if (lightOn[0]) begin
					lightOn[7:0] <= {start, lightOn[7:1]};
					offEdge <= 0; end
				else if (lightOn[1]) begin
					lightOn[7:0] <= {start, lightOn[7:2], 1'b0};
					offEdge <= lightOn[0]; end
				else if (lightOn[2]) begin
					lightOn[7:0] <= {start, lightOn[7:3], 1'b0, lightOn[1]};
					offEdge <= lightOn[0]; end
				else if (lightOn[3]) begin
					lightOn[7:0] <= {start, lightOn[7:4], 1'b0, lightOn[2:1]};
					offEdge <= lightOn[0]; end
				else if (lightOn[4]) begin
					lightOn[7:0] <= {start, lightOn[7:5], 1'b0, lightOn[3:1]};
					offEdge <= lightOn[0]; end
				else if (lightOn[5]) begin
					lightOn[7:0] <= {start, lightOn[7:6], 1'b0, lightOn[4:1]};
					offEdge <= lightOn[0]; end
				else if (lightOn[6]) begin
					lightOn[7:0] <= {start, lightOn[7], 1'b0, lightOn[5:1]};
					offEdge <= lightOn[0]; end
				else if (lightOn[7]) begin
					lightOn[7:0] <= {start, 1'b0, lightOn[6:1]};
					offEdge <= lightOn[0]; end
				end
				
			else begin
			
			// If user had not pressed the button, lights would shift up as usual
			
				lightOn[7:0] <= {start, lightOn[7:1]};
				offEdge <= lightOn[0]; end
		end	
	end

endmodule 



module lightRow_testbench();
	logic clk, reset, start, userInput, stop;
	logic [0:7] lightOn;
	logic offEdge;
	
	lightRow dut (clk, reset, start, userInput, stop, lightOn, offEdge);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		
	stop <= 0; reset <= 0;	start <= 0; userInput <= 0;@(posedge clk);
									start <= 1;						@(posedge clk);
									start <= 0;						@(posedge clk);
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
									start <= 1;						@(posedge clk);
									start <= 0;						@(posedge clk);
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
													userInput <= 1;@(posedge clk);
													userInput <= 0;@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
									start <= 1;						@(posedge clk);
									start <= 0;						@(posedge clk);
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
									start <= 1;						@(posedge clk);
									start <= 0;						@(posedge clk);
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
		stop <= 1;													@(posedge clk);
		stop <= 0;													@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
																		@(posedge clk);
					reset <= 1;										@(posedge clk);
																		@(posedge clk);

		$stop;
	end
	
endmodule 
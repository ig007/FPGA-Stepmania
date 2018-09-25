module inputPulse(clk, reset, in, out);

	//This module accepts the user's button press and turns it into a button press lasting one clock cycle (only pressed once)
	
	output logic out;
	input logic clk, reset, in;
	logic [3:0] q = 0;
	
	
	
	always_ff @(posedge clk) begin
		if (reset)
			q <= 0; //When reset is activated, every input should reset to 0
		else begin
			q[0] <= in; 
			q[1] <= q[0]; //stabilizing the input
			q[2] <= q[1];  
			q[3] <= q[2]; end //creating a shift register
	end
	
	assign out = (q[2] && (!q[3])); //"out" is the input that is actually passed into the other FSMs
	
endmodule 

module inputPulse_testbench;

	logic clk, reset, in, out;
	
	inputPulse dut (clk, reset, in, out);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	//set up inputs to design
	//Testing each possible input
	initial begin
														@(posedge clk);
		reset <= 1;									@(posedge clk);
						in <= 0;						@(posedge clk);
						in <= 1;						@(posedge clk);
														@(posedge clk);
		reset <= 0; 								@(posedge clk);
						in <= 0;						@(posedge clk);
														@(posedge clk);
														@(posedge clk);
														@(posedge clk);
						in <= 1;						@(posedge clk);
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
//module rowStart (clk, reset, random, start);
//	//input random is from calling the LFSR module in main module once
//	//Call this four times. Once for each row starting choice
//	input logic clk, reset;
//	input logic [9:0] random;
//	output logic start1, start2, start3, start4;
//	logic number;
//	
//	enum {A, B, C} ps, ns;
//	
//	always_ff @(posedge clk) begin
//		ps <= ns;
//	end
//	
//	always_comb begin
//		case(ps)
//			A: ns = B;
//			B: ns = C;
//			C: ns = A;
//		endcase
//	end
//	
//	LFSR choice (clk, reset, number);
//	
//	assign startchoice = random[number];
//	
//endmodule 
//
//module rowStart_testbench();
//
//	logic clk, reset;
//	logic [9:0] random;
//	logic startChoice;
//	
//	rowStart dut(clk, reset, random);
//	
//	//Set up the clock
//	parameter CLOCK_PERIOD = 100;
//	initial begin
//		clk <= 0;
//		forever #(CLOCK_PERIOD/2) clk <= ~clk;
//	end
//	
//	
//	//Test many cycles for a sample of output values as well as reset input
//	initial begin
//		reset <= 0;	random<=10'b1010101010; 	@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//		reset <= 1;										@(posedge clk);
//		reset <= 0; 									@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//															@(posedge clk);
//		$stop;
//	end
//
//endmodule
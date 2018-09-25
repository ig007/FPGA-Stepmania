module led_matrix_driver (clock, red_array, green_array, red_driver, green_driver, row_sink);

	//This driver takes the input of two arrays: one containing information of when red lights are on, one containing information of when green lights are on
	//The always block will turn each row on, one at a time, faster than the human eye can see to account for the fact that there are only 24 pins used for the LED matrix
	
	input clock;
	input [7:0][7:0] red_array, green_array;
	output reg [7:0] red_driver, green_driver, row_sink;
	reg [2:0] count = 0;
	
	always @(posedge clock)
		count <= count + 3'b001;
	
	//cycles through the eight rows
	always @(*)
		case (count)
		3'b000: row_sink = 8'b11111110;
		3'b001: row_sink = 8'b11111101;
		3'b010: row_sink = 8'b11111011;
		3'b011: row_sink = 8'b11110111;
		3'b100: row_sink = 8'b11101111;
		3'b101: row_sink = 8'b11011111;
		3'b110: row_sink = 8'b10111111;
		3'b111: row_sink = 8'b01111111;
		endcase
		
		//outputs one row of each array at a time
	assign red_driver = red_array[count];
	assign green_driver = green_array[count];
	
endmodule


module led_matrix_driver_testbench;

	logic clock; 
	logic [7:0] [7:0] red_array, green_array;
	logic [7:0] red_driver, green_driver, row_sink;
	
	led_matrix_driver dut (clock, red_array, green_array, red_driver, green_driver, row_sink);
	
	//Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clock <= 0;
		forever #(CLOCK_PERIOD/2) clock <= ~clock;
	end
	
	//set up inputs to design
	//Testing each possible input
	initial begin
			red_array[0] = 8'b11111111;		
			red_array[1] = 8'b10101010;
			red_array[2] = 8'b00000100;
			red_array[3] = 8'b00000001;
			red_array[4] = 8'b10000000;
			red_array[5] = 8'b00100100;
			red_array[6] = 8'b00000000;
			red_array[7] = 8'b01111110;
			
			green_array[0] = 8'b00000000;
			green_array[1] = 8'b01010101;
			green_array[2] = 8'b10000000;
			green_array[3] = 8'b00000100;
			green_array[4] = 8'b00000001;
			green_array[5] = 8'b11011011;
			green_array[6] = 8'b11111111;
			green_array[7] = 8'b10000001;		@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);
														@(posedge clock);

														
										
		$stop; //End the simulation
	end
endmodule 
module victory(clk, reset, userInput,lights, offEdge, totalscore, scorechange);
	
	//The purpose of this module is to output the amount that the score will change based on the position of the lights and the state of the user's button press
	//as well as the information about the light having gone off the edge of the column or not
	
	input logic clk, reset, userInput, offEdge;
	input logic [7:0] lights;
	input logic  [7:0] totalscore;
	output logic [7:0] scorechange = 0;
	
	logic [7:0] topLight;
	logic addOne, addTwo, minusTwo, stop, low1, low2;

	logic change = 0;
	
	//Counter that cycles through 0 - 15 so the score changing variables will only be added to the total score once every sixteen cycles,
	//so that the score changes at the same time as the lights changing
	logic [3:0] counter = 0;
	
	always_ff @(posedge clk) begin
		if (reset) 
			counter <= 0;
		else 
			counter <= counter + 1;
	end

	//8-bit toplight value creates a vector to replace the "LEDs" column where only the top-most light is a 1. 
	//This always_comb looks through the lights from top to bottom and sets topLight accordingly once it finds the top light that is on.

	always_comb begin
		if (lights[0]) 
			topLight = {7'b0, 1'b1};
		else if (lights[1])
			topLight = {6'b0, 1'b1, 1'b0};
		else if (lights[2])
			topLight = {5'b0, 1'b1, 2'b0};
		else if (lights[3])
			topLight = {4'b0, 1'b1, 3'b0};
		else if (lights[4])
			topLight = {3'b0, 1'b1, 4'b0};
		else if (lights[5])
			topLight = {2'b0, 1'b1, 5'b0};
		else if (lights[6])
			topLight = {1'b0, 1'b1, 6'b0};
		else if (lights[7])
			topLight = {1'b1, 7'b0};
		else
			topLight = 8'b0;
	end
	
	
	//'change' will hold the information if the user has pressed the button or not for the rest of the 16 total clock cycles so that the score can change accordingly
	
	always_ff @(posedge clk) begin
		if (reset)
			change <= 0;
		else if (userInput)
			change <= 1;	
		else if (counter == 4'b1111)
			change <= 0;
	end

		
	always_comb begin 
	
		//score changes by positive one if  the user presses the button when the topmost light is on or third-from-top light is on
		 addOne = change&(topLight[2] | topLight[0]); 
		 
		 //score changes by positive two if user presses the button when the second-to-top light is on (target light)
		 addTwo = change&topLight[1];
		 
		 //score changes by negative two if user presses the button any other time or if the user has let the top light go off the edge
		 minusTwo = (offEdge | (change&(~topLight[2]& ~topLight[1] & ~topLight[0])));
		
		//score should stop changing when maximum points have been achieved (255)
		 stop = (totalscore >= 8'd255);
		 low1 = (totalscore == 8'd1);
		 low2 = (totalscore == 8'b0);
	end
	
	//This piece will output the score changing value at every 16th clock cycle
	always_ff @(posedge clk) begin
	
		if(reset | stop)
				scorechange <= 8'b0;
				
		else if (counter == 4'b1110) begin
			 if (addTwo)
				scorechange <= 8'b00000010; //add two	
			 if(addOne)
				scorechange <= 8'b00000001; //add one
			 if (minusTwo & ~low2)
				scorechange <= 8'b11111110; //add negative two
			 if (minusTwo & low2)
				scorechange <= 8'b0;
			if (minusTwo & low1)
				scorechange <= 8'b11111111; //add negative one
		end
		else
			scorechange <= 0; //do not change the score otherwise
	end
	
endmodule 

module victory_testbench();
	logic clk, reset, userInput, offEdge;
	logic [7:0] lights;
	logic [7:0] totalscore;
	logic [7:0] scorechange;
	
	victory dut (clk, reset, userInput, lights, offEdge, totalscore, scorechange);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		
		reset <= 0;	userInput <= 0; offEdge <= 0; lights <= 0;		totalscore<= 0;			@(posedge clk);
						userInput <= 1; 																			@(posedge clk);
						userInput <= 0;																			@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																lights <= 3'b100; totalscore<= 6'd15;		@(posedge clk);
																														@(posedge clk);
							userInput <= 1;																		@(posedge clk);
							userInput <= 0;																		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk)
																lights <= 3'b010; 								@(posedge clk);
																														@(posedge clk);
							userInput <= 1;																		@(posedge clk);
							userInput <= 0;																		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
				userInput <= 1;							lights <= 3'b001; 								@(posedge clk);
				userInput <= 0;																					@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
											offEdge <= 1;	lights <= 3'b000; 								@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
											 offEdge <= 0;															@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
					userInput <= 1;																				@(posedge clk);
					userInput <= 0;																				@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
						userInput <= 1;					lights <= 3'b010; 								@(posedge clk);
						userInput <= 0;																			@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
		reset <= 1;																									@(posedge clk);
		reset <= 0;																									@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																						totalscore<= 6'd49;		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																						totalscore<= 6'd50;		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
											offEdge <= 1;							totalscore<= 6'd0;		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																						totalscore<= -6'd6;		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																						totalscore<= -6'd5;		@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
																														@(posedge clk);
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
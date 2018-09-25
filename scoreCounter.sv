//module scoreCount (clk, reset, in1, in2, in3, in4, lights1, lights2, lights3, lights4, totalscore);
//
//
//	//figure out how to do this with twos complement 
//	
//	input logic clk, reset, in1,  in2, in3, in4, offEdge;
//	input logic [2:0] lights;
//	output logic  [5:0] totalscore;
//	
//	
//	logic addOne, addTwo, minusTwo, minusOne, stop, stop2;
//	
//	//Score is limited to +- 50 points
//	
////No not three states, just a two-bit output?
////two bit output can be 1,2,3. 1 is +1, 2 is +2, 3 is -2.
////Maybe just keep score here, score is 5 bits 
//
////Account for two error victory cases
//
////goes up to 50
////sET LOWER LIMIT TO -6???
//
//	always_comb begin
//		 addOne = userInput&(lights[2] | lights [0]);
//		 addTwo = userInput&lights[1];
//		 minusTwo = (offEdge | (userInput&(~lights[2]& ~lights[1] & ~lights[0]))); 
//		 minusOne = userInput&(~lights[2]& ~lights[1] & ~lights[0]);
//		 stop = (totalscore == 6'd50);
//		 stop2 = (totalscore == 6'd49);
//		 low1 = (totalscore == 6'd1);
//		 low2 = (totalscore == 6'b0);
//	end
//	
//	always_ff @(posedge clk) begin
//		if(reset | stop)
//			score <= 0;
//		else if(addOne)
//			score <= 3'b001;
//		else if (addTwo & ~stop2)
//			score <= 3'b010;
//		else if (addTwo)
//			score <= 3'b001;
//		else if (minusTwo & ~low1 & ~low2)
//			score <= -3'd2;
//		else if (minusTwo & ~low1)
//			score <= -3'd1;
//		else if (minusTwo & low2)
//			score <= 0;
//	end
//	
//	
//endmodule 
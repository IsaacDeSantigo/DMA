//Module 
module Multiplexor_2a1(
	//Port
	//Direction	Type	Size	Name
	input			[9:0]	a,
	input			[9:0]	b,
	input				selDir,

	output			[9:0]	x
); 

//Assigments

assign x = (selDir) ? b : a; 

endmodule

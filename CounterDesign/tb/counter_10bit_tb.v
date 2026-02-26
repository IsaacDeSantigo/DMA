`timescale 1ns/1ps
//Module
module counter_10bit_tb; 
//PORT
//Type	Size	Name
reg	[9:0]	data; 
reg		nMR;
reg		load; 
reg		dir;
reg		en;
reg		clk;

wire	[9:0]	count; 
wire		carry;

counter_10bit dut(
	.data(data),
	.nMR(nMR),
	.load(load),
	.dir(dir),
	.en(en),
	.clk(clk),
	.count(count),
	.carry(carry)
);

initial begin 
	//Initialization
	/*--------LOAD MODE--------*/
	nMR  = 1; 
	clk = 0; 
	load = 1; 	
	en   = 0; 	
	dir  = 1; 
	data = 1020; 

	
	#200;  
	$stop; 
end


always 
#10 clk = !clk; 

endmodule	

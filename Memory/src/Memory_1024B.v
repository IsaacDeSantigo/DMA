//Module
module Memory_Program(
	//PORT
	//Direction	Type	Size		Name 
	input			[7:0]		Data_In, 
	input			[9:0]		Addr,
	input					rst_out, 
	input					nW_R, 
	input					clk,
	input 					CE, 
	
	output		reg	[7:0]		Data_Out
); 



//Defining memory space
			reg	[7:0]		Mem[1024:0];
			integer	i; 

initial begin 
	for(i = 0; i <1024; i = i + 1) begin 
		Mem[i] = 8'b0; 
	end

	Mem[0] = 8'h3A; // 58 en decimal
    	Mem[1] = 8'h7F; // 127 en decimal
    	Mem[2] = 8'hC2; // 194 en decimal
    	Mem[3] = 8'h1D; // 29 en decimal
    	Mem[4] = 8'hA9; // 169 en decimal
    	Mem[5] = 8'h4E; // 78 en decimal
    	Mem[6] = 8'h95; // 149 en decimal
    	Mem[7] = 8'h6B; // 107 en decimal
    	Mem[8] = 8'hD4; // 212 en decimal
    	Mem[9] = 8'h08; // 8 en decimal
	Mem[10] = 8'h12; // 8 en decimal
end

always @( posedge clk or negedge rst_out) begin 
	if ( !rst_out ) begin 
		Data_Out <= 8'b0; 
	end else if ( CE ) begin
		if ( !nW_R ) begin 
			Data_Out  <= Mem[Addr]; 			//Instructions to read
		end else begin 
			Mem[Addr] <= Data_In; 				//Instructions to write
		end
	end
end

endmodule 

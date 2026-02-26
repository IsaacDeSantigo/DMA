//Module

module register_8bit(
	//Port
	//Direction	Type	Size	Name
	input			[7:0]	Data_In, 
	input				clk, 
	input				rst,
	input				load, 
	
	output			[7:0]	Data_Out
);

				reg		[7:0]	Mem; 	

assign Data_Out = Mem; 				

always@(posedge clk or negedge rst) begin 

	if(!rst) begin 
		Mem <= 8'b0; 
	end else begin 
		if(!load) begin 
			Mem <= Data_In; 
		end else begin 
			Mem <= Mem; 
		end
	end

end

endmodule 

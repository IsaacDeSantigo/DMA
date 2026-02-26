//Modulo 
module counter_10bit(
	//PORT
	//Direction	Type	Size	Name
	input		reg		[9:0]		data, 
	input						clk, 
	input						nMR, 
	input						load, 
	input						dir, 
	input						en, 
	
	output		reg		[9:0]		count, 
	output		reg				carry,

	//Aux Data
	output		reg				loadDone
); 
	
				
				parameter			IDLE  = 2'b00, 
								LOAD  = 2'b01, 
								COUNT = 2'b10, 
								RESET = 2'b11; 
				reg		[1:0]		CURRENT_STATE = RESET,NEXT_STATE; 

always@(posedge clk or negedge nMR) begin 
	if ( !nMR ) begin
		CURRENT_STATE <= RESET; 
	end else begin 
		CURRENT_STATE <= NEXT_STATE; 
	end
end 								

always@(*) begin 
	case(CURRENT_STATE)
		IDLE: 
			begin
				if(!nMR) begin
					NEXT_STATE = RESET; 
				end else if (!load) begin
					NEXT_STATE = LOAD; 
				end else if (en) begin
					NEXT_STATE = COUNT; 
				end else begin 
					NEXT_STATE = IDLE; 
				end
			end
		LOAD: 
			begin 
				if(!nMR) begin 
					NEXT_STATE = RESET; 
				end else if (!load) begin 
					NEXT_STATE = LOAD; 
				end else if (en) begin 
					NEXT_STATE = COUNT; 
				end else begin 
					NEXT_STATE = IDLE; 
				end
			end
		COUNT: 
			begin 
				if(!nMR) begin 
					NEXT_STATE = RESET; 
				end else if ( !load ) begin 
					NEXT_STATE = LOAD; 
				end else if ( !en ) begin 
					NEXT_STATE = IDLE; 
				end else begin 
					NEXT_STATE = COUNT; 
				end
			end
		RESET:
			begin 
				if(!nMR) begin 
					NEXT_STATE = RESET; 
				end else begin 
					NEXT_STATE = IDLE; 
				end
			end
		
	endcase
end

always @(*) begin
	if ( CURRENT_STATE == RESET ) begin 
		carry = 1'b0; 
	end else begin 
    		if (dir) // Conteo ascendente
       			carry = (count == 12'h3FF);  // Se activa en 255 (0xFF)
    		else     // Conteo descendente
       			carry = (count == 12'h000);  // Se activa en 0 (0x00)
	end
end

always@(posedge clk or negedge nMR) begin 
	case(CURRENT_STATE) 
		IDLE: 
			begin
			count <= count; 
			loadDone <= 1'b0; 
			end
		LOAD: 
			begin 
			count <= data; 
			loadDone <= 1'b1; 
			end
		COUNT: 
			begin 
			count <= (dir) ? count + 1 : count - 1; 
			loadDone <= 1'b0; 
			end
		RESET:
			begin
			count <= 10'b0; 
			loadDone <= 1'b0; 
			end
	endcase

end				
	
	
endmodule 

//Modulo 

module FSM_DMA(
	//PORT
	//Direction	Type	Size	Name
	//FSM Control Signals
	input				inicio, 
	input				load, 
	input				clk, 
	input				done,		//Byte Quantity Control Signal  
	input				rst, 
	input			[2:0]	loadDone,
	
	//Counter Control Signals
	output		reg		load_C1, 
	output		reg		en_C1, 
	output		reg		load_C2, 
	output		reg		en_C2, 
	output		reg		load_C3,
	output		reg		en_C3,
	//Multiplexor Control Signals 
	output		reg		selDir, 
	//Register Control Signals 
	output		reg		load_R,
	//Memory Control Signals
	output		reg		nW_R,
	output 		reg		en, 
	//Processor Signals
	output		reg		INT,
	output		reg		ACK
); 

			parameter 	IDLE = 2'b00, 
					LOAD = 2'b01, 
					MOVE = 2'b10,
					DONE = 2'b11;
			reg	[1:0]	CURRENT_STATE = IDLE, NEXT_STATE; 

			reg	[1:0]	step_counter; 

always@(posedge clk or negedge rst) begin 
	if(!rst) begin 
		CURRENT_STATE <= IDLE; 
	end else begin 
		CURRENT_STATE <= NEXT_STATE; 
	end
end

always @(*) begin 
	case(CURRENT_STATE) 
		IDLE: 
			begin 
				if(!rst) begin 
					NEXT_STATE = IDLE; 
				end else if(inicio) begin 
					NEXT_STATE = LOAD;
				end else begin 
					NEXT_STATE = IDLE; 
				end
			end
		LOAD: 	
			begin 
				if(!rst) begin 
					NEXT_STATE = IDLE; 
				end else if (load) begin 
					NEXT_STATE = MOVE; 
				end else begin 
					NEXT_STATE = LOAD; 
				end
			end
		MOVE: 	
			begin 
				if(!rst) begin 
					NEXT_STATE = IDLE; 
				end else if (done) begin 
					NEXT_STATE = DONE; 
				end else begin 
					NEXT_STATE = MOVE; 
				end
			end
		DONE:	
			begin
				NEXT_STATE = IDLE; 
			end
	endcase
end

always@(posedge clk or negedge rst) begin 
	case(CURRENT_STATE)
		IDLE: 
			begin
			//COUNTERS DATA
				load_C1 <= 1'b1;	//Origin Address Counter in IDLE mode 
				en_C1 	<= 1'b0; 
				load_C2 <= 1'b1;	//Destination Address Counter in IDLE mode 
				en_C2 	<= 1'b0;
				load_C3 <= 1'b1;	//Bytes Quantity Counter in IDLE mode
				en_C3 	<= 1'b0; 
			//MULTIPLEXOR SELECTION
				selDir  <= 1'b0;	//Pre-selecting Origin Address
			//REGISTER DATA
				load_R <= 1'b1;		//Disabling load
			//MEMORY DATA
				en <= 1'b0; 		//Disabling memory
				nW_R <= 1'b1; 		//Reading mode for default
			//FSM Variables
				INT  <= 1'b0; 
				ACK <= 1'b0; 
				step_counter <= 2'b00; 
			end
			
		LOAD: 
			begin
			//COUNTERS DATA
				load_C1 <= 1'b0;	//Origin Address Counter in LOAD mode 
				load_C2 <= 1'b0;	//Destination Address Counter in LOAD mode 
				load_C3 <= 1'b0; 	//Bytes Quantity Counter in Load mode
				
				if ( loadDone == 3'b111 ) begin 
					INT 	<= 1'b1; //Sending to CORE
					//COUNTERS DATA
					load_C1 <= 1'b1;	//Origin Address Counter in IDLE mode 
					load_C2 <= 1'b1;	//Destination Address Counter in IDLE mode 
					load_C3 <= 1'b1; 	//Bytes Quantity Counter in IDLE mode
				end
			end
		MOVE: 
			begin
				case(step_counter)
					2'b00:
						begin 
							//Memory Data
							en <= 1'b1; 	//Enabling Memory 
							nW_R <= 1'b0; 	//Reading Memory
							//MULTIPLEXOR SELECTION
							selDir  <= 1'b0;	//Selecting Origin Address
							step_counter <= step_counter + 1;
						end
					2'b01:
						begin 
							//Register Data
							load_R <= 1'b0; //Loading data
							//MULTIPLEXOR SELECTION
							selDir  <= 1'b1;	//Selecting Destination Address
							//COUNTERS DATA
							step_counter <= step_counter + 1;
						end
					2'b10:
						begin 
						//COUNTERS 
							en_C1 	<= 1'b1; 	//Origin Address Counter in COUNT mode 
							en_C2 	<= 1'b1;	//Destination Address Counter in COUNT mode 
							en_C3 	<= 1'b1; 	//Bytes Quantity Counter in COUNT mode
						//Register Data
							load_R <= 1'b1; //Disabling load
						//MEMORY DATA
							en <= 1'b1; 	//Enabling Memory 
							nW_R <= 1'b1; 	//Writing Memory

							step_counter <= step_counter + 1;
						end
					2'b11:
						begin
						//COUNTERS 
							en_C1 	<= 1'b0; 	//Origin Address Counter in IDLE mode 
							en_C2 	<= 1'b0;	//Destination Address Counter in IDLE mode 
							en_C3 	<= 1'b0; 	//Bytes Quantity Counter in IDLE mode
						//Memory

							en <= 1'b0; 		//Disabling memory

							step_counter <= step_counter + 1;
						end
				endcase
			end
			DONE:
				begin 
					ACK  <= 1'b1;
					INT  <= 1'b0;  
				end		
	endcase
end



endmodule

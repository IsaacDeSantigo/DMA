//Module 

module Top_Module(
	//Direction	Type	Size	Name
	input			[9:0]	OriginAddress, 
	input			[9:0]	DestinationAddress, 
	input			[4:0]	BytesQuantity,

	input				rst, 
	input				clk,
	input				start,
	input				load,

	output				INT,
	output				ACK 

);

//Wires and Registers

	//Connected to memory
		wire		[7:0]	Data_Memory_To_DMA;
		wire		[9:0]	Addr_DMA_To_Memory;
		wire		[7:0]	Data_DMA_To_Memory;
		wire			CE;
		wire			nW_R;

top_module_DMA dma_controller (
    // Inputs
    .OriginAddress(OriginAddress),
    .DestinationAddress(DestinationAddress),
    .BytesQuantity(BytesQuantity),
    .DataIn(Data_Memory_To_DMA),			
    
    .rst(rst),
    .clk(clk),
    .start(start),
    .load(load),

    // Outputs
    .Address(Addr_DMA_To_Memory),
    .Output(Data_DMA_To_Memory),
    .nW_R(nW_R),
    .CE(CE),
    .INT(INT),
    .ACK(ACK)
);

Memory_Program memory_inst (
    // Inputs
    .Data_In(Data_DMA_To_Memory),	//Debug
    .Addr(Addr_DMA_To_Memory),
    .rst_out(rst),
    .nW_R(nW_R),
    .clk(clk),
    .CE(CE),

    // Output
    .Data_Out(Data_Memory_To_DMA)
);

endmodule

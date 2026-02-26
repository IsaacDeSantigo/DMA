//Module 

module top_module_DMA(
	//PORT
	//Direction	Type	Size	Name
	input			[9:0]	OriginAddress, 
	input			[9:0]	DestinationAddress, 
	input			[4:0]	BytesQuantity,
	input			[7:0]	DataIn,		//From memory
	
	input				rst,
	input				clk, 
	input				start,
	input				load,

	output			[9:0]	Address,	//To memory
	output			[7:0]	Output,		//To memory
	output				nW_R, 
	output				CE, 
	output				INT,
	output				ACK
);

//Wires and Registers
			//Wires for OriginAddress	
			wire		load_OA,en_OA,loadDone_OA;	
			wire	[9:0]	cout_OA;  
			//Wires for DestinationAddress
			wire		load_DA,en_DA,loadDone_DA;	
			wire	[9:0]	cout_DA;  
			//Wires for BytesQuantity
			wire		load_BQ,en_BQ,loadDone_BQ,carry_BQ;	
			wire 	[2:0] 	allLoadDone;
			//Wires for MUX
			wire		selDir; 
			//Wires for Register
			wire		loadReg; 

assign allLoadDone = {loadDone_OA,loadDone_DA,loadDone_BQ};	//Debug
			

//ASSIGMENTS

counter_10bit Origin_Address(
	.data(OriginAddress),
	.clk(clk),
	.nMR(rst),
	.load(load_OA),
	.en(en_OA),
	.count(cout_OA),
	.dir(1'b1),
	.loadDone(loadDone_OA),
	.carry()
); 

counter_10bit Destination_Address(
	.data(DestinationAddress),
	.clk(clk),
	.nMR(rst),
	.load(load_DA),
	.en(en_DA),
	.count(cout_DA),
	.dir(1'b1),
	.loadDone(loadDone_DA),
	.carry()
); 

counter_10bit Bytes_Quantity(
	.data({5'b00000,BytesQuantity}),
	.clk(clk),
	.nMR(rst),
	.load(load_BQ),
	.en(en_BQ),
	.count(),
	.dir(1'b0),
	.loadDone(loadDone_BQ),
	.carry(carry_BQ)
); 

Multiplexor_2a1 Mux(
	.a(cout_OA),
	.b(cout_DA),
	.x(Address),
	.selDir(selDir)
);

register_8bit register(
	.Data_In(DataIn),
	.clk(clk),
	.load(loadReg),
	.rst(rst),
	.Data_Out(Output)
);  

FSM_DMA fsm_dma (
    // FSM Control Signals
    .inicio(start),
    .load(load),
    .clk(clk),
    .done(carry_BQ),        // Byte Quantity Control Signal  
    .rst(rst),
    .loadDone(allLoadDone),
    
    // Counter Control Signals
    .load_C1	(load_OA),
    .en_C1(en_OA),
    .load_C2(load_DA),
    .en_C2(en_DA),
    .load_C3(load_BQ),
    .en_C3(en_BQ),
    
    // Multiplexor Control Signals 
    .selDir(selDir),
    
    // Register Control Signals 
    .load_R(loadReg),
    
    // Memory Control Signals
    .nW_R(nW_R),
    .en(CE),
    
    // Processor Signals
    .INT(INT),
    .ACK(ACK)
);


endmodule


//Registers and Wires

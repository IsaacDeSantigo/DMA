`timescale 1ns/1ps

module DMA_tb; 

//Port
//Type	Size	Name
 // Definición de señales de prueba
    reg  [9:0]  tb_OriginAddress;
    reg  [9:0]  tb_DestinationAddress;
    reg  [4:0]  tb_BytesQuantity;
    reg  [7:0]  tb_DataIn;
    reg         tb_rst;
    reg         tb_clk;
    reg         tb_start;
    reg         tb_load;

    wire [9:0]  tb_Address;
    wire [7:0]  tb_Output;
    wire        tb_nW_R;
    wire        tb_CE;
    wire        tb_INT;
    wire        tb_ACK;

top_module_DMA dut (
        .OriginAddress(tb_OriginAddress),
        .DestinationAddress(tb_DestinationAddress),
        .BytesQuantity(tb_BytesQuantity),
        .DataIn(tb_DataIn),

        .rst(tb_rst),
        .clk(tb_clk),
        .start(tb_start),
        .load(tb_load),

        .Address(tb_Address),
        .Output(tb_Output),
        .nW_R(tb_nW_R),
        .CE(tb_CE),
        .INT(tb_INT),
        .ACK(tb_ACK)
);

 always #5 tb_clk = !tb_clk; // Periodo de 10 unidades de tiemp

 // Bloque de prueba
    initial begin
        // Inicialización de señales
        tb_rst = 0;
        tb_clk = 0;
        tb_start = 0;
        tb_load = 0;
        tb_OriginAddress = 10'd0;
        tb_DestinationAddress = 10'd20;
        tb_BytesQuantity = 5'd10;
        tb_DataIn = 8'hAA;  // Datos de prueba

        #10 tb_rst = 1;  // Liberamos reset
	#10 tb_start = 1; // Iniciamos la transferencia
	wait(tb_INT); 
	#10 tb_load = 1; 
        

	
        #100 $stop;     // Finalizar simulación
    end





endmodule

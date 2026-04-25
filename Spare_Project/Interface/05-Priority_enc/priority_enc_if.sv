interface priority_enc_if(input logic clk);

    // declare parameters and signals
    logic rst;
    logic [3:0] D;	
    logic [1:0] Y;	
    logic valid;

    // modport initialization
    modport DUT (input clk, rst, D, output Y, valid);

    modport TEST (output rst, D, input clk, Y, valid);

    modport MONITOR(input clk, rst, D, Y, valid);

endinterface
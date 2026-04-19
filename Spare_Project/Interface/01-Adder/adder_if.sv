interface adder_if(input logic clk);

    // 1. Add the internal signals of the interface
    logic reset;
    logic signed [3:0] A;	// Input data A in 2's complement
    logic signed [3:0] B;	// Input data B in 2's complement
    logic signed [4:0] C; // Adder output in 2's complement

    // w. Add the modports
    modport DUT (input clk, reset, A, B, output C);

    modport TEST (input clk, C, output reset, A, B);

    modport MONITOR (input clk, reset, A, B, C);

endinterface
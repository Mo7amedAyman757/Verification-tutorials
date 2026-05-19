interface ALU_if(input logic clk);
    
    logic reset;
    logic [1:0] Opcode;	// The opcode
    logic signed [3:0] A;	// Input data A in 2's complement
    logic signed [3:0] B;	// Input data B in 2's complement
    logic signed [4:0] C; // ALU output in 2's complement

endinterface //ALU_if

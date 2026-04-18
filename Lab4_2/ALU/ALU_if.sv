////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: ALU Design 
// 
////////////////////////////////////////////////////////////////////////////////
interface ALU_if(clk);

    parameter  Add	          = 2'b00; // A + B
    parameter  Sub	          = 2'b01; // A - B
    parameter  Not_A	      = 2'b10; // ~A
    parameter  ReductionOR_B  = 2'b11; // |B

    // 2. Add the clock as an input port
    input clk;

    // 3. Add the internal signals of the interface
    logic reset;
    logic [1:0] Opcode;	// The opcode
    logic signed [3:0] A;	// Input data A in 2's complement
    logic signed [3:0] B;	// Input data B in 2's complement
    logic signed [4:0] C; // ALU output in 2's complement

    // 4. Add the modports
    modport DUT(input clk, reset, Opcode, A, B, output C);

    modport TEST(output reset, Opcode, A, B, input clk, C);

    modport MONITOR(input clk, reset, Opcode, A, B, C);

endinterface
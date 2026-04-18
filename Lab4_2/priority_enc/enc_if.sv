////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: priority_enc Design 
// 
////////////////////////////////////////////////////////////////////////////////
interface enc_if(clk);

    // 2. Add the clock as an input port
    input clk;

    // 3. Add the internal signals of the interface
    logic clk;
    logic rst;
    logic [3:0] D;	
    logic  [1:0] Y;	
    logic valid;

    // 4. Add the modports
    modport DUT (input clk, rst, D, output Y, valid);

    modport TEST (output rst, D, input clk, Y, valid);

    modport MONITOR(input clk, rst, D, Y, valid);

endinterface
////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: ALU Design 
// 
////////////////////////////////////////////////////////////////////////////////
module ALU_top ();
    
    // 1. Generate the clock
    bit clk;
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end

    // 2. instantiate the interface, and pass the clock
    ALU_if alu_inst(clk);

    // 3. instantiate the tb, DUT, monitor, and pass the interface
    ALU_tb tb(alu_inst);

    ALU_4_bit dut(alu_inst);

    ALU_monitor monitor(alu_inst);

    // 4. bind the SVA module to the design, and pass the interface
    bind ALU_4_bit ALU_sva ALU_if_inst(alu_inst);

endmodule
////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: priority_enc Design 
// 
////////////////////////////////////////////////////////////////////////////////
module enc_top();

    // 1. Generate the clock
    bit clk;
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end

    // 2. instantiate the interface, and pass the clock
    enc_if e_if(clk);

    // 3. instantiate the tb, DUT, monitor, and pass the interface
    priority_enc_tb tb(e_if);

    priority_enc dut(e_if);

    enc_monitor monitor(e_if);

    // 4. bind the SVA module to the design, and pass the interface
    bind priority_enc enc_sva enc_if_inst(e_if);

endmodule
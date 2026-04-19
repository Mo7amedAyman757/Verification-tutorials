////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter_top();

    // 1. Generate the clock
    bit clk;
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
    end

    // 2. instantiate the interface, and pass the clock
    counter_if c_if(clk);

    // 3. instantiate the tb, DUT, monitor, and pass the interface
    counter_tb tb(c_if);

    counter dut(c_if);

    counter_monitor monitor(c_if);

    // 4. bind the SVA module to the design, and pass the interface
    bind counter counter_sva counter_sva_inst(c_if);

endmodule
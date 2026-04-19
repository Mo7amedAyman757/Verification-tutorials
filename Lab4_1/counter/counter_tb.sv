////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
//import counter_pkg::*;

module counter_tb (counter_if.TEST c_if);
    
    //counter_class counter_transaction;

    // reset initial values for inputs
    initial begin
        //counter_transaction = new();
        c_if.rst_n = 1;
        c_if.load_n = 1;
        c_if.up_down = 0;
        c_if.ce = 0;
        c_if.data_load = 0;
        
        // Reset
        repeat(2) @(posedge c_if.clk);
        c_if.rst_n = 0;

        repeat(2) @(posedge c_if.clk);
        c_if.rst_n = 1;

        // load test
        @(posedge c_if.clk);
        c_if.load_n = 0; c_if.data_load = 4'b0001;

        @(posedge c_if.clk);
        c_if.data_load = 4'b0010;

        @(posedge c_if.clk);
        c_if.data_load = 4'b0100;

        @(posedge c_if.clk);
        c_if.data_load = 4'b1111;

        // Hold test
        @(posedge c_if.clk);
        c_if.load_n = 1;
        repeat(3) @(posedge c_if.clk);

        //Up count
        @(posedge c_if.clk);
        c_if.load_n = 1; c_if.ce = 1; c_if.up_down = 1;

        repeat(15) @(posedge c_if.clk);

        @(posedge c_if.clk);
        c_if.ce = 0;

        // load test
        @(posedge c_if.clk);
        c_if.load_n = 1; c_if.data_load = 4'b0000;
        repeat(2) @(posedge c_if.clk);
        
        // // Down count
        @(posedge c_if.clk);
        c_if.ce = 1; c_if.up_down = 0;

        repeat(15) @(posedge c_if.clk);

        @(posedge c_if.clk);
        c_if.ce = 0;

        $stop;
    end
endmodule
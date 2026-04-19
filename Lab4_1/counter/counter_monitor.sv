////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter_monitor(counter_if.MONITOR c_if);

    initial begin
        $monitor("rst_n = %b, load_n = %b, up_down = %b, ce = %b, data_load = %b, count_out = %b, max_count = %b, zero = %b",
                 c_if.rst_n, c_if.load_n, c_if.up_down, c_if.ce, c_if.data_load, c_if.count_out, c_if.max_count, c_if.zero);
    end

endmodule
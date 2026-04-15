////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_monitor(vending_machine_if.MONITOR v_if);
// 1. Add the modport above
// 2. Add the monitor statement in an initial block
    initial begin
    $monitor("reset = %b, clk = %b, Q_in = %b, D_in = %b, dispense = %b, change = %b",
            v_if.reset, v_if.clk, v_if.Q_in, v_if.D_in, v_if.dispense, v_if.change);
    end
    
endmodule
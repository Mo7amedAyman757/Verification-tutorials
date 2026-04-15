////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_tb(vending_machine_if.TEST v_if);
    // 1. Add the modport above

    // reset initial values for inputs
    initial begin
        v_if.reset = 0;
        v_if.Q_in = 0;
        v_if.D_in = 0;
        #50;
        v_if.reset = 1;
        #100;
        // test dollars
        v_if.D_in = 1'b1;  v_if.Q_in = 1'b0;
        // test quarters
        #100 v_if.D_in = 1'b0; v_if.Q_in = 1'b1;
        #100 v_if.D_in = 1'b0; v_if.Q_in = 1'b1;
        #10;
        $stop;
    end

endmodule

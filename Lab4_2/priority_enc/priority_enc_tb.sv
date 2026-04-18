////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: priority_enc Design 
// 
////////////////////////////////////////////////////////////////////////////////

module priority_enc_tb (enc_if.TEST e_if);
    
    // reset initial values for inputs
    initial begin

        e_if.rst = 0;
        e_if.D = 0;

        // Reset
        repeat(2) @(posedge e_if.clk);
        e_if.rst = 1;
        repeat(2) @(posedge e_if.clk);
        e_if.rst = 0;

        for(int i = 0; i < 40; i++) begin
            @(posedge e_if.clk);
            e_if.D = $urandom_range(0,15);
        end

    $stop;
    end

endmodule

////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: priority_enc Design 
// 
////////////////////////////////////////////////////////////////////////////////
module enc_monitor(enc_if.MONITOR e_if);

    initial begin
        $monitor("rst = %b, D = %b, Y = %b valid = %b",e_if.rst, e_if.D, e_if.Y, e_if.valid);
    end

endmodule

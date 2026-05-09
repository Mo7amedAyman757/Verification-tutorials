////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Shift register Design 
// 
////////////////////////////////////////////////////////////////////////////////
module shift_reg (shiftreg_if.DUT shiftreg_vif);

always @(posedge shiftreg_vif.clk or posedge shiftreg_vif.reset) begin
   if (shiftreg_vif.reset)
      shiftreg_vif.dataout <= 0;
   else
      if (shiftreg_vif.mode) // rotate
         if (shiftreg_vif.direction) // left
            shiftreg_vif.dataout <= {shiftreg_vif.datain[4:0], shiftreg_vif.datain[5]};
         else
            shiftreg_vif.dataout <= {shiftreg_vif.datain[0], shiftreg_vif.datain[5:1]};
      else // shift
         if (shiftreg_vif.direction) // left
            shiftreg_vif.dataout <= {shiftreg_vif.datain[4:0], shiftreg_vif.serial_in};
         else
            shiftreg_vif.dataout <= {shiftreg_vif.serial_in, shiftreg_vif.datain[5:1]};
end

endmodule
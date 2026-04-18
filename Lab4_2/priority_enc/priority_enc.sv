////////////////////////////////////////////////////////////////////////////////
// Author: Mohamed Ayman
// Course: Digital Verification using SV & UVM
//
// Description: priority_enc Design 
// 
////////////////////////////////////////////////////////////////////////////////
module priority_enc (enc_if.DUT e_if);

always @(posedge e_if.clk) begin
  if (e_if.rst)
     e_if.Y <= 2'b0;
  else
  	casex (e_if.D)
  		4'b1000: e_if.Y <= 0;
  		4'bX100: e_if.Y <= 1;
  		4'bXX10: e_if.Y <= 2;
  		4'bXXX1: e_if.Y <= 3;
		default: e_if.Y <= 0;
  	endcase
  	e_if.valid <= (~|e_if.D)? 1'b0: 1'b1;
end
endmodule
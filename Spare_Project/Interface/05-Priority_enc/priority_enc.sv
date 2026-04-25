module priority_enc (priority_enc_if.DUT enc_if);

always @(posedge enc_if.clk) begin
  if (enc_if.rst)
     enc_if.Y <= 2'b0;
  else
  	casex (enc_if.D)
  		4'b1000: enc_if.Y <= 0;
  		4'bX100: enc_if.Y <= 1;
  		4'bXX10: enc_if.Y <= 2;
  		4'bXXX1: enc_if.Y <= 3;
  	endcase
  	enc_if.valid <= (~|enc_if.D)? 1'b0: 1'b1;
end
endmodule
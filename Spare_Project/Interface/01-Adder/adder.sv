module adder (adder_if.DUT A_if);

   // Register output C
   always @(posedge A_if.clk or posedge A_if.reset) begin
      if (A_if.reset)
	     A_if.C <= 5'b0;
      else
	     A_if.C <= A_if.A + A_if.B;
   end

endmodule

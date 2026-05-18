module dff(dff_if.DUT dff_vif);

always @(posedge dff_vif.clk) begin 
   if (dff_vif.rst)
      dff_vif.q <= 0;
   else if(dff_vif.USE_EN) begin
         if (dff_vif.en)
            dff_vif.q <= dff_vif.d;
   end else begin 
         dff_vif.q <= dff_vif.d;
   end
end 

endmodule

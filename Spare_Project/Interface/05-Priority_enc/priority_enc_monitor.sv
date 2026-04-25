module priority_enc_monitor(priority_enc_if.MONITOR enc_if);
    
    always @(posedge enc_if.clk) begin
        $display("%t: rst = %b D = %b Y = %b valid = %b",$time, enc_if.rst, enc_if.D, enc_if.Y, enc_if.valid);
    end
    
endmodule
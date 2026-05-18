module dff_monitor(dff_if.MONITOR dff_vif);

    always @(negedge dff_vif.clk) begin
        $display("%t: rst = 0b%0b, d = 0b%0b, en = 0b%0b, q = 0b%0b", 
                $time, dff_vif.rst, dff_vif.d, dff_vif.en, dff_vif.q);
    end

endmodule
module counter_monitor (counter_if.MONITOR counterif);

    
    always @(negedge counterif.clk) begin
        $display("%t :rst_n = 0b%0b, load_n = 0b%0b, up_down = 0b%0b, ce = 0b%0b, data_load = 0b%0b,
                    count_out = 0b%0b, max_count = 0b%0b, zero = 0b%0b",$time,
                    counterif.rst_n, counterif.load_n, counterif.up_down, counterif.ce, counterif.data_load,
                    counterif.count_out, counterif.max_count, counterif.zero);
    end

endmodule
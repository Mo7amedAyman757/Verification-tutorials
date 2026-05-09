module shiftreg_monitor (shiftreg_if.MONITOR shiftreg_vif);

    always @(negedge shiftreg_vif.clk) begin
        $display("reset = %0b, serial_in = %0b, direction = %0b, mode = %0b, datain = %0b, dataout = %0b",
        shiftreg_vif.reset, shiftreg_vif.serial_in, shiftreg_vif.direction, shiftreg_vif.mode, shiftreg_vif.datain, shiftreg_vif.dataout);
    end

endmodule
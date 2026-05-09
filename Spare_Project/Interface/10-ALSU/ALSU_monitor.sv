module ALSU_monitor(ALSU_if.MONITOR ALSU_vif);


    always @(negedge ALSU_vif.clk) begin
        $display("%t, rst = 0b%0b, cin = 0b%0b, red_op_A = 0b%0b, red_op_B = 0b%0b, bypass_A = 0b%0b , bypass_B = 0b%0b,
                 direction = 0b%0b, serial_in = 0b%0b, opcode = 0b%0b, A = 0b%0b, B = 0b%0b, leds = 0b%0b ,out = 0b%0b",
                $time, ALSU_vif.rst, ALSU_vif.cin , ALSU_vif.red_op_A, ALSU_vif.red_op_B, ALSU_vif.bypass_A, ALSU_vif.bypass_B, 
                ALSU_vif.direction, ALSU_vif.serial_in, ALSU_vif.opcode, ALSU_vif.A, ALSU_vif.B, ALSU_vif.leds, ALSU_vif.out);
    end

endmodule
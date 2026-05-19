module ALU_monitor (ALU_if.MONITOR ALU_vif);

    always @(negedge ALU_vif.clk) begin
        $display("%t: reset = 0b%0b, Opcode = 0b%0b, A = 0b%0b, B = 0b%0b, C = 0b%0b",
                $time, ALU_vif.reset, ALU_vif.Opcode, ALU_vif.A, ALU_vif.B, ALU_vif.C);
    end

endmodule
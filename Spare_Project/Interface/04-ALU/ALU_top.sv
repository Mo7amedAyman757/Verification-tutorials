module ALU_top ();
    
    logic clk;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    ALU_if ALU_vif(clk);

    ALU_4_bit dut(ALU_vif);

    ALU_monitor monitor(ALU_vif);

    ALU_tb test(ALU_vif);

    bind ALU_4_bit ALU_sva ALU_sva_inst(ALU_vif);

endmodule
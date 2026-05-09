module ALSU_top();

    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    ALSU_if ALSU_vif(clk);

    ALSU dut(ALSU_vif);

    ALSU_monitor monitor(ALSU_vif);

    ALSU_tb test(ALSU_vif);

    bind ALSU ALSU_sva ALSU_sva_inst(ALSU_vif);

endmodule
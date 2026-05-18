module dff_top();

    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    dff_if dff_vif(clk);

    dff dut(dff_vif);

    dff_monitor monitor(dff_vif);

    dff_tb test(dff_vif);

    bind dff dff_sva dff_sva_inst(dff_vif);

endmodule
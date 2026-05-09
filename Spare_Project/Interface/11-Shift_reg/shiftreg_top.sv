module shiftreg_top ();
    
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    shiftreg_if shiftreg_vif(clk);

    shift_reg dut(shiftreg_vif);

    shiftreg_monitor monitor(shiftreg_vif);

    shiftreg_tb test(shiftreg_vif.TEST);

    bind shift_reg shiftreg_sva shift_sva_inst(shiftreg_vif);


endmodule
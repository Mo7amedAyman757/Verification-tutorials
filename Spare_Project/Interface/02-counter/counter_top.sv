module counter_top ();
    
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    counter_if counterif(clk);

    counter dut(counterif);

    counter_monitor monitor(counterif);

    counter_tb test(counterif);

    bind counter counter_sva counter_sva_inst(counterif);

endmodule
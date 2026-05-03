import shared_pkg::*;

module FIFO_top();

    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    FIFO_if fifo_vif(clk);

    FIFO dut(fifo_vif);
    FIFO_monitor monitor(fifo_vif);
    FIFO_tb test(fifo_vif);


endmodule
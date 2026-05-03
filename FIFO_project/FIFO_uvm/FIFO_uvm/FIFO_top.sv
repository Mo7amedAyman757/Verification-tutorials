import uvm_pkg::*;
import FIFO_test_pkg::*;
`include "uvm_macros.svh"

module FIFO_top();
    logic clk;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    FIFO_if fifoif(clk);

    FIFO #(.FIFO_WIDTH(fifoif.FIFO_WIDTH),.FIFO_DEPTH(fifoif.FIFO_DEPTH))
        dut (   
            fifoif.data_in, 
            fifoif.wr_en, 
            fifoif.rd_en, 
            fifoif.clk, 
            fifoif.rst_n, 
            fifoif.full, 
            fifoif.empty, 
            fifoif.almostfull, 
            fifoif.almostempty, 
            fifoif.wr_ack, 
            fifoif.overflow, 
            fifoif.underflow, 
            fifoif.data_out 
        );

    initial begin
        uvm_config_db #(virtual FIFO_if)::set(null,"uvm_test_top","FIFO_IF",fifoif);
        run_test("FIFO_test");
    end

endmodule
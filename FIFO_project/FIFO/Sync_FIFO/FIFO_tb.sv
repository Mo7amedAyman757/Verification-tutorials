import FIFO_transaction_pkg::*;
import shared_pkg::*;

module FIFO_tb(FIFO_if.TEST fifo_vif);
    FIFO_transaction F_txn = new();

    initial begin
        #1;
        repeat(2) begin
            fifo_vif.rst_n   = 0;
            fifo_vif.wr_en   = 0;
            fifo_vif.rd_en   = 0;
            fifo_vif.data_in = 0; 
            @(negedge fifo_vif.clk);
            -> fifo_vif.drv_done;
        end

        fifo_vif.rst_n = 1;
        @(negedge fifo_vif.clk);
        -> fifo_vif.drv_done;

        // to check full flag
        repeat(10) begin
            fifo_vif.wr_en   = 1;
            fifo_vif.rd_en   = 0;  
            fifo_vif.data_in = $urandom_range(0, 255);   
             @(negedge fifo_vif.clk);
             -> fifo_vif.drv_done;
        end   

        fifo_vif.wr_en   = 1;       
        @(negedge fifo_vif.clk);
        -> fifo_vif.drv_done;
        fifo_vif.wr_en   = 0; 
        @(negedge fifo_vif.clk);
        -> fifo_vif.drv_done;

        // to check empty flag
        repeat(10) begin
            fifo_vif.rd_en   = 1;   
            fifo_vif.wr_en = 0;
            @(negedge fifo_vif.clk);
            -> fifo_vif.drv_done;
        end   

        fifo_vif.rd_en   = 1; 
        @(negedge fifo_vif.clk);
        -> fifo_vif.drv_done;
        fifo_vif.rd_en   = 0; 
        @(negedge fifo_vif.clk);
        -> fifo_vif.drv_done;

        repeat(10000) begin
            assert(F_txn.randomize());
            fifo_vif.rst_n   = F_txn.rst_n;
            fifo_vif.wr_en   = F_txn.wr_en;
            fifo_vif.rd_en   = F_txn.rd_en;
            fifo_vif.data_in = F_txn.data_in;
            @(negedge fifo_vif.clk);
            -> fifo_vif.drv_done;
        end

        test_finished = 1;
    end

endmodule
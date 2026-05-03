import FIFO_transaction_pkg::*;
import FIFO_coverage_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;

module FIFO_monitor(FIFO_if.MONITOR fifo_vif);
    FIFO_transaction F_txn;
    FIFO_coverage f_cov;
    FIFO_scoreboard f_scb;

    initial begin
        F_txn = new(); 
        f_cov = new();   
        f_scb = new(); 

        forever begin
            @(fifo_vif.drv_done);

            F_txn.data_in     = fifo_vif.data_in;
            F_txn.wr_en       = fifo_vif.wr_en;
            F_txn.rd_en       = fifo_vif.rd_en;
            F_txn.rst_n       = fifo_vif.rst_n;

            F_txn.data_out    = fifo_vif.data_out;
            F_txn.full        = fifo_vif.full;
            F_txn.almostfull  = fifo_vif.almostfull;
            F_txn.empty       = fifo_vif.empty;
            F_txn.almostempty = fifo_vif.almostempty;
            F_txn.overflow    = fifo_vif.overflow;
            F_txn.underflow   = fifo_vif.underflow;
            F_txn.wr_ack      = fifo_vif.wr_ack;       
            
            fork
                f_cov.sample_data(F_txn);
                f_scb.check_data(F_txn);
            join

            if(test_finished) begin
                $display("%t: Simulation Finished", $time);
                $display("  Correct: %0d  |  Errors: %0d", correct_count, error_count);
                $stop;    
            end
        end
    end

endmodule
package FIFO_scoreboard_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;

    class FIFO_scoreboard #(FIFO_WIDTH = 16, FIFO_DEPTH = 8);

        FIFO_transaction F_txn;

        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        localparam max_fifo_addr = $clog2(FIFO_DEPTH);
        reg [FIFO_WIDTH-1:0] queue_ref [FIFO_DEPTH-1:0];
        reg [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
        reg [max_fifo_addr:0] count_ref;

        task reference_model(FIFO_transaction F_txn);
           // $display("start reference model");
            if(!F_txn.rst_n) begin
                data_out_ref = 0; 
                wr_ack_ref = 0;   
                overflow_ref = 0;
                underflow_ref = 0;
                wr_ptr_ref = 0;
                rd_ptr_ref = 0;
                count_ref = 0;
                empty_ref = 1;
                full_ref = 0;
                almostfull_ref = 0;
                almostempty_ref = 0;
            end  else  begin
                // writing
                if(F_txn.wr_en && count_ref < FIFO_DEPTH) begin
                    queue_ref[wr_ptr_ref] = F_txn.data_in;
                    wr_ack_ref = 1;    
                    wr_ptr_ref += 1;
                end else begin
                    wr_ack_ref = 0;    
                end

                // reading
                if(F_txn.rd_en && count_ref != 0) begin
                    data_out_ref = queue_ref[wr_ptr_ref] ;
                    rd_ptr_ref += 1;    
                end

                // sequential flags
                if(count_ref == 0 && F_txn.rd_en) 
                    underflow_ref = 1; 
                else
                    underflow_ref = 0;

                // sequential flags
                if(count_ref == FIFO_DEPTH  && F_txn.wr_en) 
                    overflow_ref = 1; 
                else
                    overflow_ref = 0;

                if	( ({F_txn.wr_en, F_txn.rd_en} == 2'b10) && !full_ref) 
			        count_ref <= count_ref + 1;
                else if ( ({F_txn.wr_en, F_txn.rd_en} == 2'b01) && !empty_ref)
                    count_ref <= count_ref - 1;
                else if ({F_txn.wr_en, F_txn.rd_en} == 2'b11) begin
                    if(empty_ref)
                        count_ref <= count_ref + 1;
                    else if(full_ref)
                        count_ref <= count_ref - 1;
                end

                if(count_ref == FIFO_DEPTH) full_ref = 1; else full_ref = 0;
                if(count_ref == 0) empty_ref = 1; else empty_ref = 0;      
                if(count_ref == FIFO_DEPTH-1) almostfull_ref = 1; else almostfull_ref = 0;
                if(count_ref == 1) almostempty_ref = 1; else almostempty_ref = 0;

            end 

        endtask


        task check_data(FIFO_transaction F_txn);
            reference_model(F_txn);
            if(data_out_ref !== F_txn.data_out ||
               wr_ack_ref !== F_txn.wr_ack ||
               full_ref != F_txn.full ||
               overflow_ref !== F_txn.overflow ||
               empty_ref !== F_txn.empty ||
               almostfull_ref !== F_txn.almostfull ||
               almostempty_ref !== F_txn.almostempty ||
               underflow_ref !== F_txn.underflow) begin
                error_count++;
                //$display("%t:\n========== FIFO MISMATCH ==========",$time);
                // $display("DUT_INPUTS    : data_in=%0h wr_en=%0b rd_en=%0b rst_n=%0b",
                //         F_txn.data_in, F_txn.wr_en, F_txn.rd_en, F_txn.rst_n);

                // $display("ref_pointers  : wr_ptr_ref=%0b rd_ptr_ref=%0b count_ref=%0b",
                //         wr_ptr_ref, rd_ptr_ref, count_ref);

                // $display("DATA      : REF=0x%0h DUT=0x%0h",
                //           data_out_ref, F_txn.data_out);

                // $display("WR_ACK    : REF=%0b DUT=%0b", wr_ack_ref, F_txn.wr_ack);
                // $display("OVERFLOW  : REF=%0b DUT=%0b", overflow_ref, F_txn.overflow);
                // $display("UNDERFLow : REF=%0b DUT=%0b", underflow_ref, F_txn.underflow);
                // $display("FULL      : REF=%0b DUT=%0b", full_ref, F_txn.full);
                // $display("EMPTY     : REF=%0b DUT=%0b", empty_ref, F_txn.empty);
                // $display("almostfull      : REF=%0b DUT=%0b", almostfull_ref, F_txn.almostfull);
                // $display("almostempty     : REF=%0b DUT=%0b", almostempty_ref, F_txn.almostempty);

                // $display("==================================\n");
            end else begin
                    correct_count++;
                    //$display("%t:\n========== FIFO MATCH ==========",$time);
                    // $display("DUT_INPUTS    : data_in=%0h wr_en=%0b rd_en=%0b rst_n=%0b",
                    //     F_txn.data_in, F_txn.wr_en, F_txn.rd_en, F_txn.rst_n);

                    // $display("ref_pointers  : wr_ptr_ref=%0b rd_ptr_ref=%0b count_ref=%0d",
                    //         wr_ptr_ref, rd_ptr_ref, count_ref);

                    // $display("DATA      : REF=0x%0h DUT=0x%0h",
                    //         data_out_ref, F_txn.data_out);

                    // $display("WR_ACK    : REF=%0b DUT=%0b", wr_ack_ref, F_txn.wr_ack);
                    // $display("OVERFLOW  : REF=%0b DUT=%0b", overflow_ref, F_txn.overflow);
                    // $display("UNDERFLow : REF=%0b DUT=%0b", underflow_ref, F_txn.underflow);
                    // $display("FULL      : REF=%0b DUT=%0b", full_ref, F_txn.full);
                    // $display("EMPTY     : REF=%0b DUT=%0b", empty_ref, F_txn.empty);
                    // $display("almostfull      : REF=%0b DUT=%0b", almostfull_ref, F_txn.almostfull);
                    // $display("almostempty     : REF=%0b DUT=%0b", almostempty_ref, F_txn.almostempty);

                    // $display("==================================\n");
            end

        endtask

    endclass

endpackage
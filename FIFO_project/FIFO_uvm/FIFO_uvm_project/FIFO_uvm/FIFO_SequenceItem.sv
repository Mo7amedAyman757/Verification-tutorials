package FIFO_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class FIFO_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_sequence_item)

        rand logic [15:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        
        logic [15:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        function new(string name = "FIFO_sequence_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s rst_n = 0b%0b, wr_en = 0b%0b\n
                              rd_en = 0b%0b, data_in = 0b%0b\n
                              data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%b\n
                              full = 0b%0b, empty = 0b%0b, almostfull= 0b%0b\n
                              almostempty = 0b%0b, underflow = 0b%0b", super.convert2string(),
                              rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow,
                              full, empty, almostfull, almostempty, underflow);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n = 0b%0b, wr_en = 0b%0b\n
                              rd_en = 0b%0b, data_in = 0b%0b\n
                              data_out = 0b%0b, wr_ack = 0b%0b, overflow = 0b%b\n
                              full = 0b%0b, empty = 0b%0b, almostfull= 0b%0b,\n
                              almostempty = 0b%0b, underflow = 0b%0b",
                              rst_n, wr_en, rd_en, data_in, data_out, wr_ack, overflow,
                              full, empty, almostfull, almostempty, underflow);            
        endfunction

        // constraint
        constraint rst_cst{
            rst_n dist{0 := 2, 1 := 98};    
        }

        constraint wr_cst{
            wr_en dist{0 := 30, 1 := 70};    
        }

        constraint rd_cst{
            rd_en dist{0 := 70, 1 := 60};    
        }
    
    endclass

endpackage
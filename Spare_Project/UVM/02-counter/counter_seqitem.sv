package counter_seqitem_pkg;
import uvm_pkg::*;
import counter_pkg::*;
`include "uvm_macros.svh"

    class counter_seqitem extends uvm_sequence_item;
        `uvm_object_utils(counter_seqitem)
        rand logic rst_n;
        rand logic load_n;
        rand logic up_down;
        rand logic ce;
        rand logic [WIDTH-1:0] data_load;
        bit [WIDTH-1:0] count_out;
        bit max_count;
        bit zero;

        function new(string name = "counter_seqitem");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s rst_n = 0b%0b, load_n = 0b%0b
                              up_down = 0b%0b, ce = 0b%0b
                              data_load = 0b%0b, count_out = 0b%0b
                              max_count = 0b%0b, zero = 0b%0b", super.convert2string(),
                              rst_n, load_n, up_down, ce, data_load, count_out, max_count, zero);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst_n = 0b%0b, load_n = 0b%0b
                              up_down = 0b%0b, ce = 0b%0b
                              data_load = 0b%0b, count_out = 0b%0b
                              max_count = 0b%0b, zero = 0b%0b",
                              rst_n, load_n, up_down, ce, data_load, count_out, max_count, zero);            
        endfunction

        constraint rst_cst{
            rst_n dist {0:= 5, 1:= 95};
        }

        constraint load_cst{
            load_n dist{0:= 70, 1:= 30};   
        }

        constraint ce_cst{
            ce dist{0:= 30, 1:= 70};   
        }

        constraint up_down_cst{
            up_down dist{0:= 50, 1:= 50};   
        }


    endclass
    
endpackage
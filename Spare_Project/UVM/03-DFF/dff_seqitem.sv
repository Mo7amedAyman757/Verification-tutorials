package dff_seqitem_pkg;
import uvm_pkg::*;
import dff_pkg::*;
`include "uvm_macros.svh"

    class dff_seqitem extends uvm_sequence_item;
        `uvm_object_utils(dff_seqitem)
        rand logic rst, d, en;
        logic q;

        function new(string name = "dff_seqitem");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s rst = 0b%0b, d = 0b%0b, en = 0b%0b, q = 0b%0b", super.convert2string(),
                              rst, d, en, q);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst = 0b%0b, d = 0b%0b, en = 0b%0b, q = 0b%0b",
                              rst, d, en, q);            
        endfunction

        constraint rst_cst{
            rst dist{ 1:= 4, 0:= 96};
        }

        constraint en_cst{
            en dist{ 0:= 20, 1:= 80};
        }

        constraint d_cst{
            d dist{ 0 := 40, 1 := 60};
        }

    endclass
    
endpackage
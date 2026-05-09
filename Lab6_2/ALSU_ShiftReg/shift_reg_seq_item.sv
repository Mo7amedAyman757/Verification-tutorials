package shift_reg_seq_item_pkg;
import uvm_pkg::*;
import shared_pkg::*;
`include "uvm_macros.svh"

    class shift_reg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(shift_reg_seq_item)

        rand logic reset, serial_in;
        rand direction_e direction;
        rand mode_e mode;
        rand logic [5:0] datain;
        logic [5:0] dataout;

        function new(string name = "shift_reg_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s reset = 0b%0b, serial_in = 0b%0b
                              direction = 0b%0b, mode = 0b%0b
                              datain = 0b%0b, dataout = 0b%0b", super.convert2string(),
                              reset, serial_in, direction, mode, datain, dataout);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b, serial_in = 0b%0b
                              direction = 0b%0b, mode = 0b%0b
                              datain = 0b%0b, dataout = 0b%0b",
                              reset, serial_in, direction, mode, datain, dataout);            
        endfunction

        constraint reset_cst{
            reset dist{1 := 2, 0 := 98};
        }


    endclass

    
endpackage
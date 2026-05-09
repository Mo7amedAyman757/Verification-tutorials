package shiftreg_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"    
    
    class shiftreg_seq_item extends uvm_sequence_item;
        `uvm_object_utils(shiftreg_seq_item)

        rand logic reset, serial_in, direction, mode;
        rand logic [5:0] datain;
        logic [5:0] dataout;

        function new(string name = "shiftreg_seq_item");
            super.new(name);
        endfunction //new()

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

        // constraint
        constraint reset_cst{
            reset dist {0 := 97, 1 := 3};
        }

        constraint mode_cst{
            mode dist {0 := 50, 1 := 50};
        }

        constraint direction_cst{
            direction dist {0 := 50, 1 := 50};
        }

        constraint datain_cst{
            datain dist {[0:15] :/ 70, [16:31] :/ 30};
        }

    endclass //shiftreg_seq_item

endpackage
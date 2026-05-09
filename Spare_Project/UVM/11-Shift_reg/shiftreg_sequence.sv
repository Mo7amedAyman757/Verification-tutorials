package shiftreg_sequence_pkg;
import uvm_pkg::*;
import shiftreg_seq_item_pkg::*;
import shiftreg_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_reset_sequence extends uvm_sequence #(shiftreg_seq_item);
        `uvm_object_utils(shiftreg_reset_sequence)

        shiftreg_seq_item seq_item;

        function new(string name = "shiftreg_reset_sequence");
            super.new(name);
        endfunction //new()
        

        task body;
            seq_item = shiftreg_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.reset = 1;
            seq_item.mode = mode_e'(0);
            seq_item.direction = direction_e'(0);
            seq_item.serial_in = 0;
            seq_item.datain = 0;
            finish_item(seq_item);
        endtask;

    endclass

    class shiftreg_main_sequence extends uvm_sequence #(shiftreg_seq_item);
        `uvm_object_utils(shiftreg_main_sequence)

        shiftreg_seq_item seq_item;

        function new(string name = "shiftreg_main_sequence");
            super.new(name);
        endfunction //new()
        

        task body;
            seq_item = shiftreg_seq_item::type_id::create("seq_item");
            repeat(1000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end
        endtask;

    endclass
    
endpackage
package counter_sequence_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
`include "uvm_macros.svh"

    class counter_resetsequence extends uvm_sequence#(counter_seqitem);
        `uvm_object_utils(counter_resetsequence)

        counter_seqitem seq_item;

        function new(string name = "counter_resetsequence");
            super.new(name);
        endfunction

        task body();

            seq_item = counter_seqitem::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n = 0;
            seq_item.load_n = 0;
            seq_item.up_down = 0;
            seq_item.ce = 0;
            seq_item.data_load = 0;
            finish_item(seq_item);

        endtask

    endclass

    class counter_mainsequence extends uvm_sequence #(counter_seqitem);
        `uvm_object_utils(counter_mainsequence)

        counter_seqitem seq_item;

        function new(string name = "counter_mainsequence");
            super.new(name);
        endfunction
        
        task body();

            seq_item = counter_seqitem::type_id::create("seq_item");
            repeat(1000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end

        endtask


    endclass

endpackage
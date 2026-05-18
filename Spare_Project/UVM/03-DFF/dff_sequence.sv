package dff_sequence_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
`include "uvm_macros.svh"

    class dff_resetsequence extends uvm_sequence#(dff_seqitem);
        `uvm_object_utils(dff_resetsequence)

        dff_seqitem seq_item;

        function new(string name = "dff_resetsequence");
            super.new(name);
        endfunction

        task body();

            seq_item = dff_seqitem::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst = 0;
            seq_item.d = 0;
            seq_item.en = 0;
            finish_item(seq_item);

        endtask

    endclass

    class dff_mainsequence extends uvm_sequence #(dff_seqitem);
        `uvm_object_utils(dff_mainsequence)

        dff_seqitem seq_item;

        function new(string name = "dff_mainsequence");
            super.new(name);
        endfunction
        
        task body();

            seq_item = dff_seqitem::type_id::create("seq_item");
            repeat(1000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);
            end

        endtask

    endclass

endpackage
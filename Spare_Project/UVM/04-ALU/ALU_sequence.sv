package ALU_sequence_pkg;
import uvm_pkg::*;
import ALU_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"    

    class ALU_reset_sequence extends uvm_sequence #(ALU_seqitem);
        `uvm_object_utils(ALU_reset_sequence)
        
        ALU_seqitem seq_item;

        function new(string name = "ALU_reset_sequence");
            super.new(name);
        endfunction //new()

        task body();
            seq_item = ALU_seqitem::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.reset = 1;
            seq_item.Opcode = opcode_e'(0);
            seq_item.A = val_t'(0);
            seq_item.B = val_t'(0);
            finish_item(seq_item);
        endtask
        
    endclass

        class ALU_main_sequence extends uvm_sequence #(ALU_seqitem);
        `uvm_object_utils(ALU_main_sequence)
        
        ALU_seqitem seq_item;

        function new(string name = "ALU_main_sequence");
            super.new(name);
        endfunction //new()

        task body();
            seq_item = ALU_seqitem::type_id::create("seq_item");
            repeat(10000) begin
                start_item(seq_item);
                assert(seq_item.randomize());
                finish_item(seq_item);  
            end
        endtask
        
       
    endclass //ALU_seqitem 
    
endpackage
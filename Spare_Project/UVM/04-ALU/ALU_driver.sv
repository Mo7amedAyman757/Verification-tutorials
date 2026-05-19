package ALU_driver_pkg;
import uvm_pkg::*;
import ALU_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"    

    class ALU_driver extends uvm_driver #(ALU_seqitem);
        `uvm_component_utils(ALU_driver)
        
        virtual ALU_if ALU_vif;
        ALU_seqitem seq_item;

        function new(string name = "ALU_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            forever begin
                seq_item = ALU_seqitem::type_id::create("seq_item",this);
                seq_item_port.get_next_item(seq_item);
                ALU_vif.reset = seq_item.reset;
                ALU_vif.Opcode = seq_item.Opcode;
                ALU_vif.A = seq_item.A;
                ALU_vif.B = seq_item.B;
                @(negedge ALU_vif.clk);
                seq_item_port.item_done();    
            end

        endtask

    endclass //ALU_driver             

endpackage
package dff_driver_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
`include "uvm_macros.svh"

    class dff_driver extends uvm_driver #(dff_seqitem);
        `uvm_component_utils (dff_driver)

        virtual dff_if dff_vif;
        dff_seqitem dseq_item;

        function new(string name = "dff_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                dseq_item = dff_seqitem::type_id::create("dseq_item",this);  
                seq_item_port.get_next_item(dseq_item);
                dff_vif.rst = dseq_item.rst;
                dff_vif.d = dseq_item.d;
                dff_vif.en = dseq_item.en;
                @(negedge dff_vif.clk);
                seq_item_port.item_done();
            end

        endtask
        
    endclass

endpackage
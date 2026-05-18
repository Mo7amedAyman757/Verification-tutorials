package counter_driver_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
`include "uvm_macros.svh"

    class counter_driver extends uvm_driver #(counter_seqitem);
        `uvm_component_utils (counter_driver)

        virtual counter_if counter_vif;
        counter_seqitem dseq_item;

        function new(string name = "counter_driver", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                dseq_item = counter_seqitem::type_id::create("dseq_item",this);  
                seq_item_port.get_next_item(dseq_item);
                counter_vif.rst_n = dseq_item.rst_n;
                counter_vif.load_n = dseq_item.load_n;
                counter_vif.up_down = dseq_item.up_down;
                counter_vif.ce = dseq_item.ce;
                counter_vif.data_load = dseq_item.data_load;
                @(negedge counter_vif.clk);
                seq_item_port.item_done();
            end

        endtask
        
    endclass

endpackage
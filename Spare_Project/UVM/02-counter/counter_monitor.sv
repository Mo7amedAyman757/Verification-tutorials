package counter_monitor_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
`include "uvm_macros.svh"

    class counter_monitor extends uvm_monitor;
        `uvm_component_utils (counter_monitor)

        virtual counter_if counter_vif;
        counter_seqitem rseq_item;
        uvm_analysis_port #(counter_seqitem) mon_ap;

        function new(string name = "counter_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                rseq_item = counter_seqitem::type_id::create("rseq_item",this);  
                @(negedge counter_vif.clk);
                rseq_item.rst_n = counter_vif.rst_n;
                rseq_item.load_n = counter_vif.load_n;
                rseq_item.up_down = counter_vif.up_down;
                rseq_item.ce = counter_vif.ce;
                rseq_item.data_load = counter_vif.data_load;
                rseq_item.count_out = counter_vif.count_out;
                rseq_item.max_count = counter_vif.max_count;
                rseq_item.zero = counter_vif.zero;
                mon_ap.write(rseq_item);
            end

        endtask
        
    endclass

endpackage
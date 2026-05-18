package dff_monitor_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
`include "uvm_macros.svh"

    class dff_monitor extends uvm_monitor;
        `uvm_component_utils (dff_monitor)

        virtual dff_if dff_vif;
        dff_seqitem rseq_item;
        uvm_analysis_port #(dff_seqitem) mon_ap;

        function new(string name = "dff_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);

            forever begin
                rseq_item = dff_seqitem::type_id::create("rseq_item",this);  
                @(negedge dff_vif.clk);
                rseq_item.rst = dff_vif.rst;
                rseq_item.d = dff_vif.d;
                rseq_item.en = dff_vif.en;
                rseq_item.q = dff_vif.q;
                mon_ap.write(rseq_item);
            end

        endtask
        
    endclass

endpackage
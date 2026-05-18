package dff_coverage_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
import dff_pkg::*;
import dff_config_pkg::*;
`include "uvm_macros.svh"

    class dff_coverage extends uvm_component;
        `uvm_component_utils(dff_coverage)

        uvm_analysis_export #(dff_seqitem) cov_exp;
        uvm_tlm_analysis_fifo #(dff_seqitem) cov_fifo;
        dff_seqitem cov_seqitem;

         covergroup dff_cvg;

            d_cvg : coverpoint cov_seqitem.d iff(cov_seqitem.en){
                bins d_bins[] = {[0:1]};
            }

        endgroup

        function new(string name = "dff_coverage", uvm_component parent = null);
            super.new(name, parent);
            dff_cvg = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            cov_exp = new("cove_exp",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            cov_exp.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super. run_phase(phase);
            forever begin
                cov_fifo.get(cov_seqitem);
                dff_cvg.sample();
            end
        endtask

    endclass

endpackage
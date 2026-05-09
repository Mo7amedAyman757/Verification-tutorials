package shiftreg_coverage_pkg;
import uvm_pkg::*;
import shiftreg_seq_item_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_coverage extends uvm_component;
        `uvm_component_utils(shiftreg_coverage)

        uvm_analysis_export #(shiftreg_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(shiftreg_seq_item) cov_fifo;
        shiftreg_seq_item seq_item_cov;

        // covergroup
         covergroup shiftreg_cvg;

            mode_cvg : coverpoint seq_item_cov.mode{
                bins mode_1 = {0};
                bins mode_2 = {1};
            }
            direction_cvg : coverpoint seq_item_cov.direction{
                bins dir_1 = {0};
                bins dir_2 = {1};
            }
            datain_cvg : coverpoint seq_item_cov.datain{
                bins datain_1 = {[0:15]};
                bins datain_2 = {[16:31]};
            }

            cross mode_cvg, direction_cvg;

        endgroup

        function new(string name = "shiftreg_coverage", uvm_component parent = null);
            super.new(name,parent);
            shiftreg_cvg = new;
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase (phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                shiftreg_cvg.sample();
            end

        endtask

    endclass

endpackage
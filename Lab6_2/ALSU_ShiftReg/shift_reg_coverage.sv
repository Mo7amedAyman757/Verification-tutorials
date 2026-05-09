package shift_reg_coverage_pkg;
import uvm_pkg::*;
import shift_reg_seq_item_pkg::*;
`include "uvm_macros.svh"

    class shift_reg_coverage extends uvm_component;
         `uvm_component_utils(shift_reg_coverage)
         uvm_analysis_export #(shift_reg_seq_item) cov_export;
         uvm_tlm_analysis_fifo #(shift_reg_seq_item) cov_fifo;
         shift_reg_seq_item seq_item_cov;


         // covergroup shift_register
         covergroup shift_register_cg;
            reset_cvg : coverpoint seq_item_cov.reset {
                bins reset_bins[] = {0, 1};
            }
            serial_in_cvg : coverpoint seq_item_cov.serial_in {
                bins serial_in_bins[] = {0, 1};
            }
            direction_cvg : coverpoint seq_item_cov.direction {
                bins direction_bins[] = {0, 1};
            }
            mode_cvg : coverpoint seq_item_cov.mode {
                bins mode_bins[] = {0, 1};
            }
            datain_cvg : coverpoint seq_item_cov.datain {
                bins datain_bins[] = {[0:63]};
            }
         endgroup

         function new(string name = "shift_reg_coverage", uvm_component parent = null);
            super.new(name,parent);
            shift_register_cg = new();
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

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                shift_register_cg.sample();
            end
        endtask

    endclass

endpackage
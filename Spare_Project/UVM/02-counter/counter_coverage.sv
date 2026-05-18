package counter_coverage_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
import counter_pkg::*;
import counter_config_pkg::*;
`include "uvm_macros.svh"

    class counter_coverage extends uvm_component;
        `uvm_component_utils(counter_coverage)

        uvm_analysis_export #(counter_seqitem) cov_exp;
        uvm_tlm_analysis_fifo #(counter_seqitem) cov_fifo;
        counter_seqitem cov_seqitem;

        // covergroup
        covergroup counter_cvg;

            load_cvg : coverpoint cov_seqitem.data_load iff(!cov_seqitem.load_n && cov_seqitem.rst_n);

            count_up_cvg : coverpoint cov_seqitem.count_out
                iff (cov_seqitem.rst_n && cov_seqitem.ce && cov_seqitem.up_down){
                    bins bin_trans[] = {[0: (2**WIDTH)-1]};
                }
            

            overflow_cfg : coverpoint cov_seqitem.count_out
                iff (cov_seqitem.rst_n && cov_seqitem.ce && cov_seqitem.up_down){
                    bins bin_overflow = ((2**WIDTH)-1 => 0);
                }
            

            count_down_cvg : coverpoint cov_seqitem.count_out
                iff (cov_seqitem.rst_n && cov_seqitem.ce && !cov_seqitem.up_down){
                    bins bin_trans[] = {[0: (2**WIDTH)-1]};
                }
            

            underflow_cfg : coverpoint cov_seqitem.count_out
                iff (cov_seqitem.rst_n && cov_seqitem.ce && !cov_seqitem.up_down){
                    bins bin_overflow = (0 => (2**WIDTH)-1);
                }
            
        endgroup

        function new(string name = "counter_coverage", uvm_component parent = null);
            super.new(name, parent);
            counter_cvg = new();
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
                counter_cvg.sample();
            end
        endtask

    endclass

endpackage
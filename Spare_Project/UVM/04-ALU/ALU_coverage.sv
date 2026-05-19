package ALU_coverage_pkg;
import uvm_pkg::*;
import ALU_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"   

    class ALU_coverage extends uvm_component;
        `uvm_component_utils(ALU_coverage)

        uvm_analysis_export #(ALU_seqitem) cov_export;
        uvm_tlm_analysis_fifo #(ALU_seqitem) cov_fifo;
        ALU_seqitem cov_seqitem;

        covergroup ALU_cvg;

            A_cvg : coverpoint cov_seqitem.A{
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
            }

            B_cvg : coverpoint cov_seqitem.B{
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
            }

            ocpode_cvg : coverpoint cov_seqitem.Opcode{
                bins bins_op[] ={Add, Sub, Not_A, ReductionOR_B};
                bins op_trans = (Add => Sub => Not_A => ReductionOR_B);
            }
            
            cross A_cvg, B_cvg;

        endgroup

        function new(string name = "ALU_coverage", uvm_component parent = null);
            super.new(name, parent);
            ALU_cvg = new();
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super. run_phase(phase);
            forever begin
                cov_fifo.get(cov_seqitem);
                ALU_cvg.sample();
            end
        endtask

    endclass
    
endpackage
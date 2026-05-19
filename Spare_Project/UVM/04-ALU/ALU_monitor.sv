package ALU_monitor_pkg;
import uvm_pkg::*;
import ALU_pkg::*;
import ALU_seqitem_pkg::*;
`include "uvm_macros.svh"    

    class ALU_monitor extends uvm_monitor;
        `uvm_component_utils(ALU_monitor)
        
        virtual ALU_if ALU_vif;
        ALU_seqitem rsp_seq_item;
        uvm_analysis_port #(ALU_seqitem) mon_ap;

        function new(string name = "ALU_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            forever begin
                rsp_seq_item = ALU_seqitem::type_id::create("rsp_seq_item",this);
                @(negedge ALU_vif.clk);
                rsp_seq_item.reset = ALU_vif.reset;
                rsp_seq_item.Opcode =  opcode_e'(ALU_vif.Opcode);
                rsp_seq_item.A = ALU_vif.A;
                rsp_seq_item.B = ALU_vif.B;
                mon_ap.write(rsp_seq_item);  
            end

        endtask

    endclass //ALU_driver             

endpackage
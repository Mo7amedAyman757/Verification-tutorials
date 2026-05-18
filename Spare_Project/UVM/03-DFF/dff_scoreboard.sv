package dff_scoreboard_pkg;
import uvm_pkg::*;
import dff_seqitem_pkg::*;
import dff_pkg::*;
import dff_config_pkg::*;
`include "uvm_macros.svh"

    class dff_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(dff_scoreboard)

        uvm_analysis_export #(dff_seqitem) sb_exp;
        uvm_tlm_analysis_fifo #(dff_seqitem) sb_fifo;
        dff_seqitem sb_seqitem;

        int correct_count , error_count;

        logic q_ref;


    
        function new(string name = "dff_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super. build_phase(phase);
            sb_exp = new("sb_exp",this);
            sb_fifo = new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super. connect_phase(phase);
            sb_exp.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super. run_phase(phase);
            forever begin
                sb_fifo.get(sb_seqitem);
                check_result(sb_seqitem);
            end
        endtask

        task check_result(dff_seqitem sb_seq_item);
        golden_model(sb_seq_item);
        if(q_ref != sb_seq_item.q) begin
            error_count++;
            $display("Error");
        end else begin
            correct_count++;
            $display("Pass");
        end
    endtask

    task golden_model(dff_seqitem sb_seq_item);
         if (sb_seq_item.rst)
            q_ref = 0;
        else if(USE_EN) begin
                if (sb_seq_item.en)
                    q_ref = sb_seq_item.d;
        end else begin
                q_ref = sb_seq_item.d;
        end
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transaction : %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transaction : %0d",error_count),UVM_MEDIUM);
    endfunction

    endclass

endpackage
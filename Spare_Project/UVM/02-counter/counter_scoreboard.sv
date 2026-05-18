package counter_scoreboard_pkg;
import uvm_pkg::*;
import counter_seqitem_pkg::*;
import counter_pkg::*;
import counter_config_pkg::*;
`include "uvm_macros.svh"

    class counter_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(counter_scoreboard)

        uvm_analysis_export #(counter_seqitem) sb_exp;
        uvm_tlm_analysis_fifo #(counter_seqitem) sb_fifo;
        counter_seqitem sb_seqitem;

        int correct_count , error_count;

        logic [3:0] count_out_ref;
        logic max_count_ref;
        logic zero_ref;

    
        function new(string name = "counter_scoreboard", uvm_component parent = null);
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

        task check_result(counter_seqitem sb_seq_item);
        golden_model(sb_seq_item);
        if(count_out_ref != sb_seq_item.count_out || zero_ref != sb_seq_item.zero || max_count_ref != sb_seq_item.max_count) begin
            error_count++;
            $display("Error");
        end else begin
            correct_count++;
            $display("Pass");
        end
    endtask

    task golden_model(counter_seqitem sb_seq_item);
        if(!sb_seq_item.rst_n) begin
            count_out_ref = 0;
        end 
        else if(!sb_seq_item.load_n) begin
            count_out_ref = sb_seq_item.data_load;
        end
        else if(sb_seq_item.ce)
            if (sb_seq_item.up_down)
                count_out_ref = count_out_ref + 1;
            else 
                count_out_ref = count_out_ref - 1;

        max_count_ref = (count_out_ref == {WIDTH{1'b1}})? 1:0;
        zero_ref = (count_out_ref == 0)? 1:0;
    endtask

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase",$sformatf("Total successful transaction : %0d",correct_count),UVM_MEDIUM);
        `uvm_info("report_phase",$sformatf("Total failed transaction : %0d",error_count),UVM_MEDIUM);
    endfunction

    endclass

endpackage
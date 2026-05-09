package shiftreg_scoreboard_pkg;
import uvm_pkg::*;
import shiftreg_seq_item_pkg::*;
`include "uvm_macros.svh"    

    class shiftreg_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(shiftreg_scoreboard)

        uvm_analysis_export #(shiftreg_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(shiftreg_seq_item) sb_fifo;
        shiftreg_seq_item seq_item_sb;

        logic [5:0] dataout_ref;
        int correct_count, error_count;

        function new(string name = "shiftreg_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase (phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                check_result(seq_item_sb);
            end
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase (phase);
            `uvm_info("report_phase",$sformatf("Total successful Transaction: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total failed Transaction: %0d",error_count),UVM_MEDIUM);

        endfunction

        task check_result(shiftreg_seq_item seq_item_sb);
        golden_model(seq_item_sb);
        if (seq_item_sb.dataout != dataout_ref) begin
            `uvm_error("run_phase",$sformatf("Comparison Failed, Transaction recieved by the DUT: %s while the reference out: 0b%0b",seq_item_sb.convert2string(),dataout_ref));
            error_count++;
        end else begin
            `uvm_info("run_phase",$sformatf("Correct DUT: %s",seq_item_sb.convert2string()),UVM_HIGH);
            correct_count++;    
        end

    endtask

    task golden_model(shiftreg_seq_item seq_item_sb);
        if (seq_item_sb.reset) begin
            dataout_ref = 0;
        end 
        
        else 
            if (seq_item_sb.mode) // rotate
                if (seq_item_sb.direction) // left
                    dataout_ref = {seq_item_sb.datain[4:0], seq_item_sb.datain[5]};
                else
                    dataout_ref = {seq_item_sb.datain[0], seq_item_sb.datain[5:1]};
            else // shift
                if (seq_item_sb.direction) // left
                    dataout_ref = {seq_item_sb.datain[4:0], seq_item_sb.serial_in};
                else
                    dataout_ref = {seq_item_sb.serial_in, seq_item_sb.datain[5:1]};    
    endtask

    endclass

endpackage
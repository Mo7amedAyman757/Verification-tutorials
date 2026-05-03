package FIFO_scoreboard_pkg;
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh"

    class FIFO_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(FIFO_scoreboard);

        uvm_analysis_export #(FIFO_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(FIFO_sequence_item) sb_fifo;
        FIFO_sequence_item sb_seq_item;

        // int correct_count = 0;
        // int error_count = 0;

        function new(string name = "FIFO_env", uvm_component parent = null);
            super.new(name,parent);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction

         task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(sb_seq_item);
            end
         endtask

    endclass

endpackage

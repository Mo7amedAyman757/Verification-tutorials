package ALSU_scoreboard_pkg;
import uvm_pkg::*;
import ALSU_seq_item_pkg::*;
import ALSU_pkg::*;
`include "uvm_macros.svh"
    
    class ALSU_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ALSU_scoreboard)

        uvm_analysis_export #(ALSU_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(ALSU_seq_item) sb_fifo;
        ALSU_seq_item seq_item_sb;

        int correct_count = 0;
        int error_count = 0;

        // Registered stimulus used by the golden model
        bit red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
        bit signed [1:0] cin_reg;
        bit [2:0] opcode_reg;
        bit signed [2:0] A_reg, B_reg;
        bit [15:0] leds_exp;
        bit signed [5:0] out_exp;

        function new(string name = "ALSU_scoreboard", uvm_component parent = null);
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
                sb_fifo.get(seq_item_sb);  
                // ref_model(seq_item_sb);
                // if(seq_item_sb.leds !== leds_exp || seq_item_sb.out !== out_exp) begin
                //     `uvm_error("LED_MISMATCH", $sformatf("Expected LEDs: %b, Got: %b", leds_exp, seq_item_sb.leds))
                //     error_count++;
                // end else begin
                //     `uvm_info("LED_MATCH", $sformatf("Expected LEDs: %b, Got: %b", leds_exp, seq_item_sb.leds), UVM_LOW)
                //     correct_count++;
                // end
            end
        endtask

    //     task reset_internals();
    //         {red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg} = 6'b00_0000;
    //         cin_reg = 2'b00;
    //         opcode_reg = 3'b000;
    //         {A_reg,B_reg} = 6'b000000;
    //         leds_exp   = 16'd0;
    //         out_exp    = 6'd0;
    //     endtask

    //     function bit is_invalid();
    //     bit invalid;
    //     if((red_op_A_reg || red_op_B_reg) && (opcode_reg > 3'b001))
    //         invalid = 1'b1;
    //     else if (opcode_reg == INVALID6 || opcode_reg == INVALID7) 
    //         invalid = 1'b1;
    //     else 
    //         invalid = 1'b0;
    //     return invalid;
    // endfunction

    //     task  ref_model(ALSU_seq_item seq_item_chk);
    //         if(is_invalid()) begin
    //             leds_exp = ~leds_exp;
    //         end else begin
    //             leds_exp = 0;
    //         end

    //         if(bypass_A_reg) 
    //             out_exp = A_reg;
    //         else if(bypass_B_reg)
    //             out_exp = B_reg;

    //         else if(is_invalid())
    //             out_exp = 0;

    //         else begin
    //             if(opcode_reg == OR) begin
    //                 if(red_op_A_reg) 
    //                     out_exp = |A_reg;
    //                 else if (red_op_B_reg)
    //                     out_exp = |B_reg;
    //                 else
    //                     out_exp = A_reg | B_reg;     
    //             end

    //             else if(opcode_reg == XOR) begin
    //                 if(red_op_A_reg) 
    //                     out_exp = ^A_reg;
    //                 else if (red_op_B_reg)
    //                     out_exp = ^B_reg;    
    //                 else
    //                     out_exp = A_reg ^ B_reg;   
    //             end

    //             else if(opcode_reg == ADD) 
    //                 out_exp = A_reg + B_reg + cin_reg;
                
    //             else if(opcode_reg == MULT)
    //                 out_exp = A_reg * B_reg;

    //             else if (opcode_reg == SHIFT) begin
    //                 if(direction_reg) 
    //                     out_exp = {out_exp[4:0], serial_in_reg};
    //                 else
    //                     out_exp = {serial_in_reg, out_exp[5:1]};
    //             end

    //             else if (opcode_reg == ROTATE) begin
    //                 if(direction_reg) 
    //                     out_exp = {out_exp[4:0], out_exp[5]};
    //                 else
    //                     out_exp = {out_exp[0], out_exp[5:1]};
    //             end
    //         end
    //         update_internals();
    //     endtask

    //     task update_internals();
    //         cin_reg = seq_item_sb.cin;
    //         red_op_A_reg = seq_item_sb.red_op_A;
    //         red_op_B_reg = seq_item_sb.red_op_B;
    //         bypass_A_reg = seq_item_sb.bypass_A;
    //         bypass_B_reg = seq_item_sb.bypass_B;
    //         direction_reg = seq_item_sb.direction;
    //         serial_in_reg = seq_item_sb.serial_in;
    //         opcode_reg = seq_item_sb.opcode;
    //         A_reg = seq_item_sb.A;
    //         B_reg = seq_item_sb.B;
    //     endtask

    //     function void report_phase(uvm_phase phase);
    //         super.report_phase(phase);
    //         `uvm_info("report_phase",$sformatf("total successful transactions: %0d",correct_count),UVM_MEDIUM);
    //         `uvm_info("report_phase",$sformatf("total failed transactions: %0d",error_count),UVM_MEDIUM);
    //     endfunction

    endclass

endpackage
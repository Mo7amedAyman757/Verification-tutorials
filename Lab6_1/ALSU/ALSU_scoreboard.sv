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
        logic red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
        logic cin_reg;
        logic [2:0] opcode_reg;
        logic signed [2:0] A_reg, B_reg;
        logic [15:0] leds_ref;
        logic signed [5:0] out_ref;

        function new(string name = "ALSU_scoreboard", uvm_component parent = null);
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

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);  
                ref_model(seq_item_sb);
                if(seq_item_sb.leds !== leds_ref || seq_item_sb.out !== out_ref) begin
                    $display("======================mismatch======================");
                    `uvm_error("LED_MISMATCH", $sformatf("Expected LEDs: %b, Got: %b",seq_item_sb.leds, leds_ref))
                    `uvm_error("Out_MISMATCH", $sformatf("Expected out: %b, Got: %b",seq_item_sb.out, out_ref))
                    `uvm_error("inputs", $sformatf("A: %b, B: %b, cin: %b, A_reg: %b, B_reg: %b, cin_reg: %b",seq_item_sb.A, seq_item_sb.B,seq_item_sb.cin, A_reg, B_reg, cin_reg))
                    `uvm_error("Opcode", $sformatf("opcode: %b, opcode_reg: %b",seq_item_sb.opcode, opcode_reg))
                    `uvm_error("reduction operation", $sformatf("red_op_A: %b, red_op_B: %b, red_op_A_reg: %b, red_op_B_reg: %b",seq_item_sb.red_op_A ,seq_item_sb.red_op_B ,red_op_A_reg, red_op_B_reg))
                    `uvm_error("bypass", $sformatf("bypass_A: %b, bypass_B: %b, bypass_A_reg: %b, bypass_B_reg: %b",seq_item_sb.bypass_A, seq_item_sb.bypass_B, bypass_A_reg, bypass_B_reg))
                    `uvm_error("shift", $sformatf("direction: %b, serial_in: %b, direction_reg: %b, serial_in_reg: %b",seq_item_sb.direction, seq_item_sb.serial_in, direction_reg, serial_in_reg))
                    error_count++;
                end else begin
                    $display("-----------------------MATCH-----------------------");
                    `uvm_info("MATCH", $sformatf("Expected LEDs: %b, Got: %b, out: %b, Got: %b",seq_item_sb.leds, leds_ref, seq_item_sb.out, out_ref), UVM_LOW)
                    correct_count++;
                end
            end
        endtask

        task reset_internals();
            {red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg} = 6'b00_0000;
            cin_reg = 1'b0;
            opcode_reg = 3'b000;
            {A_reg,B_reg} = 6'b000000;
            leds_ref   = 16'd0;
            out_ref    = 6'd0;
        endtask

        function bit is_invalid();
            bit invalid;
            if((red_op_A_reg || red_op_B_reg) && (opcode_reg > 3'b001))
                invalid = 1'b1;
            else if (opcode_reg == INVALID6 || opcode_reg == INVALID7) 
                invalid = 1'b1;
            else 
                invalid = 1'b0;
            return invalid;
        endfunction

        task  ref_model(ALSU_seq_item seq_item_chk);

            if(seq_item_chk.rst) begin
                reset_internals();
            end

            if(is_invalid()) begin
                leds_ref = ~leds_ref;
            end else begin
                leds_ref = 0;
            end

            if(bypass_A_reg && bypass_B_reg) 
                out_ref = A_reg;
            else if(bypass_A_reg) 
                out_ref = A_reg;
            else if(bypass_B_reg)
                out_ref = B_reg;

            else if(is_invalid())
                out_ref = 0;

            else begin
                if(opcode_reg == OR) begin
                    if(red_op_A_reg) 
                        out_ref = |A_reg;
                    else if (red_op_B_reg)
                        out_ref = |B_reg;
                    else
                        out_ref = A_reg | B_reg;     
                end

                else if(opcode_reg == XOR) begin
                    if(red_op_A_reg) 
                        out_ref = ^A_reg;
                    else if (red_op_B_reg)
                        out_ref = ^B_reg;    
                    else
                        out_ref = A_reg ^ B_reg;   
                end

                else if(opcode_reg == ADD) 
                    out_ref = A_reg + B_reg + cin_reg;
                
                else if(opcode_reg == MULT)
                    out_ref = A_reg * B_reg;

                else if (opcode_reg == SHIFT) begin
                    if(direction_reg) 
                        out_ref = {out_ref[4:0], serial_in_reg};
                    else
                        out_ref = {serial_in_reg, out_ref[5:1]};
                end

                else if (opcode_reg == ROTATE) begin
                    if(direction_reg) 
                        out_ref = {out_ref[4:0], out_ref[5]};
                    else
                        out_ref = {out_ref[0], out_ref[5:1]};
                end
            end
            update_internals();
        endtask

        task update_internals();
            cin_reg = seq_item_sb.cin;
            red_op_A_reg = seq_item_sb.red_op_A;
            red_op_B_reg = seq_item_sb.red_op_B;
            bypass_A_reg = seq_item_sb.bypass_A;
            bypass_B_reg = seq_item_sb.bypass_B;
            direction_reg = seq_item_sb.direction;
            serial_in_reg = seq_item_sb.serial_in;
            opcode_reg = seq_item_sb.opcode;
            A_reg = seq_item_sb.A;
            B_reg = seq_item_sb.B;
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("total successful transactions: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("total failed transactions: %0d",error_count),UVM_MEDIUM);
        endfunction

    endclass

endpackage
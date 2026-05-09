package ALSU_scoreboard_pkg;
import uvm_pkg::*;
import ALSU_pkg::*;
import ALSU_seqitem_pkg::*;
`include "uvm_macros.svh"

    class ALSU_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(ALSU_scoreboard)

        uvm_analysis_port #(ALSU_seqitem) sb_export;
        uvm_tlm_analysis_fifo #(ALSU_seqitem) sb_fifo;
        ALSU_seqitem seq_item_sb;

        bit cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
        bit [2:0] opcode_reg;
        bit signed [2:0] A_reg, B_reg;
        bit [15:0] leds_exp;
        bit signed [5:0] out_exp;

        int correct_count = 0;
        int error_count = 0;

        function new(string name = "ALSU_scoreboard", uvm_component parent = null);
            super.new(name,parent);    
        endfunction //new()

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
                check_result(seq_item_sb);
            end
        endtask
        
        function void report_phase(uvm_phase phase);
            super.report_phase (phase);
            `uvm_info("report_phase",$sformatf("Total successful Transaction: %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("Total failed Transaction: %0d",error_count),UVM_MEDIUM);
        endfunction

        task reset_internals;
            {red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg} = 6'b00_0000; 
            cin_reg = 1'b0;
            opcode_reg = 3'b000;
            {A_reg, B_reg} = 6'b000_000;   
            out_exp = 6'b0;
            leds_exp = 16'b0;
        endtask

        function bit isinvalid();
            bit invalid;
            if((opcode_reg == INVALID_6) || (opcode_reg == INVALID_7))
                invalid = 1;
            else if((opcode_reg > 3'b001) && (red_op_A_reg || red_op_B_reg))
                invalid = 1;
            else
                invalid = 0;
            return invalid;
        endfunction

        task update_internals();
            red_op_A_reg = seq_item_sb.red_op_A;
            red_op_B_reg = seq_item_sb.red_op_B;
            bypass_A_reg = seq_item_sb.bypass_A;
            bypass_B_reg = seq_item_sb.bypass_B;
            direction_reg = seq_item_sb.direction;
            serial_in_reg = seq_item_sb.serial_in;
            cin_reg = seq_item_sb.cin;
            opcode_reg = seq_item_sb.opcode;
            A_reg = seq_item_sb.A;
            B_reg = seq_item_sb.B; 
        endtask

        task check_result(ALSU_seqitem seq_item);
            golden_model(seq_item);
            if ((seq_item.out !== out_exp) || (seq_item.leds !== leds_exp)) begin
                error_count++;
                $display("%t: ERROR--> A = %0d B = %0d opcode = %0d red_op_A = %0d, red_op_B = %0d bypass_A_reg = %0d, bypass_B_reg = %0d direction_reg = %0d serial_in_reg = %0d",
                        $time, seq_item.A, seq_item.B, seq_item.opcode, seq_item.red_op_A, seq_item.red_op_B, seq_item.bypass_A, seq_item.bypass_B,
                        seq_item.direction, seq_item.serial_in);
                $display("out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                        seq_item.out, out_exp, seq_item.leds, leds_exp);   
            end else begin
                correct_count++;
                $display("%t: SUCCESS--> A = %0d B = %0d opcode = %0d  red_op_A = %0d, red_op_B = %0d bypass_A_reg = %0d, bypass_B_reg = %0d direction_reg = %0d serial_in_reg = %0d",
                        $time, seq_item.A, seq_item.B, seq_item.opcode, seq_item.red_op_A, seq_item.red_op_B, seq_item.bypass_A, seq_item.bypass_B,
                        seq_item.direction, seq_item.serial_in);
                $display("out = %0d,out_exp = %0d, leds = %0d, leds_exp = %0d",
                        seq_item.out, out_exp, seq_item.leds, leds_exp); 
            end
        endtask

        task golden_model(ALSU_seqitem seq_item);

            if(seq_item.rst) begin
                reset_internals(); 
                return;
            end 
            else begin

                if(isinvalid()) begin
                    leds_exp = ~leds_exp;    
                end else begin
                    leds_exp = 0;    
                end

                if (bypass_A_reg && bypass_B_reg)
                    out_exp = (INPUT_PRIORITY == "A")? A_reg: B_reg;
                else if (bypass_A_reg)
                    out_exp = A_reg;
                else if (bypass_B_reg)
                    out_exp = B_reg;
                else if (isinvalid()) 
                    out_exp = 0;

                else begin
                    case (opcode_reg)
                        OR: begin 
                            if (red_op_A_reg && red_op_B_reg)
                                out_exp = (INPUT_PRIORITY == "A")? |A_reg: |B_reg;
                            else if (red_op_A_reg) 
                                out_exp = |A_reg;
                            else if (red_op_B_reg)
                                out_exp = |B_reg;
                            else 
                                out_exp = A_reg | B_reg;
                        end
                        XOR: begin
                            if (red_op_A_reg && red_op_B_reg)
                            out_exp = (INPUT_PRIORITY == "A")? ^A_reg: ^B_reg;
                            else if (red_op_A_reg) 
                            out_exp = ^A_reg;
                            else if (red_op_B_reg)
                            out_exp = ^B_reg;
                            else 
                            out_exp = A_reg ^ B_reg;
                        end
                    ADD : begin
                        if (FULL_ADDER == "ON") begin
                            out_exp = A_reg + B_reg + cin_reg;
                        end else begin
                            out_exp = A_reg + B_reg;
                        end
                    end
                MULT : out_exp = A_reg * B_reg;
                SHIFT : begin
                    if (direction_reg)
                    out_exp = {out_exp [4:0], serial_in_reg};
                    else
                    out_exp = {serial_in_reg, out_exp [5:1]};
                end
                ROTATE : begin
                    if (direction_reg)
                    out_exp = {out_exp [4:0], out_exp [5]};
                    else
                    out_exp = {out_exp [0], out_exp [5:1]};
                end
                default: out_exp = 0;
                endcase
                end
            end
            update_internals();
        endtask

    endclass

endpackage
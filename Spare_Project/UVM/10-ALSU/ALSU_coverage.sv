package ALSU_coverage_pkg;
import uvm_pkg::*;
import ALSU_pkg::*;
import ALSU_seqitem_pkg::*;
`include "uvm_macros.svh"

    class ALSU_coverage extends uvm_component;
        `uvm_component_utils(ALSU_coverage)

        uvm_analysis_port #(ALSU_seqitem) cov_export;
        uvm_tlm_analysis_fifo #(ALSU_seqitem) cov_fifo;
        ALSU_seqitem seq_item_cov;

        covergroup AB_cvg;

            // Coverpoint A_cp will cover the following bins
            A_cvp_ADD_MULT : coverpoint seq_item_cov.A{
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_misc = default;
            }

            // If only the red_op_A is high
            A_cvp_red_op : coverpoint seq_item_cov.A iff (seq_item_cov.red_op_A){
                bins A_walking_ones[] = {3'b001, 3'b010, 3'b100};
            }

            // Coverpoint B_cp will cover the following bins
            B_cvp_ADD_MULT : coverpoint seq_item_cov.B{
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_misc = default;
            }

            // If only the red_op_B is high and red_op_A is low
            B_cvp_red_op : coverpoint seq_item_cov.B iff (!seq_item_cov.red_op_A && seq_item_cov.red_op_B){
                bins B_walking_ones[] = {3'b001, 3'b010, 3'b100};
            }

            // Create a cover point ALU_cp with the following bins
            opcode_cvg : coverpoint seq_item_cov.opcode{
                bins BINS_shift[] = {SHIFT, ROTATE};
                bins BINS_arith[] = {ADD, MULT};
                bins BINS_bitwise[] = {OR, XOR};
                illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
                bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }
            
            // Create a cover point for opcode ==> shift
            opcode_shift_cvg : coverpoint seq_item_cov.opcode{
                bins bins_shift = {SHIFT};
            }

            // Create a cover point for opcode ==> add
            opcode_Add_cvg : coverpoint seq_item_cov.opcode{
                bins bins_shift = {ADD};
            }

            opcode_not_bitwise_cp : coverpoint seq_item_cov.opcode{
                option.weight = 0;
                bins bins_not_bitwise[]= {[ADD:$]};
            }

            direction_cp : coverpoint seq_item_cov.direction{
                bins direction_val[] ={0,1};
            }

            red_op_A_cp : coverpoint seq_item_cov.red_op_A{
                bins red_op_A_val[] ={0,1};    
            }

            red_op_B_cp : coverpoint seq_item_cov.red_op_B{
                bins red_op_B_val[] ={0,1};    
            }

            // When the ALU is addition or multiplication, A and B should have taken all permutations of
            // maxpos, maxneg and zero.
            cross_ARITH_AB : cross A_cvp_ADD_MULT, B_cvp_ADD_MULT, opcode_cvg{
                ignore_bins ig_bins_shift = binsof(opcode_cvg.BINS_shift);
                ignore_bins ig_bins_bitwise = binsof(opcode_cvg.BINS_bitwise);
                ignore_bins ig_bins_trans = binsof(opcode_cvg.Bins_trans);
            }

            // When the ALU is addition, c_in should have taken 0 or 1
            cross_ARITH_cin : cross seq_item_cov.cin, opcode_Add_cvg;

            // When the ALSU is shifting or rotating, then direction must take 0 or 1
            cross_shift_direction : cross direction_cp, opcode_cvg{
                option.cross_auto_bin_max = 0;
                bins direction_bins_shift = binsof(direction_cp.direction_val) intersect {0,1} && binsof(opcode_cvg.BINS_shift);
            } 

            // When the ALSU is shifting, then shift_in must take 0 or 1
            cross_shift : cross seq_item_cov.serial_in, opcode_shift_cvg;


            // When the ALSU is OR or XOR and red_op_A is asserted, then A took all walking one patterns
            // (001, 010, and 100) while B is taking the value 0
            cross_reduction_A : cross opcode_cvg , A_cvp_red_op, B_cvp_ADD_MULT iff(seq_item_cov.red_op_A){
                ignore_bins B_max_bins  = binsof(B_cvp_ADD_MULT.B_data_min);
                ignore_bins B_min_bins  = binsof(B_cvp_ADD_MULT.B_data_max);
                ignore_bins ig_bins_shift = binsof(opcode_cvg.BINS_arith);
                ignore_bins ig_bins_bitwise = binsof(opcode_cvg.BINS_bitwise);
                ignore_bins ig_bins_trans = binsof(opcode_cvg.Bins_trans);
            }
            // When the ALSU is OR or XOR and red_op_B is asserted, then B took all walking one patterns
            // (001, 010, and 100) while A is taking the value 0
            cross_reduction_B : cross opcode_cvg , B_cvp_red_op, A_cvp_ADD_MULT iff(seq_item_cov.red_op_B){
                ignore_bins A_max_bins  = binsof(A_cvp_ADD_MULT.A_data_min);
                ignore_bins A_min_bins  = binsof(A_cvp_ADD_MULT.A_data_max);
                ignore_bins ig_bins_shift = binsof(opcode_cvg.BINS_arith);
                ignore_bins ig_bins_bitwise = binsof(opcode_cvg.BINS_bitwise);
                ignore_bins ig_bins_trans = binsof(opcode_cvg.Bins_trans);
            }

            // Covering the invalid case: reduction operation is activated while the opcode is not OR or XOR
            
            cross_invalid_A : cross red_op_A_cp, opcode_not_bitwise_cp{
                ignore_bins red_A_0 = binsof(red_op_A_cp.red_op_A_val) intersect {0};
                illegal_bins red_A_0_ill = binsof(red_op_A_cp.red_op_A_val) intersect {1} && binsof(opcode_not_bitwise_cp);
            }

            cross_invalid_B : cross red_op_B_cp, opcode_not_bitwise_cp{
                ignore_bins red_B_0 = binsof(red_op_B_cp.red_op_B_val) intersect {0};
                illegal_bins red_B_0_ill = binsof(red_op_B_cp.red_op_B_val) intersect {1} && binsof(opcode_not_bitwise_cp);
            }


        endgroup

        function new(string name = "ALSU_coverage", uvm_component parent = null);
            super.new(name,parent);    
            AB_cvg = new();
        endfunction //new()

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(seq_item_cov);
                AB_cvg.sample();
            end

        endtask


    endclass


endpackage
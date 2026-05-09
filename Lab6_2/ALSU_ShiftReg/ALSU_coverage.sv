package ALSU_coverage_pkg;
import uvm_pkg::*;
import ALSU_seq_item_pkg::*;
import ALSU_pkg::*;
`include "uvm_macros.svh"
    
        class ALSU_coverage extends uvm_component;
        `uvm_component_utils(ALSU_coverage)

        uvm_analysis_export #(ALSU_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(ALSU_seq_item) cov_fifo;
        ALSU_seq_item seq_item_cov;


        //covergroup
        covergroup cvr_gp;

            // Cover A values (corner cases + misc)
            A_cp1: coverpoint seq_item_cov.A {
                bins A_data_0 = {3'b000};
                bins A_data_max = {3'b011};
                bins A_data_min = {3'b100};
                bins A_data_default = default;
            }

            // Walking ones when red_op_A = 1
            A_cp2: coverpoint seq_item_cov.A iff(seq_item_cov.red_op_A){
                bins A_data_walkingones[] ={3'b001, 3'b010, 3'b100};
            }

            // Cover B values (corner cases + misc)
            B_cp1: coverpoint seq_item_cov.B {
                bins B_data_0 = {3'b000};
                bins B_data_max = {3'b011};
                bins B_data_min = {3'b100};
                bins B_data_default = default;
            }

            // Walking ones when red_op_B = 1
            B_cp2: coverpoint seq_item_cov.B iff(seq_item_cov.red_op_B  && !seq_item_cov.red_op_A ) {
                bins B_data_walkingones[] ={3'b001, 3'b010, 3'b100};
            }

            // Cover the opcode with the specified bins and transitions
            ALU_cp: coverpoint seq_item_cov.opcode{
                bins bins_shift[] = {SHIFT, ROTATE};
                bins bins_arith[] = {ADD, MULT};
                bins bins_bitwise[] = {OR, XOR};
                bins bins_invalid[] = {INVALID6, INVALID7};
                bins bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }

            opcode_cp: coverpoint seq_item_cov.opcode;

            cin_cp: coverpoint seq_item_cov.cin {
                bins cin_zero = {0};
                bins cin_one = {1};
            }

            dir_cp: coverpoint seq_item_cov.direction{
                bins dir_zero = {0};
                bins dir_one = {1};
            }

            shift_cp: coverpoint seq_item_cov.serial_in{
                bins shift_zero = {0};
                bins shift_one = {1};
            }

            redA_cp: coverpoint seq_item_cov.red_op_A{
                bins redA_on = {1};
                bins redA_off = {0};
            }

            redB_cp: coverpoint seq_item_cov.red_op_B{
                bins redB_on = {1};
                bins redB_off = {0};
            }

            add_mult_AB_cs : cross opcode_cp, A_cp1, B_cp1{
                option.cross_auto_bin_max = 0;
                bins add_mult_A_B = binsof(opcode_cp) intersect{ADD,MULT} &&
                                    binsof(A_cp1) intersect{MAXPOS, MAXNEG, ZERO} &&
                                    binsof(B_cp1) intersect{MAXPOS, MAXNEG, ZERO};
            }

            opcode_cin_cs : cross opcode_cp, cin_cp{
                option.cross_auto_bin_max = 0;
                bins opcode_cin = binsof(opcode_cp) intersect{ADD} &&
                                  binsof(cin_cp);
            }

            opcode_dir_cs : cross opcode_cp, dir_cp{
                option.cross_auto_bin_max = 0;
                bins opcode_dir = binsof(opcode_cp) intersect{SHIFT, ROTATE} &&
                                  binsof(dir_cp);
            }

            opcode_shift_cs : cross opcode_cp, shift_cp{
                option.cross_auto_bin_max = 0;
                bins opcode_shift = binsof(opcode_cp) intersect{SHIFT} &&
                                  binsof(shift_cp);
            }

            opcode_redA_walkA_cs : cross opcode_cp, redA_cp, A_cp2, B_cp1{
                option.cross_auto_bin_max = 0;
                bins opcode_redA_walkA = binsof(opcode_cp) intersect{OR,XOR} &&
                                         binsof(redA_cp.redA_on) &&
                                         binsof(A_cp2) &&
                                         binsof(B_cp1.B_data_0);
            }

            opcode_redB_walkB_cs : cross opcode_cp, redB_cp, B_cp2, A_cp1{
                option.cross_auto_bin_max = 0;
                bins opcode_redB_walkB = binsof(opcode_cp) intersect{OR,XOR} &&
                                         binsof(redB_cp.redB_on) &&
                                         binsof(B_cp2) &&
                                         binsof(A_cp1.A_data_0);
            }

            invalid_case_cs : cross opcode_cp, redA_cp, redB_cp{
                option.cross_auto_bin_max = 0;
                bins invalid_case = !binsof (opcode_cp) intersect{OR,XOR} &&
                                     (binsof(redB_cp.redB_on) || binsof(redA_cp.redA_on));
            } 

        endgroup

        function new(string name = "ALSU_coverage", uvm_component parent = null);
            super.new(name,parent);
            // create covergroup
            cvr_gp = new();
        endfunction

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
                // sample covergroup
                cvr_gp.sample();
            end
        endtask

    endclass


endpackage
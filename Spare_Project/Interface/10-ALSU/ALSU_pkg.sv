package ALSU_pkg;
import ALSU_enum::*;

    class ALSU_txn;

        rand logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand opcode_e opcode;
        rand opcode_e opcode_valid [VALID_OP];
        rand logic signed [2:0] A, B;
        rand reg_e enum_ext_A, enum_ext_B;
        rand logic signed [2:0] A_rem_values, B_rem_values;
        bit [2:0] walking_ones[] = '{3'b001, 3'b010, 3'b100}; 
        rand bit [2:0] walking_ones_t, walking_ones_f;

        // 1. Reset to be asserted with a low probability that you decide
        constraint rst_cst{
            rst dist {0 := 97, 1 := 3};
        }

        constraint red_op_cst{
            red_op_A dist {0 := 60, 1:= 30};
            red_op_B dist {0 := 60, 1:= 30};
        }

        constraint bypass_cst{
            // bypass_A and bypass_B should be disabled most of the time
            bypass_A dist {1 := 3, 0:= 97};
            bypass_B dist {1 := 3, 0:= 97};
        }

        constraint opcode_cst{
            // Invalid cases should occur less frequent than the valid cases
            opcode dist {[OR:ROTATE] := 90, [INVALID_6:INVALID_7] := 10};
        }

        constraint opcode_seq_cst{
            // Transition from opcode 0 > 1 > 2 > 3 > 4 > 5
            foreach(opcode_valid[i]) 
                opcode_valid[i] == opcode_e'(i);
        }

        constraint A_B_cst{
            A_rem_values != MAXPOS || ZERO || MAXNEG;
            B_rem_values != MAXPOS || ZERO || MAXNEG;
            walking_ones_t inside {walking_ones};
            !(walking_ones_f inside {walking_ones});

            if(opcode == XOR || opcode == OR){
                if(red_op_A == 1){
                    // If the opcode is OR or XOR and red_op_A is high, constraint the input A most of the time
                    // to have one bit high in its 3 bits while constraining the B bits to be low
                    B == 0;
                    A dist {walking_ones_t := 80, walking_ones_f := 20};
                } else if(red_op_B == 1){
                    // If the opcode is OR or XOR and red_op_B is high, constraint the input B most of the time
                    // to have one bit high in its 3 bits while constraining the A bits to be low
                    A == 0;
                    B dist {walking_ones_t := 80, walking_ones_f := 20};
                }
            } else if(opcode == ADD || opcode == MULT){
                    // Constraint for adder inputs (A, B) to take the values (MAXPOS, ZERO and MAXNEG)
                    // more often than the other values when the opcode is addition or multiplication
                    A dist {enum_ext_A := 80, A_rem_values := 20};    
                    B dist {enum_ext_B := 80, B_rem_values := 20}; 
            } else{
                    // Do not constraint the inputs A or B when the operation is shift or rotate    
            }
        }

        covergroup AB_cvg;

            // Coverpoint A_cp will cover the following bins
            A_cvp_ADD_MULT : coverpoint A{
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_misc = default;
            }

            // If only the red_op_A is high
            A_cvp_red_op : coverpoint A iff (red_op_A){
                bins A_walking_ones[] = {3'b001, 3'b010, 3'b100};
            }

            // Coverpoint B_cp will cover the following bins
            B_cvp_ADD_MULT : coverpoint B{
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_misc = default;
            }

            // If only the red_op_B is high and red_op_A is low
            B_cvp_red_op : coverpoint B iff (!red_op_A && red_op_B){
                bins B_walking_ones[] = {3'b001, 3'b010, 3'b100};
            }

            // Create a cover point ALU_cp with the following bins
            opcode_cvg : coverpoint opcode{
                bins BINS_shift[] = {SHIFT, ROTATE};
                bins BINS_arith[] = {ADD, MULT};
                bins BINS_bitwise[] = {OR, XOR};
                illegal_bins Bins_invalid = {INVALID_6, INVALID_7};
                bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }
            
            // Create a cover point for opcode ==> shift
            opcode_shift_cvg : coverpoint opcode{
                bins bins_shift = {SHIFT};
            }

            // Create a cover point for opcode ==> add
            opcode_Add_cvg : coverpoint opcode{
                bins bins_shift = {ADD};
            }

            opcode_not_bitwise_cp : coverpoint opcode{
                option.weight = 0;
                bins bins_not_bitwise[]= {[ADD:$]};
            }

            // When the ALU is addition or multiplication, A and B should have taken all permutations of
            // maxpos, maxneg and zero.
            cross_ARITH_AB : cross A_cvp_ADD_MULT, B_cvp_ADD_MULT, opcode_cvg{
                ignore_bins ig_bins_shift = binsof(opcode_cvg.BINS_shift);
                ignore_bins ig_bins_bitwise = binsof(opcode_cvg.BINS_bitwise);
                ignore_bins ig_bins_trans = binsof(opcode_cvg.Bins_trans);
            }

            // When the ALU is addition, c_in should have taken 0 or 1
            cross_ARITH_cin : cross cin, opcode_Add_cvg;

            // When the ALSU is shifting or rotating, then direction must take 0 or 1
            cross_shift_direction : cross direction, opcode_cvg{
                option.cross_auto_bin_max = 0;
                bins direction_bins_shift = binsof(direction) intersect {0,1} && binsof(opcode_cvg.BINS_shift);
            } 

            // When the ALSU is shifting, then shift_in must take 0 or 1
            cross_shift : cross serial_in, opcode_shift_cvg;


            // When the ALSU is OR or XOR and red_op_A is asserted, then A took all walking one patterns
            // (001, 010, and 100) while B is taking the value 0
            cross_reduction_A : cross opcode_cvg , A_cvp_red_op, B_cvp_ADD_MULT iff(red_op_A){
                ignore_bins B_max_bins  = binsof(B_cvp_ADD_MULT.B_data_min);
                ignore_bins B_min_bins  = binsof(B_cvp_ADD_MULT.B_data_max);
                ignore_bins ig_bins_shift = binsof(opcode_cvg.BINS_arith);
                ignore_bins ig_bins_bitwise = binsof(opcode_cvg.BINS_bitwise);
                ignore_bins ig_bins_trans = binsof(opcode_cvg.Bins_trans);
            }
            // When the ALSU is OR or XOR and red_op_B is asserted, then B took all walking one patterns
            // (001, 010, and 100) while A is taking the value 0
            cross_reduction_B : cross opcode_cvg , B_cvp_red_op, A_cvp_ADD_MULT iff(red_op_B){
                ignore_bins A_max_bins  = binsof(A_cvp_ADD_MULT.A_data_min);
                ignore_bins A_min_bins  = binsof(A_cvp_ADD_MULT.A_data_max);
                ignore_bins ig_bins_shift = binsof(opcode_cvg.BINS_arith);
                ignore_bins ig_bins_bitwise = binsof(opcode_cvg.BINS_bitwise);
                ignore_bins ig_bins_trans = binsof(opcode_cvg.Bins_trans);
            }

            // Covering the invalid case: reduction operation is activated while the opcode is not OR or XOR
            
            cross_invalid_A : cross red_op_A, opcode_not_bitwise_cp{
                ignore_bins red_A_0 = binsof(red_op_A) intersect {0};
                illegal_bins red_A_0_ill = binsof(red_op_A) intersect {1} && binsof(opcode_not_bitwise_cp);
            }

            cross_invalid_B : cross red_op_B, opcode_not_bitwise_cp{
                ignore_bins red_B_0 = binsof(red_op_B) intersect {0};
                illegal_bins red_B_0_ill = binsof(red_op_B) intersect {1} && binsof(opcode_not_bitwise_cp);
            }


        endgroup

        function new();
            AB_cvg = new();           
        endfunction

    endclass
    
endpackage
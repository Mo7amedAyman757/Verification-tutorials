package ALSU_seqitem_pkg;
import uvm_pkg::*;
import ALSU_pkg::*;
`include "uvm_macros.svh"    
    
    class ALSU_seqitem extends uvm_sequence_item;
        `uvm_object_utils(ALSU_seqitem)

        rand logic rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand logic [2:0] opcode;
        rand logic signed [2:0] A, B;
        rand opcode_e opcode_valid[VALID_OP];
        logic [15:0] leds;
        logic signed [5:0] out;

        // Declare the random variables for inputs A and B, and their corner cases and walking ones patterns
        rand reg_e enum_ext_A, enum_ext_B;
        rand logic signed [2:0] A_rem_values, B_rem_values;
        bit [2:0] walking_ones[] = '{3'b001, 3'b010, 3'b100}; 
        rand bit [2:0] walking_ones_t, walking_ones_f;

        function new(string name = "ALSU_seqitem");
            super.new(name);
        endfunction //new()

        function string convert2string();
            return $sformatf("%s rst = 0b%0b, cin = 0b%0b
                              red_op_A = 0b%0b, red_op_B = 0b%0b
                              bypass_A = 0b%0b, bypass_B = 0b%0b
                              direction = 0b%0b, serial_in = 0b%0b
                              opcode = 0b%0b, A = 0b%0b, B = 0b%0b
                              out = 0b%0b, leds = 0b%0b", super.convert2string(),
                              rst, cin, red_op_A, red_op_B, bypass_A, bypass_B,
                              direction, serial_in, opcode, A, B,
                              out, leds);            
        endfunction

        function string convert2string_stimulus();
            return $sformatf("rst = 0b%0b, cin = 0b%0b
                              red_op_A = 0b%0b, red_op_B = 0b%0b
                              bypass_A = 0b%0b, bypass_B = 0b%0b
                              direction = 0b%0b, serial_in = 0b%0b
                              opcode = 0b%0b, A = 0b%0b, B = 0b%0b
                              out = 0b%0b, leds = 0b%0b",
                              rst, cin, red_op_A, red_op_B, bypass_A, bypass_B,
                              direction, serial_in, opcode, A, B,
                              out, leds);            
        endfunction

        // constraints
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

    endclass //ALSU_seqitem

endpackage
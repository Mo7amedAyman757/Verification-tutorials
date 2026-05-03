package ALSU_seq_item_pkg;
import uvm_pkg::*;
import ALSU_pkg::*;
`include "uvm_macros.svh"

    parameter VALID_OP = 6;

    class ALSU_seq_item extends uvm_sequence_item;
        `uvm_object_utils(ALSU_seq_item)

        rand bit rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in; 
        rand opcode_e opcode; 
        rand opcode_e opcode_valid[VALID_OP];
        rand bit signed [2:0] A; 
        rand bit signed [2:0] B;
        bit [5:0] out;
        bit [15:0] leds; 

        // Declare the random variables for inputs A and B, and their corner cases and walking ones patterns
        rand reg_e enum_ext_A, enum_ext_B;
        rand logic [2:0] A_rem_val, B_rem_val;

        bit [2:0] walking_ones[] = '{3'b100, 3'b010, 3'b001};
        rand bit [2:0] walking_ones_t, walking_ones_f;

        function new(string name = "ALSU_seq_item");
            super.new(name);
        endfunction

       function string convert2string();         
            return $sformatf("%s reset=%0b cin=%0b red_op_A=%0b red_op_B=%0b bypass_A=%0b bypass_B=%0b direction=%0b serial_in=%0b opcode=%0b A=%0d B=%0d out=%0d leds=%0d",
                            super.convert2string(),
                            rst, cin, red_op_A, red_op_B, bypass_A, bypass_B,
                            direction, serial_in, opcode, A, B, out, leds);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = 0b%0b, cin = 0b%0b,red_op_A = 0b%0b, red_op_B = 0b%0b, bypass_A = 0b%0b, bypass_B = 0b%0b, direction = 0b%0b , serial_in = 0b%0b , opcode = 0b%0b , A = 0b%0b , B = 0b%0b, out = 0b%b, leds = 0b%b",
                              rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in, opcode, A, B,out, leds);           
        endfunction


        // constraints 
        //1. Reset to be asserted with a low probability that you decide.
        constraint rst_cst{
            rst dist{0:= 99, 1:= 1};
        } 

        //2. The inputs A and B to be mostly zero, with some random values.
        constraint A_B_cst{
            walking_ones_t inside{walking_ones}; // Constrain the walking_ones_t to be one of the patterns in walking_ones
            !(walking_ones_f inside {walking_ones}); // Constrain the walking_ones_f to not be any of the patterns in walking_ones
            !(A_rem_val inside {enum_ext_A}); // Constrain A_rem_val to not be any of the corner cases
            !(B_rem_val inside {enum_ext_B}); // Constrain B_rem_val to not be any of the corner cases            

            // If the opcode is OR or XOR 
            if ((opcode == OR) || (opcode == XOR)){
                // red_op_A is high, constraint the input A most of the time
                // to have one bit high in its 3 bits while constraining the B bits to be low
                if (red_op_A == 1){
                    A dist {walking_ones_t := 90, walking_ones_f := 10};
                    B == 3'b000;
                }
                // red_op_B is high, constraint the input B most of the time
                // to have one bit high in its 3 bits while constraining the A bits to be low
                else if (red_op_B == 1){
                    B dist {walking_ones_t := 90, walking_ones_f := 10};
                    A == 3'b000;
                }
            } else {
                red_op_A dist {1:= 10, 0 := 90}; 
                red_op_B dist {1:= 10, 0 := 90};
                // If the opcode is ADD or MULT, constraint the inputs A and B  to take the values (MAXPOS, ZERO and MAXNEG) with higher probability than the other values
                if ((opcode == ADD) || (opcode == MULT)){
                A dist {enum_ext_A := 90, A_rem_val := 10};
                B dist {enum_ext_B := 90, B_rem_val := 10};
            } 
            } 
        }
 

        // 3. The opcode to be mostly OR, XOR, ADD, MULT, ROTATE, SHIFT, with some random values for the other operations.
        // will be used while turning off opcode_arr_cst to allow random values in the opcode_arr which will be used in the covergroup to cover the transitions between all the operations.
        constraint opcode_cst{
            opcode dist{[OR:ROTATE] := 90, [INVALID6:INVALID7] := 10};
        }

        // 4. The bypass signals to be mostly disabled, with some random values.
        constraint bypass_cst{
            bypass_A dist{0:= 95, 1:= 5};
            bypass_B dist{0:= 95, 1:= 5};
        }

        // Create a fixed array of 6 elements of type opcode_e. constraint the elements of the array using
        // foreach to have a unique valid value each time randomization occurs.
        // will be used in the covergroup to cover all the operations and the transitions between them while turning off opcode_cst to allow the array to be randomized with values from OR to ROTATE.
        constraint opcode_seq_con{
            foreach(opcode_valid[i])
                foreach(opcode_valid[j]){
                    if(i != j){
                    opcode_valid[i] != opcode_valid[j];
                    opcode_valid[i] inside {[OR:ROTATE]};
                    }
                }         
        }
    endclass
    
endpackage
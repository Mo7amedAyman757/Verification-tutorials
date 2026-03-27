package ALSU_pkg;

    typedef enum bit [2:0] { OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID6, INVALID7 } opcode_t;
    typedef enum bit [2:0] { ZERO = 3'b000, MAXPOS = 3'b011, MAXNEG = 3'b100} reg_e;

    class ALSU_cst;
        rand logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        rand opcode_t opcode;
        rand logic [2:0] A, B;
        rand reg_e A_val, B_val;
        rand bit [2:0] A_val_ext, B_val_ext;
        bit [2:0] walking_ones[] = '{3'b100, 3'b010, 3'b001};
        rand bit [2:0] walking_ones_t, walking_ones_f;

        //1. Reset to be asserted with a low probability that you decide.
        constraint rst_cst{
            rst dist{0:= 99, 1:= 1};
        } 

        //2. The inputs A and B to be mostly zero, with some random values.
        constraint A_B_cst{
            walking_ones_t inside{walking_ones}; // Constrain the walking_ones_t to be one of the patterns in walking_ones
            !(walking_ones_f inside {walking_ones}); // Constrain the walking_ones_f to not be any of the patterns in walking_ones
            !(A_val_ext inside {A_val}); // Constrain A_val_ext to not be any of the values in A_val_ext (which is effectively no constraint since it's a random variable)
            !(B_val_ext inside {B_val}); // Constrain B_val_ext to not be any of the values in B_val_ext (which is effectively no constraint since it's a random variable)
            
            // If the opcode is ADD or MULT, constraint the inputs A and B  to take the values (MAXPOS, ZERO and MAXNEG) with higher probability than the other values
            if ((opcode == ADD) || (opcode == MULT)){
                red_op_A dist {1:= 10, 0 := 90}; 
                red_op_B dist {1:= 10, 0 := 90};
                A dist {A_val := 90, A_val_ext := 10};
                B dist {B_val := 90, B_val_ext := 10};
            } 
            else {
                // If the opcode is OR or XOR 
                if ((opcode == OR) || (opcode == XOR)){
                    // red_op_A is high, constraint the input A most of the time
                    // to have one bit high in its 3 bits while constraining the B bits to be low
                    if (red_op_A == 1){
                        A dist {walking_ones := 90, walking_ones_f := 10};
                        B == 3'b000;
                    }
                    // red_op_B is high, constraint the input B most of the time
                    // to have one bit high in its 3 bits while constraining the A bits to be low
                    else if (red_op_B == 1){
                        B dist {walking_ones := 90, walking_ones_f := 10};
                        A == 3'b000;
                    } 
                    // Do not constraint the inputs A or B when the operation is shift or rotate 
                    else{
                        // Do nothing
                    }     
                }
            }
        }

        // 3. The opcode to be mostly OR, XOR, ADD, MULT, ROTATE, SHIFT, with some random values for the other operations.
        constraint opcode_cst{
            opcode dist{[OR:ROTATE] := 90, [INVALID6:INVALID7] := 10};
        }

        // 4. The bypass signals to be mostly disabled, with some random values.
        constraint bypass_cst{
            bypass_A dist{0:= 95, 1:= 5};
            bypass_B dist{0:= 95, 1:= 5};
        }

    endclass
    
endpackage

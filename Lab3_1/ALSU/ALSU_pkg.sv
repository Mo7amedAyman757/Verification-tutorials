package ALSU_pkg;

    typedef enum bit [2:0] { OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID6, INVALID7 } opcode_e;
    typedef enum bit [2:0] { MAXPOS = 3'b011, ZERO = 3'b000, MAXNEG = 3'b100 } reg_e;

    class ALSU_cst;
        // Declare the random variables
        rand logic cin, rst, red_op_A, red_op_B;
        rand logic bypass_A, bypass_B, direction, serial_in;
        
        // Declare the random variable for opcode and an array of opcodes
        rand opcode_e opcode;
        rand opcode_e opcode_arr [0:5];

        // Declare the random variables for inputs A and B, and their corner cases and walking ones patterns
        rand logic [2:0] A, B;
        rand reg_e enum_ext_A, enum_ext_B;
        rand logic [2:0] A_rem_val, B_rem_val;

        bit [2:0] walking_ones[] = '{3'b100, 3'b010, 3'b001};
        rand bit [2:0] walking_ones_t, walking_ones_f;

        // Declare the clock signal for the covergroup
        bit clk;

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
        constraint opcode_arr_cst{

            foreach(opcode_arr[i]){
                opcode_arr[i] inside {[OR:ROTATE]};
            }
            unique{opcode_arr};
            
        }

        covergroup cvr_gp @(posedge clk);

            // Cover A values (corner cases + misc)
            A_cp1: coverpoint A {
                bins A_data_0 = {3'b000};
                bins A_data_max = {3'b011};
                bins A_data_min = {3'b100};
                bins A_data_default = default;
            }

            // Walking ones when red_op_A = 1
            A_cp2: coverpoint A iff(red_op_A){
                bins A_data_walkingones[] ={3'b001, 3'b010, 3'b100};
            }

            // Cover B values (corner cases + misc)
            B_cp1: coverpoint B {
                bins B_data_0 = {3'b000};
                bins B_data_max = {3'b011};
                bins B_data_min = {3'b100};
                bins B_data_default = default;
            }

            // Walking ones when red_op_B = 1
            B_cp2: coverpoint B iff(red_op_B  && !red_op_A ) {
                bins B_data_walkingones[] ={3'b001, 3'b010, 3'b100};
            }

            // Cover the opcode with the specified bins and transitions
            ALU_cp: coverpoint opcode{
                bins bins_shift[] = {SHIFT, ROTATE};
                bins bins_arith[] = {ADD, MULT};
                bins bins_bitwise[] = {OR, XOR};
                bins bins_invalid[] = {INVALID6, INVALID7};
                bins bins_trans1 = (OR => XOR );
                bins bins_trans2 = (OR => XOR => ADD );
                bins bins_trans3 = (OR => XOR => ADD => MULT );
                bins bins_trans4 = (OR => XOR => ADD => MULT => SHIFT);
                bins bins_trans5 = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
            }

        endgroup

        function new();
            cvr_gp = new();    
        endfunction

        // Sample task: only sample when not in reset or bypass mode
        task sample_coverage();
            if (!rst && !bypass_A && !bypass_B)
                cvr_gp.sample();
        endtask


    endclass
    
endpackage

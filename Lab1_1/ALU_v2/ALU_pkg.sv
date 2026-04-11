package ALU_pkg;
    
    typedef enum bit [1:0] {Add = 0, Sub, Not_A, ReductionOR_B} opcode_t;
    typedef enum {MAXNEG= -8, ZERO = 0, MAXPOS = 7} AB_Val;

    class ALU_transaction;
        rand bit reset;
        rand opcode_t Opcode;	// The opcode
        rand bit signed [3:0] A;	// Input data A in 2's complement
        rand bit  signed [3:0] B;	// Input data B in 2's complement
        rand AB_Val case_val;

        constraint reset_c{
            reset dist {1:= 3, 0:= 98};
        }

        constraint AB_c{
            A dist {case_val := 75, [-7:6] := 25};
            B dist {case_val := 75, [-7:6] := 25};
        }

        constraint opcode_c{
            Opcode dist { Add := 25, Sub := 25, Not_A := 25, ReductionOR_B := 25};    
        }
    endclass

endpackage

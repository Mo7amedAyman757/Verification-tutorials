package ALU_pkg;

    typedef enum logic [1:0] {Add, Sub, Not_A, ReductionOR_B} opcode_e;
    typedef enum logic signed [3:0] {MAXNEG = 4'sb1000, ZERO = 4'sb000, MAXPOS = 4'sb0111} val_t;
    
endpackage
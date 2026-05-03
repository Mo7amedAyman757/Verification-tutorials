package ALSU_pkg;

    typedef enum bit [2:0] { OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID6, INVALID7 } opcode_e;
    typedef enum bit [2:0] { MAXPOS = 3'b011, ZERO = 3'b000, MAXNEG = 3'b100 } reg_e;

endpackage
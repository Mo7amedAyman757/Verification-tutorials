package ALSU_enum;

    typedef enum bit [2:0] {OR, XOR, ADD, MULT, SHIFT, ROTATE, INVALID_6, INVALID_7} opcode_e;
    typedef enum bit [2:0] {ZERO = 3'b00, MAXPOS = 3'b011, MAXNEG = 3'b100} reg_e;
    parameter VALID_OP = 6;
    
endpackage
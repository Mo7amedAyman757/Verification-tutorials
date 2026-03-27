package ALU_pkg;
    
   typedef enum bit [2:0] {ADD, SUB, NOT_A, ReductionOR_B} opcode_e;

   class ALU_cls;
        rand bit reset;
        rand reg signed [3:0] A,B;
        rand opcode_e opcode;

        constraint rst_cst{
            reset dist {0:= 95, 1:= 5};   
        }
   endclass

endpackage

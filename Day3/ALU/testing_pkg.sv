package  testing_pkg;

    typedef enum logic [1:0] {ADD,SUB,MULT,DIV} opcode_e;
    parameter byte MAX_NEG = -128;
    parameter byte MAX_POS = 127;
    parameter byte ZERO    = 0;

    class transaction;
        rand byte operand1 ,operand2;
        rand bit rst;
        rand opcode_e opcode;
        bit clk;

        constraint rst_c { 
            rst dist{1'b1 := 2, 1'b0 := 98};
        }

        constraint operand_val{
            operand1 dist{ZERO:= 20, MAX_POS:= 35, MAX_NEG:= 35, [-127:126] := 10};
            operand2 dist{ZERO:= 20, MAX_POS:= 35, MAX_NEG:= 35, [-127:126] := 10};
        }
 
        covergroup CovCode @(posedge clk);

            opcode_cp: coverpoint opcode{
                bins add_sub = {ADD, SUB};
                bins add_then_sub = (ADD => SUB);
                illegal_bins no_div = {DIV};
            }

            operand1_cp: coverpoint operand1{
                bins max_neg = {MAX_NEG};
                bins max_pos = {MAX_POS};
                bins zero = {ZERO};
                bins misc = default;
            }

            opcode_operand1: cross opcode_cp , operand1_cp{
                option.weight = 5;
                option.cross_auto_bin_max = 0;
                bins maxpos_add_or_sub = binsof(operand1_cp.max_pos) &&  binsof(opcode_cp.add_sub);
                bins maxneg_add_or_sub = binsof(operand1_cp.max_neg) &&  binsof(opcode_cp.add_sub);
            }

        endgroup

        function new();
            CovCode = new();
        endfunction

    endclass

endpackage

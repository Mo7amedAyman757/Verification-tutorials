package ALU_pkg;

    typedef enum bit [1:0] {Add, Sub, Not_A, ReductionOR_B} opcode_e;
    typedef enum bit signed [3:0] {MAXNEG = 4'sb1000, ZERO = 4'sb000, MAXPOS = 4'sb0111} val_t;

    class ALU_transaction;
        rand logic reset;
        rand opcode_e Opcode;
        rand logic signed [3:0] A, B;	
        logic signed [4:0] C; 

        constraint rst_cst{
            reset dist{1 := 4, 0:= 96};
        }

        constraint A_cst{
            A dist{MAXNEG := 25, [-7:-1] := 10, ZERO := 25, [1:6] := 10, MAXPOS := 25};
        }

        constraint B_cst{
            B dist{MAXNEG := 25, [-7:-1] := 10, ZERO := 25, [1:6] := 10, MAXPOS := 25};
        }

        covergroup ALU_cvg;

            A_cvg : coverpoint A{
                bins A_data_0 = {ZERO};
                bins A_data_max = {MAXPOS};
                bins A_data_min = {MAXNEG};
                bins A_data_default = default;
            }

            B_cvg : coverpoint B{
                bins B_data_0 = {ZERO};
                bins B_data_max = {MAXPOS};
                bins B_data_min = {MAXNEG};
                bins B_data_default = default;
            }

            ocpode_cvg : coverpoint Opcode{
                bins bins_op[] ={Add, Sub, Not_A, ReductionOR_B};
                bins op_trans = (Add => Sub => Not_A => ReductionOR_B);
            }
            
            cross A_cvg, B_cvg;

        endgroup

        function new();
            ALU_cvg = new;    
        endfunction //new()

    endclass //ALU_transaction

endpackage


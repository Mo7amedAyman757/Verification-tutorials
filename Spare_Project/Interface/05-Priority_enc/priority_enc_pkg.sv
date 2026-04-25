package priority_enc_pkg;

    typedef enum bit [3:0] {out_00 = 4'b1000, out_01 = 4'b1100, out_10 = 4'b1110, out_11 = 4'b1111} onehot_t;
    class enc_transaction;

        rand logic rst;
        rand logic [3:0] D;
        rand onehot_t D_values;

        constraint rst_cst{
            rst dist {1 := 10, 0 := 90};
        }

        constraint D_cst{
            D dist {D_values := 90, [0:7] := 10, [9:11] := 10, (13) := 2};
        }

        covergroup D_cvg;
            D_bins : coverpoint D{
                bins D_bits [] = {out_00, out_01, out_10, out_11};
            }
        endgroup

        function new();
            D_cvg = new();
        endfunction

    endclass
    
endpackage